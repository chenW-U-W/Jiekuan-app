//
//  ChangePasswordViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/5/7.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "CailaiAPIClient.h"
#import "UIView+Toast.h"
@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    self.nextPasswordTextField.delegate = self;
    self.nextPasswordTextField.secureTextEntry = YES;
    self.PasswordTextField.delegate = self;
    self.PasswordTextField.secureTextEntry = YES;
    [self.PasswordTextField becomeFirstResponder];
    
    _changeBtn.backgroundColor = UIColorFromRGB(0xf39700);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)loadData
{
    if ((self.PasswordTextField.text.length>=6)&&([self.PasswordTextField.text isEqualToString:self.nextPasswordTextField.text])) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self getDataWithBlock:^(NSString* response, NSError *error) {
                if (error) {
                    DLog(@"ERROR----");
                }
                else
                {
                    BOOL isSucess = [response boolValue];
                    
                    if (isSucess) {
                        DLog(@"成功");
                        [self.view.window makeToast:@"密码修改成功" duration:2.0 position:@"center"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else
                    {
                    
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"密码修改失败请注意格式" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];

                        DLog(@"失败");
                    }
                    
                }
            }  withPassword:self.PasswordTextField.text];
        });
    }
    else
    {
        [self.view makeToast:@"您的密码小于6位" duration:2.0 position:@"center"];
        DLog(@"不符合要求");
        
    }
   
    
}

- (NSURLSessionDataTask *)getDataWithBlock:(void (^)(id response, NSError *error))block withPassword:(NSString *)password {
    
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"password.modify",@"sname", password,@"passwd",nil];
    
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        
        NSString *responseString =  [JSON objectForKey:@"data"];
       
        if (block) {
            block(responseString,nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(@"请求失败", error);
        }
    } method:@"POST"];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [self.PasswordTextField resignFirstResponder];
    [self.nextPasswordTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;
}



- (IBAction)changePasswordBtn:(id)sender {
    
      [self loadData];
}

-(void)goBack:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
