//
//  MFSFileStorage.h
//  MFSCache
//
//  Created by maxfong on 15/7/6.
//  Copyright (c) 2015年 maxfong. All rights reserved.
//  https://github.com/maxfong/MFSCache

#import <Foundation/Foundation.h>
#import "MFSFileStorageObject.h"

typedef NS_ENUM(NSUInteger, MFSFileStorageType) {
    MFSFileStorageCache         = 0,    //Memory
    MFSFileStorageArchiver
};

@interface MFSFileStorage : NSObject

@property (nonatomic, strong) NSString *suiteName;  //空间

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
