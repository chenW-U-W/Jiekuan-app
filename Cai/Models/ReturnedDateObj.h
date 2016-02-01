//
//  ReturnedDateObj.h
//  Cai
//
//  Created by csj on 15/8/18.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReturnedDateObj : NSObject
@property(nonatomic,strong) NSMutableArray *totalArray;
@property(nonatomic,strong) NSMutableArray *daeArray;
@property(nonatomic,strong) NSMutableArray *message_interestArray;
@property(nonatomic,strong) NSString *totalCountString;//应回款
@property(nonatomic,strong) NSString *ReturnedCountString;//应回款


+ (void) ReturnedDateObjWithBlock:(void (^)(id response, NSError *error))block withSearchYear:(NSString *)yearString monthString:(NSString *)monthString;
@end
