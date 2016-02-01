//
//  Banner.m
//  Cai
//
//  Created by 启竹科技 on 15/4/28.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "Banner.h"
#import "CailaiAPIClient.h"

@implementation Banner
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.need_update = [[attributes objectForKey:@"need_update"] intValue];
    self.pic_url = [attributes objectForKey:@"pic_url"] ;
    self.desc = [attributes objectForKey:@"desc"] ;
    self.link = [attributes objectForKey:@"link"];
    return self;
}


+ (NSURLSessionDataTask *)bannerViewWithBlock:(void (^)(id response, NSError *error))block
{

    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"banner.get",@"sname",nil];
    
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        
        NSArray *responseArray =  [JSON objectForKey:@"data"];
        for (NSDictionary *responseDic in responseArray) {
             Banner *bannerObj = [[Banner alloc] initWithAttributes:responseDic];
            [mutableArray addObject:bannerObj];
        }
       
        
        if (block) {
            block( [NSArray arrayWithArray:(NSArray *)mutableArray] ,nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(@"请求失败", error);
        }
    } method:@"POST"];

    
}
@end
