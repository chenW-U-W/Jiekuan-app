//
//  Recommend.m
//  Cai
//
//  Created by 启竹科技 on 15/4/24.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "Recommender.h"
#import "CailaiAPIClient.h"
#import "TimeObj.h"
@implementation Recommender
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
      self = [super init];
      if (!self) {
            return nil;
      }
      self.userId = [[attributes objectForKey:@"id"] intValue];
      self.real_name = [attributes objectForKey:@"real_name"];
      self.mobile = [attributes objectForKey:@"mobile"];
      //self.reg_date = [TimeObj dateChangeFromString:[attributes objectForKey:@"reg_date"] withFormat:@"yyyy-MM-dd hh:mm:ss"];
    self.reg_date = [attributes objectForKey:@"reg_date"];
      self.bonus = [[attributes objectForKey:@"bonus"] floatValue];
      return self;
}

+ (NSURLSessionDataTask *)recommenderWithBlock:(void (^)(id response, NSError *error))block{
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"user.recommend",@"sname",nil];
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        NSArray *responseArray =  [JSON objectForKey:@"data"];
        for(NSDictionary *responseDic in responseArray){
        Recommender *recomenderObj = [[Recommender alloc] initWithAttributes:responseDic];
            [mutableArray addObject:recomenderObj];
        }
        if (block) {
            block(mutableArray,nil);
        }
//        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(@"请求失败", error);
        }
    } method:@"POST"];
    
}

@end
