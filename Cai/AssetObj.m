//
//  AssetObj.m
//  Cai
//
//  Created by 启竹科技 on 15/4/24.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "AssetObj.h"
#import "CailaiAPIClient.h"
#import "AssetObj.h"
@implementation AssetObj
//我的资产
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
      self = [super init];
      if (!self) {
            return nil;
      }
    //NSString *account_moneyString = [attributes objectForKey:@"account_money"];
      self.account_money = [[attributes objectForKey:@"account_money"] doubleValue];
      self.wait_capital =  [[attributes objectForKey:@"wait_capital"] doubleValue];
      self.money_collect = [[attributes objectForKey:@"money_collect"] doubleValue];
      self.money_freeze  = [[attributes objectForKey:@"money_freeze"] doubleValue];
      self.all_money  = [[attributes objectForKey:@"all_money"] doubleValue];      
    

    self.canUsedMoney = [[attributes objectForKey:@"can_invest_money"] doubleValue];
      
      return self;
}




+ (NSURLSessionDataTask *)getAssetWithBlock:(void (^)(id posts, NSError *error))block {
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"member.capital", @"sname",
                           nil];
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        if (JSON) {
        NSDictionary *responseDic =  [JSON objectForKey:@"data"];
            if (responseDic.allValues.count==0) {
                DLog(@"我没有资产");
            }
            else
            {
        AssetObj *assetObj = [[AssetObj alloc] initWithAttributes:responseDic];
        
        if (block) {
            block(assetObj,nil);
        }
            }
        }
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];}


@end
