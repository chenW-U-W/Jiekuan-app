//
//  UserAccountViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/15.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAccountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;

@end
