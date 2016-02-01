//
//  RecommendObj.h
//  Cai
//
//  Created by 启竹科技 on 15/4/24.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>
//精选标
@interface RecommendedObj : NSObject
@property (nonatomic,assign) int bid;
@property (nonatomic,strong) NSString *bname;//标的名称
@property (nonatomic,assign) float interest_rate;//年利率
@property (nonatomic,assign) int ratio;//投标进度
@property (nonatomic,assign) float borrow_money;//借款金额
@property (nonatomic,assign) float borrow_duration;//借款期限
@property (nonatomic,assign) float borrow_min;//起投金额
@property (nonatomic,strong) NSString *borrow_status;//标的状态
//@property (nonatomic,strong) NSMutableArray *mutableArray;
+ (NSURLSessionDataTask *)recommendedWithBlock:(void (^)(id response, NSError *error))block;

@end
