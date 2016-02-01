//
//  AssetTableViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/2.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
@class AssetObj;
@interface AssetTableViewController : UIViewController<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong) NSMutableArray *mutableArray;
@property (nonatomic , strong) PullingRefreshTableView *tableView;
@property (nonatomic , strong) AssetObj *assetObj;
@property (nonatomic , assign) int badgeNum;
@end
