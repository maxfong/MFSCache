//
//  MFSCacheManager.m
//  MFSCache
//
//  Created by maxfong on 15/7/6.
//  Copyright (c) 2015年 maxfong. All rights reserved.
//  https://github.com/maxfong/MFSCache

#import "MFSCacheManager.h"
#import "MFSFileStorage.h"

NSString * const MFSCacheManagerObject = @"MFSCacheManagerObject";
NSString * const MFSCacheManagerObjectKey = @"MFSCacheManagerObjectKey";
NSString * const MFSCacheManagerSetObjectNotification = @"MFSCacheManagerSetObjectNotification";
NSString * const MFSCacheManagerGetObjectNotification = @"MFSCacheManagerGetObjectNotification";
NSString * const MFSCacheManagerRemoveObjectNotification = @"MFSCacheManagerRemoveObjectNotification";

@interface MFSCacheManager ()

@property (nonatomic, strong) NSString *suiteName;
@property (nonatomic, strong) MFSFileStorage *fileStorage;

@end

@implementation MFSCacheManager

+ (MFSCacheManager *)defaultManager {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = self.new; });
    return instance;
}

- (instancetype)initWithSuiteName:(NSString *)suitename {
    if (self = [self init]) {
        self.suiteName = suitename;
    }
    return self;
}

- (MFSFileStorage *)fileStorage {
    return _fileStorage ?: ({ MFSFileStorage *fileStorage = MFSFileStorage.new; fileStorage.suiteName = self.suiteName; _fileStorage = fileStorage; });
}

#pragma mark -
- (void)setObject:(id)aObject forKey:(NSString *)aKey {
    [self setObject:aObject forKey:aKey duration:0];
}
- (void)setObject:(id)aObject forKey:(NSString *)aKey duration:(NSTimeInterval)duration {
    if (!aKey) return;
    if (!aObject) {
        [self removeObjectForKey:aKey]; return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MFSCacheManagerSetObjectNotification object:@{MFSCacheManagerObject:aObject, MFSCacheManagerObjectKey:aKey}];
    MFSFileStorageObject *object = [[MFSFileStorageObject alloc] initWithObject:aObject];
    object.timeoutInterval = duration;
    if (object.storageString) [self.fileStorage setObject:object forKey:aKey type:MFSFileStorageArchiver];
}

- (void)setObject:(id)aObject forKey:(NSString *)aKey toDisk:(BOOL)toDisk {
    if (!aKey) return;
    if (!aObject) {
        [self removeObjectForKey:aKey]; return;
    }
    if (toDisk) {
        [self setObject:aObject forKey:aKey duration:0];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:MFSCacheManagerSetObjectNotification object:@{MFSCacheManagerObject:aObject, MFSCacheManagerObjectKey:aKey}];
        MFSFileStorageObject *object = [[MFSFileStorageObject alloc] initWithObject:aObject];
        if (object.storageString) [self.fileStorage setObject:object forKey:aKey type:MFSFileStorageCache];
    }
}

#pragma mark -
- (id)objectForKey:(NSString *)aKey {
    if (!aKey) return nil;
    MFSFileStorageObject *object = [self.fileStorage objectForKey:aKey];
    id returnObject = [object storageObject];
    if (!returnObject) return nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:MFSCacheManagerGetObjectNotification object:@{MFSCacheManagerObject:returnObject, MFSCacheManagerObjectKey:aKey}];
    return returnObject;
}
/** 异步根据Key获取缓存对象 */
- (void)objectKey:(NSString *)aKey completion:(void (^)(id obj))block {
    if (!aKey) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id obj = [self objectForKey:aKey];
        if (block) dispatch_async(dispatch_get_main_queue(), ^{ block(obj); });
    });
}

#pragma mark -
- (void)removeObjectForKey:(NSString *)aKey {
    if (!aKey) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:MFSCacheManagerRemoveObjectNotification object:@{MFSCacheManagerObjectKey:aKey}];
    [self.fileStorage removeObjectForKey:aKey];
}

- (void)removeObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock {
    [self.fileStorage removeDefaultObjectsWithCompletionBlock:completionBlock];
}
- (void)removeExpireObjects {
    [self.fileStorage removeExpireObjects];
}

+ (void)removeObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock {
    [MFSFileStorage removeDefaultObjectsWithCompletionBlock:completionBlock];
}
+ (void)removeExpireObjects {
    [MFSFileStorage removeExpireObjects];
}

@end
