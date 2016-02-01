//
//  InterestObj.h
//  Cai
//
//  Created by 陈思远 on 16/1/26.
//  Copyright © 2016年 财来. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterestObj : NSObject
@property (nonatomic,strong)NSString *repaymentInterestMoneySum;
@property (nonatomic,strong)NSString *unrepaymentInterestMoneySum;
+ (NSURLSessionDataTask *)getInterestWithBlock:(void (^)(InterestObj* posts, NSError *error))block;
@end
