//
//  MFSCacheManager.h
//  MFSCache
//
//  Created by maxfong on 15/7/6.
//  Copyright (c) 2015年 maxfong. All rights reserved.
//  https://github.com/maxfong/MFSCache

#import <Foundation/Foundation.h>

extern NSString * const MFSCacheManagerObject;
extern NSString * const MFSCacheManagerObjectKey;
extern NSString * const MFSCacheManagerSetObjectNotification;   //缓存存数据
extern NSString * const MFSCacheManagerGetObjectNotification;   //缓存取数据
extern NSString * const MFSCacheManagerRemoveObjectNotification;//移除缓存

@interface MFSCacheManager : NSObject

/** 默认缓存管理器 */
+ (MFSCacheManager *)defaultManager;

/**
 *  nil suite means use the default search list that +defaultManager uses
 *  magic: suitename name end with ".document" then save data to Document
 */
- (instancetype)initWithSuiteName:(NSString *)suitename;

/** 根据Key缓存对象，默认duration为0：对象一直存在，清理后失效，object为nil则removeObject
 *  @param aObject 存储对象，支持String,URL,Data,Number,Dictionary,Array,Null,自定义实体类
 *  @param aKey    唯一的对应的值，相同的值对覆盖原来的对象 */
- (void)setObject:(id)aObject forKey:(NSString *)aKey;
/** 存储的对象的存在时间，duration默认为0，传-1，表示永久存在，不可被清理，只能手动移除或覆盖移除 
 *  @param duration 存储时间，单位:秒 */
- (void)setObject:(id)aObject forKey:(NSString *)aKey duration:(NSTimeInterval)duration;
/** 存储全局临时对象，toDisk为NO则不占用硬盘空间 */
- (void)setObject:(id)aObject forKey:(NSString *)aKey toDisk:(BOOL)toDisk;

/** 根据Key获取对象(数据相同内存值不同) */
- (id)objectForKey:(NSString *)aKey;

/** 根据Key移除缓存对象 */
- (void)removeObjectForKey:(NSString *)aKey;

/** 异步移除所有duration为0的缓存
 folderSize单位是字节，转换M需要folderSize/(1024.0*1024.0) */
- (void)removeObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock;
/** 异步检查缓存(duration大于0)的生命，删除过期缓存，建议App启动使用 */
- (void)removeExpireObjects;

/** 不区分空间，对所有数据进行删除，影响甚广，谨慎操作 */
+ (void)removeObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock;
/** 不区分空间，对所有缓存进行检查，谨慎操作 */
+ (void)removeExpireObjects;

@end
