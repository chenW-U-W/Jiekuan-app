//
//  MyBorrowsViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/28.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
@interface MyRecommendsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate>
@property (nonatomic,strong)PullingRefreshTableView *tableView;
@property (nonatomic,strong)NSMutableArray *totalArray;
@property (nonatomic,strong)NSMutableArray *valueArray;
@property (nonatomic,strong)NSMutableArray *mutableArray;

@end
