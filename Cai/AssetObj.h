//
//  AssetObj.h
//  Cai
//
//  Created by 启竹科技 on 15/4/24.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>
//我的资产  购买
@interface AssetObj : NSObject

@property (nonatomic,assign) double account_money;//账户余额
//@property (nonatomic,assign) float wait_interest;//待收利息
@property (nonatomic,assign) double wait_capital;//待收本金
@property (nonatomic,assign) double money_collect;//待收总额
@property (nonatomic,assign) double money_freeze;//冻结金额
@property (nonatomic,assign) double all_money;//总金额

//这个是标的属性   但是由于疏漏  用的是用户的对象 所以就将就用了（应该单独写个新的对象）
@property (nonatomic,assign) double canUsedMoney;//可投金额（标的）




+ (NSURLSessionDataTask *)getAssetWithBlock:(void (^)(id posts, NSError *error))block ;
@end
