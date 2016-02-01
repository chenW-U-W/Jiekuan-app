//
//  ReturnedDateObj.m
//  Cai
//
//  Created by csj on 15/8/18.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "ReturnedDateObj.h"
#import "CailaiAPIClient.h"
#import "MyReceiveObj.h"
@implementation ReturnedDateObj
- (instancetype)initWithAttributes:(NSMutableArray *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.totalArray = attributes;
    
    return self;
}


+ (void) ReturnedDateObjWithBlock:(void (^)(id response, NSError *error))block withSearchYear:(NSString *)yearString monthString:(NSString *)monthString
{
    
    NSMutableArray *totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"receive.calendar",@"sname",yearString,@"search_year",monthString,@"search_month",nil];
    
     [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        
        NSArray *responseArray =  [JSON objectForKey:@"data"];
        for (NSDictionary *responseDic in responseArray) {
            MyReceiveObj *myreceiveOBJ = [[MyReceiveObj alloc] initWithAttribut:responseDic];
            [totalArray addObject:myreceiveOBJ];
        }       
        
        if (block) {
            block( totalArray ,nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];
    
    
}


@end
