//
//  TransactionObj.m
//  Cai
//
//  Created by 启竹科技 on 15/4/24.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "TransactionObj.h"
#import "CailaiAPIClient.h"
#import "TimeObj.h"
@implementation TransactionObj
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
      self = [super init];
      if (!self) {
            return nil;
      }
      self.affect_money = [[attributes objectForKey:@"affect_money"] doubleValue];
      self.type = [attributes objectForKey:@"type"];
      //NSString *str = @"2015-02-06 12:00:30";
      NSString *str =  [attributes valueForKey:@"date"];
      self.date = [TimeObj dateChangeFromTimeIntervalString:str withFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.dateString = str;
      self.collect_money = [[attributes objectForKey:@"collect_money"] doubleValue];
      self.desc = [attributes  objectForKey:@"desc"];
      return self;
}




+ (NSURLSessionDataTask *)transactionWithBlock:(void (^)(id response,NSArray *array, NSError *error))block withPageSize:(NSString *)pageSize  withPageNum:(NSString *)pageNum {
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"deal.record",@"sname",pageSize,@"page_size",pageNum,@"page_num", nil];
    //NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"deal.record",@"sname", nil];

    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        NSArray *responseArray = [JSON objectForKey:@"data"];
        
        for (NSDictionary *responseDic in responseArray) {
            TransactionObj *transaction = [[TransactionObj alloc] initWithAttributes:responseDic];
            [mutableArray addObject:transaction];
        }
        if (block) {
            block(mutableArray,responseArray,nil);
        }
            } failure:^(NSError *error) {
        if (block) {
            block(nil,nil, error);
        }
    } method:@"POST"];
    
}


@end
