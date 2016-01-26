//
//  MFSFileStorage.h
//  MFSCache
//
//  Created by maxfong on 15/7/6.
//  Copyright (c) 2015年 maxfong. All rights reserved.
//  https://github.com/maxfong/MFSCache

#import <Foundation/Foundation.h>
#import "MFSFileStorageObject.h"

extern NSString * MFSFileStorageDefaultFinderName;

typedef NS_ENUM(NSUInteger, MFSFileStorageType) {
    MFSFileStorageCache         = 0,    //Memory
    MFSFileStorageArchiver
};

@interface MFSFileStorage : NSObject

/** 空间，suiteName以.document结尾则数据保存至Document */
@property (nonatomic, strong) NSString *suiteName;

+ (instancetype)defaultStorage;

- (void)setObject:(MFSFileStorageObject *)aObject forKey:(NSString *)aKey type:(MFSFileStorageType)t;

- (MFSFileStorageObject *)objectForKey:(NSString *)aKey;

- (void)removeObjectForKey:(NSString *)aKey;

//删除所有的默认文件，常用方法
- (void)removeDefaultObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock;
//删除过期的文件
- (void)removeExpireObjects;

/** 对所有空间做操作 */
/** 删除所有的默认文件，谨慎操作 */
+ (void)removeDefaultObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock;
/** 删除过期的文件，谨慎操作 */
+ (void)removeExpireObjects;

@end
