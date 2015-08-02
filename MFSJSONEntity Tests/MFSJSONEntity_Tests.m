//
//  MFSJSONEntity_Tests.m
//  MFSJSONEntity Tests
//
//  Created by maxfong on 15/8/2.
//  Copyright (c) 2015年 MFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Person.h"
#import "MFSJSONEntity.h"

@interface MFSJSONEntity_Tests : XCTestCase

@end

@implementation MFSJSONEntity_Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    NSLog(@"Hello, MFS JSONEntity! ");
    
    //Object转Dictionary
    Person *person = Person.new;
    person.name = @"max";
    person.age = 99;
    NSDictionary *personDict = [person propertyDictionary];
    NSLog(@"Person:%@", personDict);
    
    //Dictionary转Object
    NSString *JSONString = @"{\"name\":\"max\",\"age\":98}";
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    Person *obj = [Person objectWithDictionary:dictionary];
    NSLog(@"person:%@, name:%@, age:%ld", obj, obj.name, obj.age);
    
    //属性列表
    NSArray *propertys = [Person propertyNames];
    NSLog(@"Person propertys:%@", propertys);
}

@end
