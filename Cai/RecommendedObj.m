//
//  RecommendObj.m
//  Cai
//
//  Created by 启竹科技 on 15/4/24.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "RecommendedObj.h"
#import "CailaiAPIClient.h"

@implementation RecommendedObj

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.bname = [attributes objectForKey:@"bname"];
    self.interest_rate = [[attributes objectForKey:@"interest_rate"] floatValue];
    self.ratio = [[attributes objectForKey:@"ratio"] intValue];
    self.borrow_duration = [[attributes objectForKey:@"borrow_duration"] floatValue];
    self.borrow_min = [[attributes objectForKey:@"borrow_min"] floatValue];
    self.borrow_money = [[attributes objectForKey:@"borrow_money"] floatValue];
    self.bid = [[attributes objectForKey:@"id"] intValue];
    return self;
}

+ (NSURLSessionDataTask *)recommendedWithBlock:(void (^)(id response, NSError *error))block{
    
        NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"topborrow.get",@"sname",nil];
    
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        
       NSDictionary *responseDic =  [JSON objectForKey:@"data"];
        RecommendedObj *recomendedObj = [[RecommendedObj alloc] initWithAttributes:responseDic];
                if (block) {
            block(recomendedObj,nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];
    
}

#pragma mark -

@end
