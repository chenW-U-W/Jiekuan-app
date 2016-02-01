//
//  ProductDetail.h
//  Cai
//
//  Created by 启竹科技 on 15/5/5.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>
//标的详情
@interface ProductDetail : NSObject
@property (nonatomic,strong) NSString *bname;//标的名称
@property (nonatomic,assign) float interest_rate;//年利率
@property (nonatomic,assign) int ratio;//投标进度
@property (nonatomic,assign) float borrow_money;//借款金额
@property (nonatomic,assign) int borrow_duration;//借款期限
@property (nonatomic,assign) int borrow_min;//起投金额
@property (nonatomic,assign) NSInteger borrow_max;
@property (nonatomic,strong) NSString *repayment_type;//还款方式
@property (nonatomic,strong) NSString *add_datetime;//发布时间
@property (nonatomic,assign) NSInteger remained_time;//剩余时间
@property (nonatomic,assign) float can_invest_money;//可投金额
@property (nonatomic,assign) float MortgageRates;//抵押率
@property (nonatomic,strong) NSString *borrow_status;// 还款状态
+ (NSURLSessionDataTask *)getProductDetailWithBlock:(void (^)(id posts, NSError *error))block withBidId:(NSString *)bidId;

@end
