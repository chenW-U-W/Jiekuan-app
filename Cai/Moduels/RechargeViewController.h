//
//  RechargeViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/15.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnBackBlock)();
@interface RechargeViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (strong, nonatomic) ReturnBackBlock returnBackB;

- (IBAction)rechargeBtn:(id)sender;
@end
