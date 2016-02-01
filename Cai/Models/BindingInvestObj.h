//
//  BindingInvestObj.h
//  Cai
//
//  Created by 启竹科技 on 15/6/3.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>

//投资中的
@interface BindingInvestObj : NSObject
@property(nonatomic,assign)int bid;//借款标号
@property(nonatomic,strong)NSString *real_name;//借款人姓名
@property(nonatomic,assign)float borrow_money;//借款金额
@property(nonatomic,assign)float borrow_interest_rate;//年利率
@property(nonatomic,assign)int borrow_duration;//借款期限
@property(nonatomic,assign)float investor_capital;//我的投资金额
@property(nonatomic,strong)NSString *add_time;//投标日期
@property(nonatomic,assign)float benxi;//预期本息
@property(nonatomic,copy)  NSString *bidName;

+ (NSURLSessionDataTask *)bindingInvestWithBlock:(void (^)(id response, NSError *error,NSString *sname))block withSname:(NSString *)snameString;

@end
