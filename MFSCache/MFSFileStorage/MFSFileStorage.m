//
//  MFSFileStorage.m
//  MFSCache
//
//  Created by maxfong on 15/7/6.
//  Copyright (c) 2015年 maxfong. All rights reserved.
//  https://github.com/maxfong/MFSCache

#import "MFSFileStorage.h"
#import "NSString+MFSEncrypt.h"

#define kFileStorageDefaultFinderName @"storagefile"

@interface MFSFileStorage ()

@property (nonatomic, strong) NSMutableDictionary *storageCaches;
@property (nonatomic, strong) NSCache *storageArchivers;

@end

@implementation MFSFileStorage

+ (instancetype)defaultStorage {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = self.new; });
    return instance;
}

#pragma mark -
- (NSMutableDictionary *)storageCaches {
    return _storageCaches ?: ({ _storageCaches = NSMutableDictionary.new; });
}
- (NSCache *)storageArchivers {
    return _storageArchivers ?: ({ _storageArchivers = NSCache.new; });
}

#pragma mark - 保存对象
- (void)setObject:(MFSFileStorageObject *)aObject forKey:(NSString *)aKey {
    [self setObject:aObject forKey:aKey type:MFSFileStorageArchiver];
}

- (void)setObject:(MFSFileStorageObject *)aObject forKey:(NSString *)aKey type:(MFSFileStorageType)t {
    if (aKey.length > 0) {
        switch (t) {
            case MFSFileStorageCache: {
                [self.storageCaches setObject:aObject forKey:aKey];
            } break;
            case MFSFileStorageArchiver: {
                [self.storageArchivers setObject:aObject forKey:aKey];
                aObject.objectIdentifier = aKey;
                [self archiveObject:aObject];
            } break;
            default: break;
        }
    }
}

#pragma mark -
- (BOOL)synchronize {   //TODO:synchronize
    return NO;
}

#pragma mark - 获取对象
- (MFSFileStorageObject *)objectForKey:(NSString *)aKey {
    MFSFileStorageObject *object = [self.storageCaches objectForKey:aKey];
    if (!object) object = [self.storageArchivers objectForKey:aKey];
    if (!object) {
        NSString *filePath = [self filePathWithKey:aKey];
        if (filePath) {
            object = [self unarchiveObjectWithPath:filePath];
            if (object) [self.storageArchivers setObject:object forKey:aKey];
        }
    }
    return object;
}

#pragma mark - 删除文件
- (void)removeObjectForKey:(NSString *)aKey {
    [self.storageCaches removeObjectForKey:aKey];
    [self.storageArchivers removeObjectForKey:aKey];
    [MFSFileStorage.finderNames enumerateObjectsUsingBlock:^(NSString *finderName, NSUInteger idx, BOOL *stop) {
        NSString *filePath = [self filePathWithFileName:aKey finderName:finderName];
        if (filePath) [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }];
}
- (void)removeAllObjects {
    [self.storageCaches removeAllObjects];
    [self.storageArchivers removeAllObjects];
    NSString *finderPath = [self cachePathWithFinderName:nil];
    [[NSFileManager defaultManager] removeItemAtPath:finderPath error:nil];
}

//删除所有的永久文件
- (void)removePermanentObjects {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *permanentPath = [self cachePathWithFinderName:MFSFileStorage.finderNames[MFSFileStorageObjectIntervalAllTime]];
        [MFSFileStorage enumerateFilesWithPath:permanentPath usingBlock:^(NSString *fileName) {
            NSString *filePath = [permanentPath stringByAppendingString:fileName];
            BOOL isDir;
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir] && !isDir) {
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            }
        }];
    });
}
//删除所有的默认文件，常用方法
- (void)removeDefaultObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [self cachePathWithFinderName:MFSFileStorage.finderNames[MFSFileStorageObjectIntervalDefault]];
        __block long long folderSize = 0;
        [MFSFileStorage enumerateFilesWithPath:path usingBlock:^(NSString *fileName) {
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            BOOL isDir;
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir] && !isDir) {
                long long size = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
                folderSize += size;
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            }
        }];
        if (completionBlock) completionBlock(folderSize);
    });
}
//删除过期的文件
- (void)removeExpireObjects {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [self cachePathWithFinderName:MFSFileStorage.finderNames[MFSFileStorageObjectIntervalTiming]];
        [MFSFileStorage enumerateFilesWithPath:path usingBlock:^(NSString *fileName) {
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            BOOL isDir;
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir] && !isDir) {
                [self unarchiveObjectWithPath:filePath];
            }
        }];
    });
}

+ (void)removeDefaultObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[MFSFileStorage defaultStorage] cachePathWithFinderName:MFSFileStorage.finderNames[MFSFileStorageObjectIntervalDefault]];
        __block long long folderSize = 0;
        [MFSFileStorage enumerateFilesWithPath:path usingBlock:^(NSString *fileName) {
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            long long size = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
            folderSize += size;
        }];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        if (completionBlock) completionBlock(folderSize);
    });
}

