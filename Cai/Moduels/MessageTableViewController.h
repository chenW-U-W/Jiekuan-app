//
//  MessageTableViewController.h
//  Cai
//
//  Created by csj on 15/8/18.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//
typedef void(^MessageNotifyBlock)(NSUInteger);
#import <UIKit/UIKit.h>

@interface MessageTableViewController : UITableViewController
@property(nonatomic,strong)NSMutableArray *totalArray;
//@property(nonatomic,strong)NSMutableArray *mont_releatedTotalArray;
@property(nonatomic,strong)MessageNotifyBlock notifyBlock;
//@property(nonatomic,strong)NSString *shouldReturnedMoneyString;//应收回款
//@property(nonatomic,strong)NSString *returnedMoneyString;//已收回款
@end
