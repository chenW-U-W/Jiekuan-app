//
//  FindBackPasswordViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/7/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindBackPasswordViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *VertifiedCode;
@property (strong, nonatomic) IBOutlet UITextField *NewPassWord;
@property (strong, nonatomic) IBOutlet UITextField *VeitifiedNewPassWord;
@property (strong, nonatomic) IBOutlet UIButton *getVertifiedCodeBtn;
@property (strong, nonatomic) IBOutlet UILabel *getVertifiedCode;
- (IBAction)GetVertifiedMessage:(id)sender;
- (IBAction)disMissCurrentView:(id)sender;

- (IBAction)AffirmChangePassWord:(id)sender;
@end
