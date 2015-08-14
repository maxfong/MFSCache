//
//  NSJSONSerialization+MFSJSONString.m
//  MFSCache
//
//  Created by maxfong on 15/7/7.
//  Copyright (c) 2015年 maxfong. All rights reserved.
//  https://github.com/maxfong/MFSCache

#import "NSJSONSerialization+MFSJSONString.h"

@implementation NSJSONSerialization (MFSJSONString)

+ (NSString *)stringWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError **)error {
    NSData *JSONData = [self dataWithJSONObject:obj options:opt error:error];
    NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    return JSONString;
}

//NSJSONReadingAllowFragments
+ (id)objectWithJSONString:(NSString *)string options:(NSJSONReadingOptions)opt error:(NSError **)error {
    NSData *JSONData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:JSONData options:opt error:nil];
}

@end
