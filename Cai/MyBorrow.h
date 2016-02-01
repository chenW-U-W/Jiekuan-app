//
//  MyBorrow.h
//  Cai
//
//  Created by 启竹科技 on 15/4/28.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>
//我的借款
@interface MyBorrow : NSObject
@property(nonatomic,assign)int bid;//借款标号
@property(nonatomic,strong)NSString *bname;//标的标题
@property(nonatomic,strong)NSString *repayment_type;//还款方式
@property(nonatomic,assign)float borrow_money;//借款金额
@property(nonatomic,assign)float repayment_money;//已还金额
@property(nonatomic,assign)float borrow_interest_rate;//年利率
@property(nonatomic,assign)int total_periods;//总共期限
@property(nonatomic,assign)int payed_periods;//已经期数
@property(nonatomic,strong)NSString *next_pay_date;//下一期还款时间
@property(nonatomic,strong) NSMutableArray *mutableArray;
+ (NSURLSessionDataTask *)MyBorrowWithBlock:(void (^)(id response, NSError *error))block;

@end
