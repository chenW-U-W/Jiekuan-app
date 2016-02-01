//
//  RedPocketObj.m
//  Cai
//
//  Created by csj on 15/9/11.
//  Copyright (c) 2015年 财来. All rights reserved.
//

#import "RedPocketObj.h"
#import "CailaiAPIClient.h"

@implementation RedPocketObj
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.packetID = [[attributes objectForKey:@"id"] intValue];
    self.facevalue =  [[attributes objectForKey:@"facevalue"] intValue];
    self.overtime = [[attributes objectForKey:@"overtime"] floatValue];
    self.transmat  = [attributes objectForKey:@"transmat"] ;
    self.is_used = [[attributes objectForKey:@"is_used"] intValue];
    self.is_success = [[attributes objectForKey:@"is_success"] intValue];
    return self;
}




+ (NSURLSessionDataTask *)getRedPocketWithBlock:(void (^)(id posts, NSError *error))block {
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"redpacket", @"sname",
                           nil];
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        if (JSON) {
            NSArray *responseArray = [JSON objectForKey:@"data"];
            
            for (NSDictionary *responseDic in responseArray) {
                RedPocketObj *redPocketObj = [[RedPocketObj alloc] initWithAttributes:responseDic];
                [mutableArray addObject:redPocketObj];
            }
            if (block) {
                block(mutableArray,nil);
            }

            
        }
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];}


@end
