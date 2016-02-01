//
//  InvestObj.m
//  Cai
//
//  Created by 启竹科技 on 15/4/24.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "InvestObj.h"
#import "TimeObj.h"
@implementation InvestObj

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.bid = [[attributes objectForKey:@"bid"] intValue];
    self.bname = [attributes objectForKey:@"bname"];
    self.borrow_uname = [attributes objectForKey:@"borrow_uname"] ;
    self.total_periods = [[attributes objectForKey:@"total_periods"] intValue];
     self.payed_periods = [[attributes objectForKey:@"payed_periods"] intValue];
    self.borrow_interest_rate = [[attributes objectForKey:@"borrow_interest_rate"] floatValue];
    self.repayment_money = [[attributes objectForKey:@"repayment_money"] floatValue];
    self.invest_money = [[attributes objectForKey:@"invest_money"] floatValue];
    self.next_pay_date = [TimeObj dateChangeFromString:[attributes objectForKey:@"next_pay_date"] withFormat:@"yyyy-MM-dd"];
    self.tender_date = [attributes objectForKey:@"tender_date"];
    self.returned_money = [[attributes objectForKey:@"returned_money"] doubleValue];
    return self;
}






@end
