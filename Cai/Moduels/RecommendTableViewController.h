//
//  RecommendTableViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/2.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import <StoreKit/StoreKit.h>

@class RecommendedObj;
@interface RecommendTableViewController : UIViewController<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UITabBarControllerDelegate,SKStoreProductViewControllerDelegate>
@property (nonatomic,strong) PullingRefreshTableView *tableView;
@property (nonatomic,strong) RecommendedObj *recomendedObj;

@end
