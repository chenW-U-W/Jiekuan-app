//
//  MoreTableViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/2.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendTableViewController.h"
#import "UMSocial.h"
@interface MoreTableViewController : UITableViewController<UIAlertViewDelegate,UMSocialUIDelegate>
@property(nonatomic,strong)RecommendTableViewController *recommendVC;
@end
