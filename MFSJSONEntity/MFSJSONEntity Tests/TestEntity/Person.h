//
//  Person.h
//  MFSJSONEntity
//
//  Created by maxfong on 15/8/2.
//  Copyright (c) 2015年 MFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger age;

@property (nonatomic, strong, readonly) NSString *other;    //不会对other赋值

@end
