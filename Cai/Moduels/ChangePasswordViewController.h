//
//  ChangePasswordViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/5/7.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *nextPasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *changeBtn;
- (IBAction)changePasswordBtn:(id)sender;

@end
