//
//  WithDrawViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/15.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
@interface WithDrawViewController : UIViewController<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)PullingRefreshTableView *tableView;
@property(nonatomic,strong)NSDictionary *recordDic;
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)NSMutableArray *totalArray;

@end
