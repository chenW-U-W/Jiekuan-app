//
//  Product_assign.h
//  Cai
//
//  Created by csj on 15/8/25.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CailaiAPIClient.h"
@interface Product_assign : NSObject
//标的转让列表 (服务器返回的参数 和 key值都发生了变化)
@property (nonatomic,strong) NSString *assign_status;//转让状态
@property (nonatomic,strong) NSString *assign_money;//转让之前的价格，实际价格
@property (nonatomic,strong) NSString *assign_transfer_price;//转让价格
@property (nonatomic,strong) NSString *assign_total_period;//总共的期限
@property (nonatomic,strong) NSString *assign_period;//目前是第几期
@property (nonatomic,strong) NSString *assign_valid;//有效期
@property (nonatomic,strong) NSString *assign_debt_id;//转让标ID
@property (nonatomic,strong) NSString *assign_invest_id;//投资标id
@property (nonatomic,strong) NSString *assign_investor_uid;//投资人用户id
@property (nonatomic,strong) NSString *assign_deadline;//还款时间
@property (nonatomic,strong) NSString *assign_id;//标的信息表ID
@property (nonatomic,strong) NSString *assign_borrow_name;//项目名称
@property (nonatomic,strong) NSString *assign_interest_rate;//年收益率
@property (nonatomic,strong) NSString *assign_borrow_status;//标的状态
@property (nonatomic,strong) NSString *assign_borrow_type;//标的类型
@property (nonatomic,strong) NSString *assign_borrow_duration;//标的期限
@property (nonatomic,strong) NSString *assign_user_name;//转让者用户名
@property (nonatomic,strong) NSString *assign_repayment_type;//还款方式

+ (NSURLSessionDataTask *)getProduct_assignWithBlock:(void (^)(id posts, NSError *error))block  withPageSize:(NSString *)pageSize  withPageNum:(NSString *)pageNum;
@end
