//
//  Product_assignTableViewController.h
//  Cai
//
//  Created by csj on 15/8/25.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductIntrViewController;
@class Product_assign;
typedef void(^PushToProductIntr) (NSString *);
@interface Product_assignTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) ProductIntrViewController *productIntrVC;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) Product_assign *product_assign;
@property (nonatomic,strong) PushToProductIntr pushToPuc;

@end
