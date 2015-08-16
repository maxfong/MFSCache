//
//  MFSCacheTests.m
//  MFSCacheTests
//
//  Created by maxfong on 15/8/14.
//  Copyright (c) 2015年 MFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MFSCacheManager.h"
#import "MFSTestObject.h"

@interface MFSCacheTests : XCTestCase

@end

@implementation MFSCacheTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCacheString {
    NSString *string = @"maxfong";
    [[MFSCacheManager defaultManager] setObject:string forKey:@"mfsCacheString"];
    NSLog(@"String存储前：%@", string);
    
    NSString *cache = [[MFSCacheManager defaultManager] objectForKey:@"mfsCacheString"];
    NSLog(@"String存储后：%@", cache);
}

- (void)testCacheNumber {
    NSNumber *number = @9527;
    [[MFSCacheManager defaultManager] setObject:number forKey:@"mfsCacheNumber"];
    NSLog(@"Number存储前：%@", number);
    
    NSNumber *cache = [[MFSCacheManager defaultManager] objectForKey:@"mfsCacheNumber"];
    NSLog(@"Number存储后：%@", cache);
}

- (void)testCacheArray {
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<2; i++) {
        SubTestObject *subObject = SubTestObject.new;
        subObject.name = @"subObject-Name";
        subObject.identifier = i;
        [array addObject:subObject];
    }
    
    [[MFSCacheManager defaultManager] setObject:array forKey:@"mfsCacheArray"];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"Array存储前：第%lu个对象：%@, identifier is:%lu", (unsigned long)idx+1, obj, (unsigned long)((SubTestObject *)obj).identifier);
    }];
    
    NSArray *cache = [[MFSCacheManager defaultManager] objectForKey:@"mfsCacheArray"];
    [cache enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"Array存储后：第%lu个对象：%@, identifier is:%lu", (unsigned long)idx+1, obj, (unsigned long)((SubTestObject *)obj).identifier);
    }];
}

- (void)testCacheDictionary {
    NSDictionary *dictionary = @{@"aKey":@"aObject"};
    [[MFSCacheManager defaultManager] setObject:dictionary forKey:@"mfsCacheDictionary"];
    NSLog(@"Dictionary存储前：%@", dictionary);
    
    NSDictionary *cache = [[MFSCacheManager defaultManager] objectForKey:@"mfsCacheDictionary"];
    NSLog(@"Dictionary存储后：%@", cache);
}

- (void)testCacheCustomObject {
    MFSTestObject *object = MFSTestObject.new;
    object.name = @"MFSCache";
    object.array = @[@"one item", @(9527), @{@"aKey":@"aObject"}];
    object.dictionary = @{@"aKey":@"aObject"};
    object.number = @1;
    object.nul = [NSNull null];
    
    SubTestObject *subObject = SubTestObject.new;
    subObject.name = @"subObject-Name";
    object.subObject = subObject;
    
    [[MFSCacheManager defaultManager] setObject:object forKey:@"mfsCacheObject"];
    NSLog(@"Object存储前:%@\narray:%@\ndictionary:%@\nnumber:%@\nsubObject:%@\nnul:%@", object.name, object.array, object.dictionary, object.number, object.subObject, object.nul);
    
    MFSTestObject *cache = [[MFSCacheManager defaultManager] objectForKey:@"mfsCacheObject"];
    NSLog(@"Object存储后:%@\narray:%@\ndictionary:%@\nnumber:%@\nsubObject:%@\nnul:%@", cache.name, cache.array, cache.dictionary, cache.number, cache.subObject, object.nul);
}

- (void)testRemove {
    [MFSCacheManager removeObjectsWithCompletionBlock:^(long long folderSize) {
        NSLog(@"清理所有空间数据，总大小：%.3fM", (folderSize/(1024.0*1024.0)));
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
