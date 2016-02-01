//
//  MyReceiveObj.h
//  Cai
//
//  Created by 启竹科技 on 15/7/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, StatusString) {
    chushengdaishenghe,
    chushengweitongguo,
    liubiao,
    biaomanfushenzhong,
    fushenweitongguo,
    fushentonggguo,
    yiwancheng,
    yiyuqi,
    wangzhandaihuan,
    yuqihuankuan
    
};

@interface MyReceiveObj : NSObject
@property(nonatomic,assign) NSInteger borrow_id;
@property(nonatomic,assign) NSInteger borrow_uid;
@property(nonatomic,assign) float interest;
@property(nonatomic,assign) float capital;
@property(nonatomic,assign) float Interest_fee;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy)   NSString *statusString;
@property(nonatomic,strong) NSDate * deadline;
@property(nonatomic,assign) float Expired_money;
@property(nonatomic,assign) StatusString statusSTR;//标的状态
@property(nonatomic,copy)   NSString *projiectName;//项目名称
@property(nonatomic,copy)   NSString *borrowerName;//借款人姓名
@property(nonatomic,copy)   NSString *app_status;//还款状态
@property(nonatomic,strong) NSDate *repayment_time;//提前还款日期
@property(nonatomic,assign) NSInteger repayment_timeInt;
@property(nonatomic,strong) NSString *describeString;
@property(nonatomic,assign) int deadlineTime;
+ (void)myReceiveWithBlcok:(void (^)(NSMutableArray *mutableArray,NSError *error))block;

- (id)initWithAttribut:(NSDictionary *)attribute;
@end
