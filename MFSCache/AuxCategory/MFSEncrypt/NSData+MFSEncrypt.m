//
//  NSData+MFSEncrypt.m
//  MFSCache
//
//  Created by maxfong on 15-01-01.
//  Copyright (c) 2015年 maxfong. All rights reserved.
//  https://github.com/maxfong/MFSCache

#import "NSData+MFSEncrypt.h"
#import "NSData-AES.h"

@implementation NSData (MFSEncrypt)

- (NSString *)base64 {
    return [self mfs_base64EncodedString];
}
- (NSData *)AES128EncryptWithKey:(NSString *)key initVector:(NSData *)iv {
    return [self mfs_AES128EncryptWithKey:key initVector:iv];
}
- (NSData *)AES128DecryptWithKey:(NSString *)key initVector:(NSData *)iv {
    return [self mfs_AES128DecryptWithKey:key initVector:iv];
}

@end
