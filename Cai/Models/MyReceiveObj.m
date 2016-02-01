//
//  MyReceiveObj.m
//  Cai
//
//  Created by 启竹科技 on 15/7/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "MyReceiveObj.h"
#import "CailaiAPIClient.h"


@implementation MyReceiveObj


- (id)initWithAttribut:(NSDictionary *)attribute
{
    self = [super init];
    if (self) {
        self.borrow_id =  [[attribute objectForKey:@"borrow_id"] integerValue];
        self.borrow_uid = [[attribute objectForKey:@"borrow_id"] integerValue];
        self.interest = [[attribute objectForKey:@"interest"] floatValue];
        self.capital = [[attribute objectForKey:@"capital"] floatValue];
        self.Interest_fee = [[attribute objectForKey:@"Interest_fee"] floatValue];
        self.status = [attribute objectForKey:@"status"];
        _deadlineTime = [[attribute objectForKey:@"deadline"] intValue];
        self.repayment_timeInt = [[attribute objectForKey:@"repayment_time"] integerValue];
        self.projiectName = [attribute objectForKey:@"borrow_name"];
        self.borrowerName = [attribute objectForKey:@"real_name"];
        self.describeString = [attribute objectForKey:@"describeString"];//描述
        self.deadline = [NSDate dateWithTimeIntervalSince1970:_deadlineTime];
        if (_repayment_timeInt == 0) {
            self.repayment_time = [NSDate dateWithTimeInterval:1000 sinceDate:[NSDate date]];
        }
        else
        {
            self.repayment_time =[NSDate dateWithTimeIntervalSince1970:_deadlineTime];
        }
        
        self.Expired_money = [[attribute objectForKey:@"Expired_money"] floatValue];
        
        self.app_status = [attribute objectForKey:@"status"];
        self.statusString = [attribute objectForKey:@"status"];
//        switch (_statusSTR) {
//            case chushengdaishenghe:
//                self.statusString = @"初审待审核";
//                break;
//            case chushengweitongguo:
//                self.statusString = @"初审未通过";
//            case liubiao:
//                self.statusString = @"流标";
//            case biaomanfushenzhong:
//                self.statusString = @"初审通过,借款中";
//            case fushenweitongguo:
//                self.statusString = @"复审未通过";
//            case fushentonggguo:
//                self.statusString = @"复审通过,还款中";
//            case yiwancheng:
//                self.statusString = @"已完成";
//            case yiyuqi:
//                self.statusString = @"已逾期";
//            case wangzhandaihuan:
//                self.statusString = @"网站代还";
//            case yuqihuankuan:
//                self.statusString = @"逾期还款";
//            default:
//                break;
//        }
    }
    return self;

}

+ (void)myReceiveWithBlcok:(void (^)(NSMutableArray *mutableArray,NSError *error))block{

    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    [CailaiAPIClient requestWithParams:[NSDictionary dictionaryWithObjectsAndKeys:@"receive.calendar",@"sname", nil] setCookie:@"" success:^(id JSON) {
        if (block) {
            NSArray *array = [JSON objectForKey:@"data"];
            for (NSDictionary *dic in array) {
                MyReceiveObj *myObject = [[MyReceiveObj alloc] initWithAttribut:dic];
                [mutableArray addObject:myObject];
            }
            block(mutableArray,nil);
        }
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
    } method:@"POST"];


}
@end
