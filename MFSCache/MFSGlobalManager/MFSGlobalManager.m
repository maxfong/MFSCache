//
//  MFSGlobalManager.m
//  MFSCache
//
//  Created by maxfong on 15/7/6.
//  Copyright (c) 2015年 MFS. All rights reserved.
//  https://github.com/maxfong/MFSCache

#import "MFSGlobalManager.h"

@interface MFSGlobalManager ()

@property (nonatomic, strong) NSMutableDictionary *globalDatas;

@end

@implementation MFSGlobalManager

+ (MFSGlobalManager *)defaultManager {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = self.new;
    });
    return instance;
}

+ (void)setObject:(id)aObject forKey:(NSString *)aKey {
    if (!aKey.length) return;
    [[MFSGlobalManager defaultManager].globalDatas setValue:aObject forKey:aKey];
}

+ (id)objectForKey:(NSString *)aKey {
    if (!aKey.length) return nil;
    return [MFSGlobalManager defaultManager].globalDatas[aKey];
}

+ (void)removeObjectForKey:(NSString *)aKey {
    if (!aKey.length) return;
    [[MFSGlobalManager defaultManager].globalDatas removeObjectForKey:aKey];
}

- (NSMutableDictionary *)globalDatas {
    return _globalDatas ?: ({ _globalDatas = [NSMutableDictionary dictionary]; });
}

@end
