//
//  ProductIntrViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/8.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
typedef void(^ReturnedCallBackBlock)(void) ;
@class ProductDetail;
@interface ProductIntrViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,UITabBarControllerDelegate,UITextFieldDelegate>
@property (nonatomic , strong) PullingRefreshTableView    *tableView;
@property (nonatomic , strong) UILabel *timeLabel;
@property (nonatomic , strong) NSArray *array;
@property (nonatomic , assign) NSInteger  percent;
@property (nonatomic , strong) ProductDetail *productDetail;

@property (nonatomic , assign) int  bidId;
@property (nonatomic , strong) NSString *titleString;
@property (nonatomic , assign) NSString *add_dateTime;

@property (nonatomic , strong) NSString *bidStatus;
@property (nonatomic , copy) ReturnedCallBackBlock returnedCallBB;
@end
