//
//  DetailInterestObj.h
//  Cai
//
//  Created by 陈思远 on 16/1/26.
//  Copyright © 2016年 财来. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailInterestObj : NSObject
@property(nonatomic,strong) NSString *capitalMoneySum;//投资总额
@property(nonatomic,strong) NSString *repaymentCapitalMoneySum;
@property(nonatomic,strong) NSString *repaymentInterestMoneySum;
@property(nonatomic,strong) NSString *rechargeMoneySum;
@property(nonatomic,strong) NSString *withdrawMoneySum;
@property(nonatomic,strong) NSString *dateString;
@property(nonatomic,strong) NSMutableArray *mutableArray;
+ (NSURLSessionDataTask *)getDetailInterestWithBlock:(void (^)(id posts,id keyArray,NSString*  tag, NSError *error))block  withType:(NSString *)type withBtnTag:(NSString *)btnTag;
@end
