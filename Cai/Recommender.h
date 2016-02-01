//
//  Recommend.h
//  Cai
//
//  Created by 启竹科技 on 15/4/24.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>
//我的推荐人
@interface Recommender : NSObject
@property (nonatomic,assign) int userId;//id
@property (nonatomic,strong) NSString *real_name;//真实姓名
@property (nonatomic,strong) NSString *mobile;//手机号
//@property (nonatomic,strong) NSDate *reg_date;//注册时间
@property (nonatomic,strong) NSString *reg_date;//注册时间
@property (nonatomic,assign) float bonus;//贡献奖金
+ (NSURLSessionDataTask *)recommenderWithBlock:(void (^)(id response, NSError *error))block;
@end

