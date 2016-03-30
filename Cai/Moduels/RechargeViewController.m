//
//  RechargeViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/15.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargeDetaiViewController.h"
#import "UIView+Toast.h"
#import "User.h"
@interface RechargeViewController ()

@end

@implementation RechargeViewController

- (void)viewDidLoad {
      [super viewDidLoad];
      self.title = @"充值";
      self.view.backgroundColor = UIColorFromRGB(0xf0eff4);
      UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
      [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
      [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
      UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
      self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    
      self.amountTextField.delegate = self;
      self.amountTextField.keyboardType =  UIKeyboardTypeDecimalPad;
    //[self.amountTextField becomeFirstResponder];
    
    
    //添加提现金额不得小于100
    UILabel *alertView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    alertView.text = @"充值金额不得小于100元";
    alertView.font = [UIFont systemFontOfSize:13];
    alertView.textColor = [UIColor whiteColor];
    alertView.backgroundColor = NORMALCOLOR;
    alertView.tag = 1000;
    alertView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, -15);
    alertView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:alertView];
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];
    _rechargeBtn.userInteractionEnabled = YES;
}
- (void)didReceiveMemoryWarning {
      [super didReceiveMemoryWarning];
      
}
- (BOOL)textFieldShouldReturn
{
    [_amountTextField resignFirstResponder];
      return YES;
}
- (void)goBack:(id)sender
{
    
      [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rechargeBtn:(UIButton *)sender
{
    
    [self.amountTextField resignFirstResponder];
    float amount = [self.amountTextField.text floatValue];
    
    if (_amountTextField.text.length<= 0 || [_amountTextField.text doubleValue]<100.00) {
        //弹出aletview
        UILabel *alertLabel = (UILabel *)[self.view viewWithTag:1000];
        
        [UIView animateWithDuration:0.5 animations:^{
            alertLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, 15);
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    alertLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, -15);
                }];
                
            });
            
        }];
        return;
    }

    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    if (amount) {
        RechargeDetaiViewController *rechargeDetailVC = [[RechargeDetaiViewController alloc] init];
        rechargeDetailVC.amountSting = self.amountTextField.text;
        [self.navigationController pushViewController:rechargeDetailVC animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入金额" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    
        DLog(@"请输入金额");
    }
    });
    
        
    
}

-(void)dealloc
{
    _amountTextField.delegate = nil;
}




#pragma mark
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
      
      textField.text = @"";
      
      
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
      [textField resignFirstResponder];
      
      return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
      
      [self.amountTextField   resignFirstResponder];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    _rechargeBtn.userInteractionEnabled = YES;
}
@end
