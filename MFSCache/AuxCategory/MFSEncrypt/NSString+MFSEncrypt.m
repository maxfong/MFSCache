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

/** 可自行修改 */
static NSString *MFSDefaultAESKey = @"MFSCache.maxfong";
static const unsigned char AES_IV[] =
{ 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45 };

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

- (NSString *)aesEncryptAndBase64Encode {
    return [NSString mfs_aesEncryptAndBase64Encode:self withKey:MFSDefaultAESKey];
}

- (NSString *)aesDecryptAndBase64Decode {
    return [NSString mfs_aesDecryptAndBase64Decode:self withKey:MFSDefaultAESKey];
}

+ (NSString *)mfs_aesEncryptAndBase64Encode:(NSString *)string withKey:(NSString *)key {
    if (!string.length || !key.length) return nil;
    
    NSString *secret = nil;
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
    NSData *iv = [NSData dataWithBytes:AES_IV length:sizeof(AES_IV)];
    NSData *encrypt = [data mfs_AES128EncryptWithKey:key initVector:iv];
    if (encrypt) secret = [encrypt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return [secret stringByReplacingOccurrencesOfString:@"\\" withString:@""];//斜杠曾引起过问题
}

+ (NSString *)mfs_aesDecryptAndBase64Decode:(NSString *)string withKey:(NSString *)key {
    if (!string.length || !key.length) return nil;
    
    NSString *secret = nil;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *iv = [NSData dataWithBytes:AES_IV length:sizeof(AES_IV)];
    NSData *decrypt = [data mfs_AES128DecryptWithKey:key initVector:iv];
    if (decrypt) secret = [[NSString alloc] initWithData:decrypt encoding:NSASCIIStringEncoding];
    return secret;
}

@end
