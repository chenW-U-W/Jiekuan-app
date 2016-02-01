//
//  Product.h
//  Cai
//
//  Created by Cameron Ling on 4/10/15.
//  Copyright (c) 2015 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>
//标的列表
@interface Product : NSObject

@property (nonatomic, assign) int pid;  //标的id
@property (nonatomic,strong) NSString *bname;//标的名称
@property (nonatomic,assign) float interest_rate;//年利率
@property (nonatomic,assign) int ratio;//投标进度
@property (nonatomic,assign) float borrow_money;//借款金额
@property (nonatomic,assign) int borrow_duration;//借款期限
@property (nonatomic,assign) float borrow_min;//起投金额
@property (nonatomic,strong) NSString *borrow_type;//还款方式
@property (nonatomic,strong) NSString *add_datetime;//发布时间
@property (nonatomic,strong) NSString *borrow_status;//标的状态

+ (NSURLSessionDataTask *)getProductsWithBlock:(void (^)(id posts, NSError *error,NSString *listType))block  withPageSize:(NSString *)pageSize  withPageNum:(NSString *)pageNum withSname:(NSString *)portString;






@end
