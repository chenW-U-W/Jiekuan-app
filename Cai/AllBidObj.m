//
//  AllBidObj.m
//  Cai
//
//  Created by csj on 15/8/26.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "AllBidObj.h"
#import "TimeObj.h"
@implementation AllBidObj
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.borrow_name = [attributes objectForKey:@"borrow_name"];
    self.investor_capital = [attributes objectForKey:@"investor_capital"];
    self.borrow_duration = [attributes objectForKey:@"borrow_duration"] ;
    self.borrow_interest_rate = [attributes objectForKey:@"borrow_interest_rate"];
    self.overdue = [attributes objectForKey:@"overdue"];
    self.add_time = [attributes objectForKey:@"add_time"];
    self.deadline = [attributes objectForKey:@"deadline"];
    self.status = [attributes objectForKey:@"status"];
    self.statusString = _status;
//    //回款状态
//    if (self.status < 5) {
//        self.statusString = @"未偿还";
//    }
//    else
//    {    
//    self.statusString = @"已偿还";
//    }
    
    
   NSDate *date1 = [TimeObj dateChangeFromTimeIntervalString:self.add_time withFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.add_time_formator = [TimeObj stringFromReceivedDate:date1 withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if ([self.deadline integerValue] == 0) {
        self.deadline_formator = @"-";
    }
    else
    {
    NSDate *date2 = [TimeObj dateChangeFromTimeIntervalString:self.deadline withFormat:@"yyyy-MM-dd"];
    self.deadline_formator = [TimeObj stringFromReceivedDate:date2 withDateFormat:@"yyyy-MM-dd"];
    }
    return self;
}

@end
