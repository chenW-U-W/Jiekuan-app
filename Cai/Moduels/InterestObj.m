//
//  InterestObj.m
//  Cai
//
//  Created by 陈思远 on 16/1/26.
//  Copyright © 2016年 财来. All rights reserved.
//

#import "InterestObj.h"
#import "CailaiAPIClient.h"
@implementation InterestObj

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.repaymentInterestMoneySum = [attributes objectForKey:@"repaymentInterestMoneySum"];
    if ([self.repaymentInterestMoneySum isKindOfClass:[NSNull class]]) {
        self.repaymentInterestMoneySum = @"0.00";
    }

    self.repaymentInterestMoneySum = [self.repaymentInterestMoneySum stringByAppendingString:@" 元"];
    self.unrepaymentInterestMoneySum = [attributes objectForKey:@"unrepaymentInterestMoneySum"];
    if ([self.unrepaymentInterestMoneySum isKindOfClass:[NSNull class]]) {
        self.unrepaymentInterestMoneySum = @"0.00";
    }
    self.unrepaymentInterestMoneySum = [self.unrepaymentInterestMoneySum stringByAppendingString:@" 元"];
    
    return self;
}




+ (NSURLSessionDataTask *)getInterestWithBlock:(void (^)(InterestObj* posts, NSError *error))block {
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"user.interest.get", @"sname",
                           nil];
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        if (JSON) {
            NSDictionary *responseDic =  [JSON objectForKey:@"data"];
            if (responseDic.allValues.count==0) {
                DLog(@"--");
            }
            else
            {
               InterestObj *interesObj= [[InterestObj alloc] initWithAttributes:responseDic];
                
                if (block) {
                    block(interesObj,nil);
                }
            }
        }
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];}


@end
