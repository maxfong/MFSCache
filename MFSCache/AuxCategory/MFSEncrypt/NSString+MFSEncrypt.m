//
//  NSString+MFSEncrypt.m
//  MFSCache
//
//  Created by maxfong on 14-10-8.
//  Copyright (c) 2015年 maxfong. All rights reserved.
//  https://github.com/maxfong/MFSCache

#import "NSString+MFSEncrypt.h"
#import "CommonCrypto/CommonDigest.h"
#import "NSData-AES.h"
#import "mfs_GTMBase64.h"

/** 可自行修改 */
static NSString *MFSDefaultAESKey = @"MFSCache.maxfong";
static const unsigned char AES_IV[] =
{ 0x6D, 0x4A, 0x11, 0x3B, 0x53, 0x85, 0x1E, 0x9A, 0x33, 0x53, 0x07, 0x74, 0x2B, 0x8F, 0x98, 0x58 };

@implementation NSString (MFSEncrypt)

- (NSString *)md5 {
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

- (NSString *)base64 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [mfs_GTMBase64 stringByEncodingData:data];
}
- (NSData *)base64Decode {
    return [mfs_GTMBase64 decodeString:self];
}

- (NSString *)aesEncryptAndBase64Encode {
    return [NSString mfs_aesEncryptAndBase64Encode:self withKey:MFSDefaultAESKey];
}

- (NSString *)aesDecryptAndBase64Decode {
    return [NSString mfs_aesDecryptAndBase64Decode:self withKey:MFSDefaultAESKey];
}

+ (NSString *)mfs_aesEncryptAndBase64Encode:(NSString *)string withKey:(NSString *)key {
    if (!string.length || !key.length) return nil;
    
    NSString *secret = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *iv = [NSData dataWithBytes:AES_IV length:sizeof(AES_IV)];
    NSData *encrypt = [data mfs_AES128EncryptWithKey:key initVector:iv];
    if (encrypt) secret = [mfs_GTMBase64 stringByEncodingData:encrypt];
    return [secret stringByReplacingOccurrencesOfString:@"\\" withString:@""];//斜杠曾引起过问题
}

+ (NSString *)mfs_aesDecryptAndBase64Decode:(NSString *)string withKey:(NSString *)key {
    if (!string.length || !key.length) return nil;
    
    NSString *secret = nil;
    NSData *data = [mfs_GTMBase64 decodeString:string];
    NSData *iv = [NSData dataWithBytes:AES_IV length:sizeof(AES_IV)];
    NSData *decrypt = [data mfs_AES128DecryptWithKey:key initVector:iv];
    if (decrypt) secret = [[NSString alloc] initWithData:decrypt encoding:NSUTF8StringEncoding];
    return secret;
}

@end
