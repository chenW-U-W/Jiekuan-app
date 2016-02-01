//
//  BidRecommendedObj.m
//  Cai
//
//  Created by 启竹科技 on 15/5/20.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "BidRecommendedObj.h"
#import "TimeObj.h"
#import "CailaiAPIClient.h"
@implementation BidRecommendedObj

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.invest_channel = [attributes objectForKey:@"invest_channel"];
    self.invest_money = [[attributes objectForKey:@"invest_money"]  floatValue];
    self.invest_name = [attributes objectForKey:@"invest_name"] ;
    
    self.invest_time =[TimeObj dateChangeFromTimeIntervalString:[attributes objectForKey:@"invest_time"] withFormat:@"yyyy-MM-dd hh:mm:ss"];
    self.invest_type = [attributes objectForKey:@"invest_type"];
    return self;
}

+ (NSURLSessionDataTask *)BidRecommendedWithBlock:(void (^)(id response, NSError *error))block withBid:(NSString *)bid
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"borrow.invest",@"sname",bid,@"bid" ,nil];
    
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        
        NSArray *responseArray =  [JSON objectForKey:@"data"];
        for (NSDictionary *responseDic in responseArray) {
            BidRecommendedObj *bidRecommendedObj = [[BidRecommendedObj alloc] initWithAttributes:responseDic];
            [mutableArray addObject:bidRecommendedObj];
        }
        
        
        if (block) {
            block( [NSArray arrayWithArray:(NSArray *)mutableArray] ,nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(@"请求失败", error);
        }
    } method:@"POST"];

    
}
@end
