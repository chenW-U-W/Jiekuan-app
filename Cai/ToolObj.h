//
//  ToolObj.h
//  Cai
//
//  Created by 陈思远 on 16/3/30.
//  Copyright © 2016年 财来. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolObj : NSObject
+ (ToolObj *)sharedTool;

- (NSString *)getIOSVersion;
@end
