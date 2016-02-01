//
//  MessageObj.h
//  Cai
//
//  Created by csj on 15/9/9.
//  Copyright (c) 2015年 财来. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageObj : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *send_time;
@property(nonatomic,strong)NSString *MessageId;

+ (void) getMessageObjWithBlock:(void (^)(id response,NSString *listType, NSError *error))block withPageSize:(NSString *)pageSize withPageNum:(NSString*)pageNum withSname:(NSString *)sname withIsRead:(NSString *)isRead;



@end
