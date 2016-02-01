//
//  RecordViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/13.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
@interface RecordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
@property (nonatomic,strong)PullingRefreshTableView *tableView;
@end
