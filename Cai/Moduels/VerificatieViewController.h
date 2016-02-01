//
//  VerificatieViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificatieViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *phoneMessageLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneMessageTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *resendBtn;
@property (strong, nonatomic) IBOutlet UITextField *recommendTextField;
@property (strong, nonatomic) IBOutlet UITextField *vertifiedTextField;

@property (nonatomic,strong) NSString *mobileString;
- (IBAction)resendFn:(id)sender;
- (IBAction)nextTepFn:(id)sender;

@end
