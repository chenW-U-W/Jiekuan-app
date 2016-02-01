//
//  MyReturnedMoneyTableViewController.h
//  Cai
//
//  Created by csj on 15/8/18.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomCalendarViewController;
@class MessageTableViewController;
@interface MyReturnedMoneyTableViewController : UITableViewController
@property(nonatomic,strong) CustomCalendarViewController *customCalendarVC;
@property(nonatomic,strong) MessageTableViewController *messageTVC;

@property(nonatomic,strong)NSString *shouldReturnedMoneyString;//应收回款
@property(nonatomic,strong)NSString *returnedMoneyString;//已收回款

@property(nonatomic,strong)NSMutableArray *mont_releatedTotalArray;
@end
