//
//  FindBackPasswordViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/7/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "FindBackPasswordViewController.h"
#import "User.h"
#import "UIView+Toast.h"
#import "IQKeyboardManager.h"
#import "NSTimer+Util.h"
@interface FindBackPasswordViewController ()
{
    NSTimer *timer;
}
@end

@implementation FindBackPasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //设置IQKeyboard可用
    [[IQKeyboardManager sharedManager] setEnable:YES];
    timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timePassFn:) userInfo:nil repeats:YES];
    [timer pauseTimer];
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.view.backgroundColor = [UIColor whiteColor];
    
    _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)timePassFn:(NSTimer *)atimer
{
    
    _getVertifiedCodeBtn.userInteractionEnabled = NO;
    static NSInteger count = 60;
    count--;
   // [_getVertifiedCodeBtn setTitle:[NSString stringWithFormat:@"重发(%ld秒)",(long)count] forState:UIControlStateNormal];
    _getVertifiedCode.text = [NSString stringWithFormat:@"重发(%ld秒)",(long)count] ;
    if (count==0) {
        
        
        count = 60;
        _getVertifiedCode.text = @"获取验证码";
        [atimer pauseTimer];
        _getVertifiedCodeBtn.userInteractionEnabled = YES;
    }
}



- (IBAction)GetVertifiedMessage:(id)sender {
    
    if (_phoneNumberTextField.text.length == 0) {
        [self.view makeToast:@"请输入手机号码" duration:2 position:@"center"];
    }
    else if(![self checkPhoneNum])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的手机号" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    
    }
    else
    {
        [timer resumeTimer];
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [User pushThevrtifidPasswordWithBlock:^(NSString *posts, NSError *error) {
                if (!error) {
                    [self.view makeToast:@"请稍后,验证码已发送" duration:2.0 position:@"center"];
                }
                else if(error.code<100&&error.code>0)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                    
                }
                else
                {
                    ALERTVIEW;
                }
                
            } withPhoneNumber:_phoneNumberTextField.text];

        });
        
    }
}

- (IBAction)disMissCurrentView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (BOOL)checkPhoneNum {
    NSString *regex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.phoneNumberTextField.text];
    return isMatch;
    
}

- (IBAction)AffirmChangePassWord:(id)sender {
    if (_VertifiedCode.text.length == 0) {
        [self.view makeToast:@"请输入短信验证码" duration:2.0 position:@"center"];
    }
    else if(_NewPassWord.text.length == 0)
    {
        [self.view makeToast:@"请输入新的登录密码" duration:2.0 position:@"center"];
    }
    else if(_VeitifiedNewPassWord.text.length == 0)
    {
        [self.view makeToast:@"请再次输入密码" duration:2.0 position:@"center"];
    }
    else if(![_VeitifiedNewPassWord.text isEqualToString:_NewPassWord.text])
    {
        [self.view makeToast:@"两次输入密码不一致" duration:2.0 position:@"center"];
        
    }
    else
    {
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [User changeUsersPasswordWithBlock:^(NSString *posts, NSError *error) {
            if (!error) {
                if ([posts boolValue]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self dismissViewControllerAnimated:YES completion:^{
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"修改密码成功请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                [alertView show];
                            }];
                        });
                        
                    });
                }
                
            }
        } withVertifiedCode:_VertifiedCode.text withNewPassword:_VeitifiedNewPassWord.text];
    });
    }
}
@end
