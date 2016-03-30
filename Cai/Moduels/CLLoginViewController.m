//
//  CLLoginViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "CLLoginViewController.h"
#import "CLRegisterViewController.h"
#import "User.h"
#import "UIView+Toast.h"
#import "FindBackPasswordViewController.h"
enum
{
    OKBUTTONTAG = 1000,
    CANCELTAG = 1001

}alertViewTag;

@interface CLLoginViewController ()

@end

@implementation CLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.translucent = NO;
      self.view.backgroundColor = UIColorFromRGB(0xf0eff4);
      self.title = @"登录";
      UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
      [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
      [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
      UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
      self.navigationItem.leftBarButtonItem = leftItem;
      
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
//      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registeFn)];
    
      _telephoneLabel.delegate = self;
      _passwordLabel.delegate = self;
      _telephoneLabel.keyboardType = UIKeyboardTypeNumberPad;
    //接受注册成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentView) name:@"sucessRegist" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)presentView
{
[[UIApplication sharedApplication].keyWindow makeToast:@"注册成功，请登录" duration:2 position:[NSValue valueWithCGPoint:CGPointMake(DeviceSizeWidth/2.0,DeviceSizeHeight/2.0-70/ViewWithDevicHeight)] title:@"温馨提示:"];
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registIn:(id)sender
{


    [_telephoneLabel resignFirstResponder];
    [_passwordLabel resignFirstResponder];
    
    //注册
    CLRegisterViewController *CLRegisterVC = [[CLRegisterViewController alloc] init];
    CLRegisterVC.hidesBottomBarWhenPushed  = YES;
    [self.navigationController    pushViewController:CLRegisterVC animated:YES];

}



- (IBAction)loginBtn:(id)sender {
    [_telephoneLabel resignFirstResponder];
    [_passwordLabel resignFirstResponder];
  [_LoginBtn setUserInteractionEnabled:NO];
    _telephoneLabel.delegate = nil;
    _passwordLabel.delegate = nil;
           dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [User loginWithBlock:^(NSArray *posts, NSError *error) {
                if (!error) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        BOOL isOpenGesturePassword = NO;
                        [[NSUserDefaults  standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenGesturePassword] forKey:@"isOpenGesturePassword"];//登录成功时先设置手势密码关闭
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        if (_sucessLB) {
                            self.sucessLB();//在更多界面上显示@“登录成功”
                            
                        }
                        if (_sucessToAssetLB) {
                            self.sucessToAssetLB();//在我的资产界面显示是否设置手势
                        }
                        if (_sucessToProductIntrB) {
                            self.sucessToProductIntrB();//在产品详情页显示@“登录成功”
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"moreLoginReturnBack" object:self];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                   
                    
                    
                    
                   
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _telephoneLabel.delegate = self;
                        _passwordLabel.delegate = self;
                        [_LoginBtn  setUserInteractionEnabled:YES];
                        
                        NSString *errMsg = @"";
                        if (error.code == -1009) {
                            errMsg  = @"网络异常";
                        }
                        else if (error.code == 9999) {
                            errMsg = @"用户名或密码错误，请输入正确的用户名和密码。";
                        } else {
                            errMsg = [NSString stringWithFormat:@"%@", error.domain];
                        }
                        
                        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil
                                                                            message:errMsg
                                                                           delegate:nil
                                                                  cancelButtonTitle:nil
                                                                  otherButtonTitles:@"确定", nil];
                        alertview.tag = CANCELTAG;
                        alertview.delegate = self;
                        [alertview show];
                    });
                }
            } withMobile:_telephoneLabel.text withPassword:_passwordLabel.text];
               
        });
   
    }

- (IBAction)FindBackPassWord:(id)sender {
    FindBackPasswordViewController *findBackPasswordVC = [[FindBackPasswordViewController alloc] init];
    [self.navigationController presentViewController:findBackPasswordVC animated:YES completion:^{
        
    }];
    
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 100) {
        textField.secureTextEntry = YES;
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
      [_telephoneLabel resignFirstResponder];
      [_passwordLabel resignFirstResponder];
      return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
      [_telephoneLabel resignFirstResponder];
      [_passwordLabel resignFirstResponder];

}

#pragma mark ----------
#pragma --------alertViewDelegate----------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CANCELTAG) {
        
    }
   
    
}

-(void)dealloc

{
    _telephoneLabel.delegate = nil;
    _passwordLabel.delegate = nil;

}

@end
