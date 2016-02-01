//
//  BankcardsObj.h
//  Cai
//
//  Created by 启竹科技 on 15/4/24.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankcardsObj : NSObject
@property(nonatomic,assign) BOOL is_quick;//是否快捷卡
@property(nonatomic,strong) NSString *bank_number;//银行卡号
@property (nonatomic,strong)NSString *bank_name;//银行名称
@property (nonatomic,strong) NSString *bank_icon;//银行图标地址
+ (NSURLSessionDataTask *)bankCardWithBlock:(void (^)(id response, NSError *error))block;
@end
