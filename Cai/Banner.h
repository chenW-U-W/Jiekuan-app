//
//  Banner.h
//  Cai
//
//  Created by 启竹科技 on 15/4/28.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Banner : NSObject
@property (nonatomic,assign)int need_update;//是否需要更新
@property (nonatomic,strong)NSString *pic_url;//Banner地址的url
@property (nonatomic,strong)NSString *desc;//Banner的描述
@property (nonatomic,strong)NSString *link;//Banner连接的ur

+ (NSURLSessionDataTask *)bannerViewWithBlock:(void (^)(id response, NSError *error))block;
@end
