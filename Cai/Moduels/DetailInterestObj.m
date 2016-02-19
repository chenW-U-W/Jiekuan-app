//
//  DetailInterestObj.m
//  Cai
//
//  Created by 陈思远 on 16/1/26.
//  Copyright © 2016年 财来. All rights reserved.
//

#import "DetailInterestObj.h"
#import "CailaiAPIClient.h"
@implementation DetailInterestObj
- (instancetype)initWithAttributes:(NSDictionary *)attributes withKeyName:(NSString*)keyName {
    self = [super init];
    if (!self) {
        return nil;
    }
   
    NSDictionary *dic  = [attributes objectForKey:keyName];
    self.capitalMoneySum =  [[dic objectForKey:@"capitalMoneySum"] stringByAppendingString:@" 元"];
    self.repaymentCapitalMoneySum = [[dic objectForKey:@"repaymentCapitalMoneySum"] stringByAppendingString:@" 元"];
    self.repaymentInterestMoneySum = [[dic objectForKey:@"repaymentInterestMoneySum"] stringByAppendingString:@" 元"];
    self.rechargeMoneySum = [[dic objectForKey:@"rechargeMoneySum"] stringByAppendingString:@" 元"];
    self.withdrawMoneySum = [[dic objectForKey:@"withdrawMoneySum"] stringByAppendingString:@" 元"];
    if([keyName isEqualToString:@"totalStatistics"])
    {
    keyName = @"总计";
    }
    self.dateString = keyName;
    self.mutableArray  = [NSMutableArray arrayWithObjects:_dateString,_rechargeMoneySum,_capitalMoneySum,_repaymentInterestMoneySum,_repaymentCapitalMoneySum,_withdrawMoneySum,nil];
    return self;
}

+ (NSURLSessionDataTask *)getDetailInterestWithBlock:(void (^)(id posts,id keyArray ,NSString*  tag, NSError *error))block  withType:(NSString *)type withBtnTag:(NSString *)btnTag {
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:                           @"user.tender.statistics.get",@"sname",type,@"type",nil];
                        
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSMutableArray *keynameArray  = [[NSMutableArray alloc] init];
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        if (JSON) {
            NSDictionary *responseDic =  [JSON objectForKey:@"data"];
            NSArray *keyarray = responseDic.allKeys;
            NSArray *resultArray = [keyarray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                    {
                                        NSString *number1 =obj1;
                                        NSString *number2 = obj2;
                NSComparisonResult result = [number2 compare:number1];
                return result == NSOrderedDescending; // 降序
                                    }];
            
            
            DLog(@"%@",resultArray);
            
            for (int i=1;i<resultArray.count-1;i++) {
                
                DetailInterestObj *detailInterestObj= [[DetailInterestObj alloc] initWithAttributes:responseDic withKeyName:[resultArray objectAtIndex:i]];
                [mutableArray addObject:detailInterestObj];
                
                
            }
            //将总计移到下面
            DetailInterestObj *detailInterestObj= [[DetailInterestObj alloc] initWithAttributes:responseDic withKeyName:[resultArray objectAtIndex:0]];
            [mutableArray addObject:detailInterestObj];

            }
        
        if (block) {
                block(mutableArray,keynameArray,btnTag,nil);
            }
            
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil,nil,nil, error);
        }
    } method:@"POST"];}
@end
