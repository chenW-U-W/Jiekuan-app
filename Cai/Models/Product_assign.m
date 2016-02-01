//
//  Product_assign.m
//  Cai
//
//  Created by csj on 15/8/25.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "Product_assign.h"

@implementation Product_assign
- (instancetype)initWithAnotherAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _assign_status = [attributes valueForKey:@"status"];
    _assign_money = [attributes valueForKey:@"money"];
    _assign_total_period = [attributes valueForKey:@"total_period"];
    _assign_transfer_price = [attributes valueForKey:@"transfer_price"];
    _assign_period = [attributes valueForKey:@"period"];
    _assign_valid = [attributes valueForKey:@"valid"];
    _assign_debt_id = [attributes valueForKey:@"debt_id"];
    _assign_invest_id = [attributes valueForKey:@"invest_id"];
    _assign_investor_uid = [attributes valueForKey:@"investor_uid"];
    _assign_deadline = [attributes valueForKey:@"deadline"];
    _assign_id = [attributes valueForKey:@"id"];
    _assign_interest_rate = [attributes valueForKey:@"borrow_interest_rate"];
    _assign_borrow_status = [attributes valueForKey:@"borrow_status"];
    _assign_borrow_duration = [attributes valueForKey:@"borrow_duration"];
    _assign_user_name = [attributes valueForKey:@"user_name"];
    _assign_borrow_name = [attributes valueForKey:@"borrow_name"];
    _assign_repayment_type = [attributes valueForKey:@"repayment_type"];
    return self;
}

+ (NSURLSessionDataTask *)getProduct_assignWithBlock:(void (^)(id posts, NSError *error))block  withPageSize:(NSString *)pageSize  withPageNum:(NSString *)pageNum {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"borrow.debt.list", @"sname",
                           pageSize, @"page_size",
                           pageNum, @"page_num",
                           nil];
    
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        NSArray *responseArray = [JSON objectForKey:@"data"];
        
            for (NSDictionary *responseDic in responseArray) {
                Product_assign *product_assignObj = [[Product_assign alloc] initWithAnotherAttributes:responseDic];
                [mutableArray addObject:product_assignObj];
                
            }
       
        if (block) {
            
            block( [NSArray arrayWithArray:(NSArray *)mutableArray],nil);
            
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];
}


@end
