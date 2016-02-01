//
//  InvestObj.h
//  Cai
//
//  Created by 启竹科技 on 15/4/24.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>
//待收
@interface InvestObj : NSObject
@property(nonatomic,assign)int bid;//借款标号
@property(nonatomic,strong)NSString *bname;//标的标题
@property(nonatomic,strong)NSString *borrow_uname;//借款人姓名
@property(nonatomic,assign)float invest_money;//投资金额
@property(nonatomic,assign)float repayment_money;//已还本息
@property(nonatomic,assign)float borrow_interest_rate;//年利率
@property(nonatomic,assign)int total_periods;//总共期限
@property(nonatomic,assign)int payed_periods;//已经期数
@property(nonatomic,strong)NSDate *next_pay_date;//下一期还款时间
@property(nonatomic,strong)NSString *tender_date;
@property(nonatomic,assign)double  returned_money;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
