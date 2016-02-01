//
//  BidRecommendedObj.h
//  Cai
//
//  Created by 启竹科技 on 15/5/20.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BidRecommendedObj : NSObject
@property(nonatomic,strong) NSString *invest_name;
@property(nonatomic,strong) NSString *invest_type;
@property(nonatomic,strong) NSDate *invest_time;
@property(nonatomic,strong) NSString *invest_channel;
@property(nonatomic,assign) float invest_money;
+ (NSURLSessionDataTask *)BidRecommendedWithBlock:(void (^)(id response, NSError *error))block withBid:(NSString *)bid;
@end
