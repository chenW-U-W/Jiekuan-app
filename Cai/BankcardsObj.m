//
//  BankcardsObj.m
//  Cai
//
//  Created by 启竹科技 on 15/4/24.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "BankcardsObj.h"
#import "CailaiAPIClient.h"
@implementation BankcardsObj
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
      self = [super init];
      if (!self) {
            return nil;
      }
      self.is_quick = [[attributes objectForKey:@"is_quick"] boolValue];//是否快捷卡
      self.bank_number = [attributes objectForKey:@"bank_number"];//卡号
      self.bank_name = [attributes objectForKey:@"bank_name"];//名称
    self.bank_icon = [attributes objectForKey:@"bank_icon"];//图标
      return self;
}

+ (NSURLSessionDataTask *)bankCardWithBlock:(void (^)(id response, NSError *error))block{
    
    
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"user.bank",@"sname", nil];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        NSDictionary *responseDic = [JSON objectForKey:@"data"];
        if (responseDic.allKeys.count == 0) {
            DLog(@"无银行卡");
            block(@"无银行卡",nil);
        }
        else{
        BankcardsObj *bankcardObj = [[BankcardsObj alloc] initWithAttributes:responseDic];
            [mutableArray addObject:bankcardObj];
        if (block) {
            block(mutableArray,nil);
        }
        }
    } failure:^(NSError *error) {
        if (block) {
            block(@"请求失败", error);
        }
    } method:@"POST"];
    
}

@end
