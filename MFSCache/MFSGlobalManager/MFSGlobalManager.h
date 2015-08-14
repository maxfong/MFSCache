//
//  MFSGlobalManager.h
//  MFSCache
//
//  Created by maxfong on 15/7/6.
//  Copyright (c) 2015年 MFS. All rights reserved.
//  https://github.com/maxfong/MFSCache

#import <Foundation/Foundation.h>

@interface MFSGlobalManager : NSObject

/** 根据Key缓存对象，object为nil则removeObject
 *  @param aObject 存储对象，支持对象类型
 *  @param aKey    唯一的对应的值，相同的值对覆盖原来的对象 */
+ (void)setObject:(id)aObject forKey:(NSString *)aKey;

/** 根据Key获取对象(数据相同内存值相同) */
+ (id)objectForKey:(NSString *)aKey;

/** 根据Key移除缓存对象 */
+ (void)removeObjectForKey:(NSString *)aKey;

@end
