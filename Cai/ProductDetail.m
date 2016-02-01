//
//  ProductDetail.m
//  Cai
//
//  Created by 启竹科技 on 15/5/5.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "ProductDetail.h"
#import "CailaiAPIClient.h"
@implementation ProductDetail
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    
    _bname = [attributes valueForKey:@"bname"];
    _interest_rate = [[attributes valueForKey:@"interest_rate"] floatValue];
    _ratio = [[attributes valueForKey:@"ratio"] intValue];
    _borrow_money = [[attributes valueForKey:@"borrow_money"] floatValue];
    _borrow_duration = [[attributes valueForKey:@"borrow_duration"] intValue];
    _borrow_min = [[attributes valueForKey:@"borrow_min"] intValue];
    _borrow_max = [[attributes valueForKey:@"borrow_max"] integerValue];
    _repayment_type = [attributes valueForKey:@"repayment_type"];
    _add_datetime = [attributes valueForKey:@"add_datetime"];
    _remained_time = [[attributes valueForKey:@"remained_time"] integerValue];
    _can_invest_money = [[attributes valueForKey:@"can_invest_money"] floatValue];
    _MortgageRates = [[attributes valueForKey:@"diyalv"] floatValue];
    _borrow_status = [attributes valueForKey:@"borrow_status"];
    return self;
}

#pragma mark -
+ (NSURLSessionDataTask *)getProductDetailWithBlock:(void (^)(id posts, NSError *error))block  withBidId:(NSString *)bidId{
    if ([bidId intValue] == 0) {
        return nil;
    }
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"borrow.summary", @"sname",
                        bidId, @"bid",
                           nil];
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        
        NSDictionary *responseDic =  [JSON objectForKey:@"data"];
        ProductDetail *productDetail = [[ProductDetail alloc] initWithAttributes:responseDic];
        
        if (block) {
            block(productDetail,nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(@"请求失败", error);
        }
    } method:@"POST"];

}

@end
