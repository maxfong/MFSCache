//
//  MFSTestObject.h
//  MFSCache
//
//  Created by maxfong on 15/8/14.
//  Copyright (c) 2015年 MFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubTestObject : NSObject

@property (nonatomic, strong) NSString *name;

@end

@interface MFSTestObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSNull *nul;
@property (nonatomic, strong) SubTestObject *subObject;

@end
