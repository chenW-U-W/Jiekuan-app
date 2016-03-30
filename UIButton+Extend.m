//
//  UIButton+Extend.m
//  Cai
//
//  Created by 陈思远 on 16/3/14.
//  Copyright © 2016年 财来. All rights reserved.
//

#import "UIButton+Extend.h"
#import "objc/runtime.h"

static char *markedAddress = '\0';
@implementation UIButton (Extend)
- (BOOL)isFirstClick
{
    return [objc_getAssociatedObject(self, &markedAddress) boolValue];
}

- (void)setIsFirstClick:(BOOL)isFirstClick
{
    objc_setAssociatedObject(self, &markedAddress, @(isFirstClick), OBJC_ASSOCIATION_ASSIGN);
}

@end
