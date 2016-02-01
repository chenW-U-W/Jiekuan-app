//
//  MyBorrow.m
//  Cai
//
//  Created by 启竹科技 on 15/4/28.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "MyBorrow.h"
#import "CailaiAPIClient.h"
@implementation MyBorrow
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
      self = [super init];
      if (!self) {
            return nil;
      }
      self.bid = [[attributes objectForKey:@"bid"] intValue];
      self.bname  = [attributes objectForKey:@"bname"];
      self.repayment_type = [attributes objectForKey:@"repayment_type"];
      self.next_pay_date =[attributes objectForKey:@"next_pay_date"];
      
      self.borrow_money = [[attributes objectForKey:@"borrow_money"] floatValue];
      self.repayment_money = [[attributes objectForKey:@"repayment_money"] floatValue];
      self.borrow_interest_rate = [[attributes objectForKey:@"borrow_interest_rate"] floatValue];
      self.total_periods = [[attributes objectForKey:@"total_periods"] intValue];
       self.payed_periods = [[attributes objectForKey:@"payed_periods"] floatValue];
      
      return self;
}

- (NSDate *)dateChangeFromString:(NSString *)str
{
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"yyyy-MM-DD hh:mm:ss"];
      [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
      NSDate *date = [dateFormatter dateFromString:str];
      return date;
}

+ (NSURLSessionDataTask *)MyBorrowWithBlock:(void (^)(id response, NSError *error))block{
    
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"borrowpaying.get",@"sname",nil];
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        
        NSArray *responseArray =  [JSON objectForKey:@"data"];
        for (NSDictionary *dic in responseArray) {
            MyBorrow *myBorrowObj = [[MyBorrow alloc] initWithAttributes:dic];
            [mutableArray addObject:myBorrowObj];
        }       
        
        if (block) {
            block(mutableArray,nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            DLog(@"请求失败");
            block(@"请求失败", error);
        }
    } method:@"POST"];
    
}


@end
