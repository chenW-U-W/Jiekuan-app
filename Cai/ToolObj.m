//
//  ToolObj.m
//  Cai
//
//  Created by 陈思远 on 16/3/30.
//  Copyright © 2016年 财来. All rights reserved.
//

#import "ToolObj.h"

@implementation ToolObj

+ (ToolObj *)sharedTool
{
    static ToolObj *sharedToolInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedToolInstance = [[self alloc] init];
    });
    return sharedToolInstance;
}


- (NSString *)getIOSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

@end
