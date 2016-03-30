//
//  MessageObj.m
//  Cai
//
//  Created by csj on 15/9/9.
//  Copyright (c) 2015年 财来. All rights reserved.
//

#import "MessageObj.h"
#import "CailaiAPIClient.h"
#import "TimeObj.h"
@implementation MessageObj

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;        
            }
    self.title = [attributes valueForKey:@"title"];
    self.content = [attributes objectForKey:@"content"];
    NSString *send_time = [attributes objectForKey:@"send_time"];
    if([send_time isKindOfClass:[NSNull class]])
    {
    self.send_time = @"";
    }
    else
    {
    self.send_time = [TimeObj stringFromReceivedDate:[TimeObj dateChangeFromTimeIntervalString:send_time withFormat:@"yyyy-MM-dd HH:mm:ss"] withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    self.MessageId = [attributes objectForKey:@"id"];

    return self;
}


+ (void) getMessageObjWithBlock:(void (^)(id response,NSString *listType, NSError *error))block withPageSize:(NSString *)pageSize withPageNum:(NSString*)pageNum withSname:(NSString *)sname withIsRead:(NSString *)isRead

{
    
    NSMutableArray *totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"user.messageslist.get",@"sname",isRead,@"isRead",nil];
    
    [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        
        NSArray *responseArray =  [JSON objectForKey:@"data"];
        for (NSDictionary *responseDic in responseArray) {
            MessageObj *myMessageOBJ = [[MessageObj alloc] initWithAttributes:responseDic];
            [totalArray addObject:myMessageOBJ];
        }
        
        if (block) {
            block( totalArray ,isRead,nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil,isRead, error);
        }
    } method:@"POST"];
    
    
}



@end
