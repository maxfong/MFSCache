//
//  NSString+MFSEncrypt.h
//  MFSCache
//
//  Created by maxfong on 14-10-8.
//  Copyright (c) 2015年 maxfong. All rights reserved.
//  https://github.com/maxfong/MFSCache

#import <Foundation/Foundation.h>

@interface NSString (MFSEncrypt)

/** MD5 */
- (NSString *)md5;

/** aes128加密后转换base64，使用MFS默认Key&默认Iv */
- (NSString *)aesEncryptAndBase64Encode;
/** 转换base64并解密aes128，使用MFS默认Key&默认Iv */
- (NSString *)aesDecryptAndBase64Decode;

@end