+ (void)removeExpireObjects {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[MFSFileStorage defaultStorage] cachePathWithFinderName:MFSFileStorage.finderNames[MFSFileStorageObjectIntervalTiming]];
        [self removeExpireObjectsWithPath:path];
    });
}
+ (void)removeExpireObjectsWithPath:(NSString *)path {
    [MFSFileStorage enumerateFilesWithPath:path usingBlock:^(NSString *fileName) {
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir] && !isDir) {
            [[MFSFileStorage defaultStorage] unarchiveObjectWithPath:filePath];
        }
        else {
            [MFSFileStorage removeExpireObjectsWithPath:filePath];
        }
    }];
}

#pragma mark - archive/unarchive
- (void)archiveObject:(MFSFileStorageObject *)object {
    @synchronized(self) {
        //移除其他级别的文件，一个Key只保存一份
        [self removeObjectForKey:object.objectIdentifier];
        NSString *filePath = [self filePathWithObject:object];
        [NSKeyedArchiver archiveRootObject:object toFile:filePath];
    }
}
- (MFSFileStorageObject *)unarchiveObjectWithPath:(NSString *)path {
    if ([path hasSuffix:@".DS_Store"]) return nil;
    MFSFileStorageObject *object = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    switch (object.storageInterval) {
        case MFSFileStorageObjectIntervalTiming: {
            //验证对象生命情况
            NSDictionary *arrtibutes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            if (arrtibutes) {
                NSDate *createDate = arrtibutes[NSFileCreationDate];
                if (createDate) {
                    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:createDate];
                    BOOL valid = interval < object.timeoutInterval;
                    if (valid) return object;
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                });
            }
        }   break;
        case MFSFileStorageObjectIntervalDefault:
        case MFSFileStorageObjectIntervalAllTime: {
            return object;
        }   break;
    }
    return nil;
}

#pragma mark - 文件名操作
+ (NSArray *)finderNames {
    static NSArray *array;
    array = @[[@"storage0" md5], [@"storage1" md5], [@"storage2" md5]];
    return array;
}
- (NSString *)filePathWithObject:(MFSFileStorageObject *)object {
    NSString *finderName = MFSFileStorage.finderNames[object.storageInterval];
    return [self filePathWithFileName:object.objectIdentifier finderName:finderName];
}
- (NSString *)filePathWithKey:(NSString *)aKey {
    __block NSString *objectPath = nil;
    [MFSFileStorage.finderNames enumerateObjectsUsingBlock:^(NSString *finderName, NSUInteger idx, BOOL *stop) {
        NSString *filePath = [self filePathWithFileName:aKey finderName:finderName];
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if (exist) {
            objectPath = filePath;
            *stop = exist;
        }
    }];
    return objectPath;
}

#pragma mark - 目录操作
- (NSString *)filePathWithFileName:(NSString *)name finderName:(NSString *)finderName {
    if ([name length] <= 0) return nil;
    NSString *finderPath = [self cachePathWithFinderName:finderName];
    NSString *filePath = [NSString stringWithFormat:@"%@%@", finderPath, [name md5]];
    return filePath;
}
/** 根据目录名称获取缓存路径 */
- (NSString *)cachePathWithFinderName:(NSString *)finderName {
    NSString *cachesDirectory = [MFSFileStorage cachesDirectory];
    NSString *fileDirectory = [NSString stringWithFormat:@"%@%@/", cachesDirectory, [kFileStorageDefaultFinderName md5]];
    if (finderName.length > 0) {
        fileDirectory = [NSString stringWithFormat:@"%@%@/", fileDirectory, finderName];
    }
    //空间目录
    if (self.suiteName.length > 0) {
        fileDirectory = [NSString stringWithFormat:@"%@%@/", fileDirectory, [[self.suiteName md5] md5]];
    }
    if(fileDirectory && [[NSFileManager defaultManager] fileExistsAtPath:fileDirectory] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return fileDirectory;
}
/** 获取缓存主路径 */
+ (NSString *)cachesDirectory {
    static NSString *cacheDirectory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ cacheDirectory = [MFSFileStorage pathWithSearchDirectory:NSCachesDirectory]; });
    return cacheDirectory;
}
+ (NSString *)pathWithSearchDirectory:(NSSearchPathDirectory)searchDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(searchDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths firstObject];
    directory = [directory stringByAppendingString:@"/"];
    return directory;
}

/** 遍历路径的目录，返回所有的文件名 */
+ (void)enumerateFilesWithPath:(NSString *)path usingBlock:(void (^)(NSString *fileName))block {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) return;
    NSEnumerator *filesEnumerator = [[manager subpathsAtPath:path] objectEnumerator];
    NSString *fileName;
    while ((fileName = [filesEnumerator nextObject]) != nil) {
        block(fileName);
    }
}

@end
