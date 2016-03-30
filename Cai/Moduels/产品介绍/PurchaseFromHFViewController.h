//
//  PurchaseFromHFViewController.h
//  Cai
//
//  Created by qiuqiuqiu on 15/5/27.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "borrowerViewController.h"
//typedef void(^ReturnedCallBackBlock)(void) ;
@interface PurchaseFromHFViewController : borrowerViewController<UIWebViewDelegate>
@property(nonatomic,strong)NSString *amountSting;
@property(nonatomic,strong)NSDictionary *dic;//接收表单字典
//@property (nonatomic , copy) ReturnedCallBackBlock returnedCallBB;
@end
