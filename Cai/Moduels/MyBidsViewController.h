//
//  MyBidsViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/28.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MyBorrowsViewController.h"
#import "PullingRefreshTableView.h"
@class InvestObj;
@interface MyBidsViewController :UIViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>

//将投标类作为借贷类的子类
@property (nonatomic,strong) InvestObj *invest;
@property (nonatomic,strong) PullingRefreshTableView *tableView;

@end
