//
//  VerificatieViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "VerificatieViewController.h"
#import "NSTimer+Util.h"
#import "CailaiAPIClient.h"
#import "User.h"
#import "CLLoginViewController.h"
#import "IQKeyboardManager.h"
@interface VerificatieViewController ()
{

      NSTimer *timer;
      UILabel *timelabel;
}
@end

@implementation VerificatieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置IQKeyboard可用
     [[IQKeyboardManager sharedManager] setEnable:YES];
    
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
      timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timePassFn:) userInfo:nil repeats:YES];
      [timer pauseTimer];
      
      
      self.view.backgroundColor = UIColorFromRGB(0xf0eff4);
      self.title = @"填写验证码";
      UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
      [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
      [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
      UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
      self.navigationItem.leftBarButtonItem = leftItem;
      
      timelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _resendBtn.frame.size.width, _resendBtn.frame.size.height)];
      timelabel.font = [UIFont systemFontOfSize:15];
      [_resendBtn addSubview:timelabel];

      
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleFn)];
      
      _phoneMessageTextField.delegate = self;
      _passwordTextField.delegate = self;
      
      NSMutableAttributedString *attribbuteSting = [[NSMutableAttributedString alloc] initWithString:_phoneMessageLabel.text];
      [attribbuteSting addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(4, 11)];
      _phoneMessageLabel.attributedText = attribbuteSting;
    _phoneMessageLabel.text =[NSString stringWithFormat:@"已经向%@发送验证码",_mobileString ];
      _phoneMessageTextField.keyboardType = UIKeyboardTypePhonePad;
    
    
     
      [self resendFn:_resendBtn];

    
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

- (void)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cancleFn
{


      [self.navigationController popViewControllerAnimated:YES];
}
//重发
- (IBAction)resendFn:(id)sender {    
    
      [timer resumeTimer];
   [User getMsgCodeWithBlock:^(Boolean data, NSError *error) {
       if (data ==YES) {
           
       }
   } withMobile:_mobileString];
}


- (void)timePassFn:(NSTimer *)atimer
{
 
      _resendBtn.userInteractionEnabled = NO;
      static NSInteger count = 60;
      count--;
      timelabel.text = [NSString stringWithFormat:@"重发(%ld秒)",(long)count];
      if (count==0) {
           
           
            count = 60;
            timelabel.text = @"重发";
             [atimer pauseTimer];
             _resendBtn.userInteractionEnabled = YES;
      }
}


- (IBAction)nextTepFn:(id)sender {
    
    if ([_vertifiedTextField.text isEqualToString:_passwordTextField.text]) {
        [User registerWithBlock:^(NSDictionary *posts, NSError *error) {
            if (error.code == -1009) {
                ALERTVIEW;
            }
            else if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sucessRegist" object:nil];//注册成功后 向登录界面和我的资产界面发送信息@“注册成功请登录”
                [self.navigationController  popToRootViewControllerAnimated: YES];
            }
        } withMobile:_mobileString withPassword:_passwordTextField.text withRecommended:_recommendTextField.text withTelcode:_phoneMessageTextField.text];
        
    }
    else
    {
    
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:nil message:@"两次密码输入不正确请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
   
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
      [_passwordTextField resignFirstResponder];
      [_phoneMessageTextField resignFirstResponder];
    [_vertifiedTextField resignFirstResponder];

}

#pragma mark
#pragma ------------textfieldDelegate------

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

      [_passwordTextField resignFirstResponder];
      [_phoneMessageTextField resignFirstResponder];
    [_vertifiedTextField resignFirstResponder];
      return YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    _passwordTextField.text = @"";
    _vertifiedTextField.text = @"";
   }


@end
