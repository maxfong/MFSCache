//
//  NSData+MFSEncrypt.h
//  MFSCache
//
//  Created by maxfong on 15-01-01.
//  Copyright (c) 2015年 maxfong. All rights reserved.
//  https://github.com/maxfong/MFSCache

#import <Foundation/Foundation.h>

@interface NSData (MFSEncrypt)

/** data转base64字符串 */
- (NSString *)base64;

/** AES加密，需传入Key和iv */
- (NSData *)AES128EncryptWithKey:(NSString *)key initVector:(NSData *)iv;
/** AES解密，需传入Key和iv */
- (NSData *)AES128DecryptWithKey:(NSString *)key initVector:(NSData *)iv;

@end
