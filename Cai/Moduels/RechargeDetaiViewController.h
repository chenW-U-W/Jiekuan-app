//
//  RechargeDetaiViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/15.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "borroweViewController.h"
@interface RechargeDetaiViewController : borroweViewController<UIAlertViewDelegate,UIWebViewDelegate>
@property (nonatomic,strong)NSString *amountSting;
@end
