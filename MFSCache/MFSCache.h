//
//  MFSCache.h
//  MFSCache
//
//  Created by maxfong on 15/8/14.
//  Copyright (c) 2015年 MFS. All rights reserved.
//  Version 1.1.0 , updated_at 2016-01-26. https://github.com/maxfong/MFSCache

/**MFSCache是一套简单缓存数据的机制
 MFSCacheManager使用方式、性能效率都非常不错
 支持String, URL, Data, Number, Dictionary, Array, Null以及自定义实体类型
 增加缓存生命周期、缓存空间、数据安全加密、全局对象（伪单例）、快速缓存、分级、移除缓存
*/
#import "MFSCacheManager.h"

/** 数据存储内存
 使用场景：定义Key供不同模块使用 */
#import "MFSGlobalManager.h"

/** 开放的一些Encrypt类别 */
#import "NSString+MFSEncrypt.h"
