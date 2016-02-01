//
//  AllBidObj.h
//  Cai
//
//  Created by csj on 15/8/26.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>
//全部的标
@interface AllBidObj : NSObject
@property(nonatomic,strong)NSString *borrow_name;
@property(nonatomic,strong)NSString *investor_capital;//投资金额
@property(nonatomic,strong)NSString *borrow_duration;//投资期限
@property(nonatomic,strong)NSString *borrow_interest_rate;//年华收益率
@property(nonatomic,strong)NSString *overdue;//预期回款
@property(nonatomic,strong)NSString *add_time;//投资时间
@property(nonatomic,strong)NSString *deadline;//回款时间
@property(nonatomic,strong)NSString *status;//回款状态
@property(nonatomic,strong)NSString *statusString;//回款状态;

@property(nonatomic,strong)NSString *add_time_formator;
@property(nonatomic,strong)NSString *deadline_formator;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end

