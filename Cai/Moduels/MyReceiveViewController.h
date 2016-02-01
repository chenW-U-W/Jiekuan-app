//
//  MyReceiveViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/7/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
@interface MyReceiveViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate>
@property (nonatomic,strong)PullingRefreshTableView *tableView;



@end
