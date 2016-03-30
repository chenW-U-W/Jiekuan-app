//
//  ProductTableViewController.h
//  Cai
//
//  Created by Cameron Ling on 15/4/2.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
@class ProductIntrViewController;
@class Product;
typedef void(^PushToProductIntr) (NSString *);

@interface ProductTableViewController : UIViewController<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) ProductIntrViewController *productIntrVC;
@property (nonatomic,strong) PullingRefreshTableView *productTableView;
@property (nonatomic,strong) PullingRefreshTableView *assignTableView;
@property (nonatomic,strong) Product *product;
@property (nonatomic,assign) BOOL needRefresh;
@property (nonatomic,strong) PushToProductIntr pushToPuc;

@end
