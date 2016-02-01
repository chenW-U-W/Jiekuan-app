//
//  BindingInvestObj.m
//  Cai
//
//  Created by 启竹科技 on 15/6/3.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "BindingInvestObj.h"
#import "CailaiAPIClient.h"
#import "InvestObj.h"
#import "AllBidObj.h"
@implementation BindingInvestObj
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.bid = [[attributes objectForKey:@"id"] intValue];
    self.real_name= [attributes objectForKey:@"real_name"] ;
    self.borrow_money = [[attributes objectForKey:@"borrow_money"] floatValue];
    self.borrow_interest_rate = [[attributes objectForKey:@"borrow_interest_rate"] floatValue];
    self.borrow_duration = [[attributes objectForKey:@"borrow_duration"] intValue];
    self.investor_capital = [[attributes objectForKey:@"investor_capital"] floatValue];
    self.benxi = [[attributes objectForKey:@"benxi"] floatValue];
    self.add_time = [attributes objectForKey:@"add_time"];
    self.bidName = [attributes objectForKey:@"borrow_name"];
    return self;
}





+ (NSURLSessionDataTask *)bindingInvestWithBlock:(void (^)(id response, NSError *error,NSString *sname))block withSname:(NSString *)snameString
{
    NSMutableArray *BindingInvestMutableArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *InvestMutableArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *AllBidMutableArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *BidBackedMutableArray = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:snameString ,@"sname",nil];
    
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        NSArray *responseArray =  [JSON objectForKey:@"data"];
        if (responseArray.count == 0) {
            DLog(@"我没有投标");
            block(@"没有进行的标",nil,snameString);
        }
        else
        {
            //投标中
            if ([snameString isEqualToString:@"tending.get"]) {
                for(NSDictionary *responseDic in responseArray){
                    BindingInvestObj *investObj = [[BindingInvestObj alloc] initWithAttributes:responseDic];
                    [BindingInvestMutableArray addObject:investObj];
                }
                if (block) {
                    block(BindingInvestMutableArray,nil,snameString);
                }
            }
            //待收
            if ([snameString isEqualToString:@"tendbacking.get"]) {
                for(NSDictionary *responseDic in responseArray){
                    InvestObj *investObj = [[InvestObj alloc] initWithAttributes:responseDic];
                    [InvestMutableArray addObject:investObj];
                }
                if (block) {
                    block(InvestMutableArray,nil,snameString);
                }
            }
            //全部
            if ([snameString isEqualToString:@"tendall.get"]) {
                for(NSDictionary *responseDic in responseArray){
                    AllBidObj *investObj = [[AllBidObj alloc] initWithAttributes:responseDic];
                    [AllBidMutableArray addObject:investObj];
                }
                
                if (block) {
                    block(AllBidMutableArray,nil,snameString);
                }
            }
            //已收
            if ([snameString isEqualToString:@"tendbacked.get"]) {
                for(NSDictionary *responseDic in responseArray){
                    AllBidObj *investObj = [[AllBidObj alloc] initWithAttributes:responseDic];
                    [BidBackedMutableArray addObject:investObj];
                }
                if (block) {
                    block(BidBackedMutableArray,nil,snameString);
                }
            }
            

            
        }
        
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error,nil);
        }
    } method:@"POST"];
    
}


@end
