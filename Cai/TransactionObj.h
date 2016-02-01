//
//  TransactionObj.h
//  Cai
//
//  Created by 启竹科技 on 15/4/24.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>
//交易记录
@interface TransactionObj : NSObject
@property (nonatomic,strong) NSDate *date;//发生时间
@property (nonatomic,strong) NSString *dateString;
@property (nonatomic,strong) NSString *type;//类型
@property (nonatomic,assign) double affect_money;//影响金额
@property (nonatomic,assign) double collect_money;//待收金额
@property (nonatomic,strong) NSString *desc;//说明
+ (NSURLSessionDataTask *)transactionWithBlock:(void (^)(id response,NSArray *array, NSError *error))block withPageSize:(NSString*)pageSize  withPageNum:(NSString *)pageNum;
@end
