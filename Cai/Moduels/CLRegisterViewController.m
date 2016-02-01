//
//  CLRegisterViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "CLRegisterViewController.h"
#import "VerificatieViewController.h"
#import "User.h"

@interface CLRegisterViewController ()

@end

@implementation CLRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
      self.title = @"填写手机号";
      self.view.backgroundColor = UIColorFromRGB(0xf0eff4);
      self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelFn)];
      _telephoneNum.delegate = self;
      _telephoneNum.keyboardType = UIKeyboardTypeNumberPad;
    [_telephoneNum addTarget:self action:@selector(isChangeBtnColor:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelFn
{
      [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)aggreFn:(id)sender {
}

- (IBAction)protocolFn:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.cailai.com/bangzhu/fuwu.html"]];
}

- (IBAction)nextFn:(UIButton *)sender {
    [_telephoneNum  resignFirstResponder];
    if ([self checkPhoneNum]) {
        [self checkRegistered:_telephoneNum.text];
//        VerificatieViewController *verificatieVC = [[VerificatieViewController alloc] init];
//        [self.navigationController pushViewController:verificatieVC animated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"您输入的号码不正确"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"知道了", nil];
        [alertView show];
    }
}



-(void)isChangeBtnColor:(UITextField *)textField
{
    if (textField.text.length == 11) {
        _nextBtn.backgroundColor = UIColorFromRGB(0xf39700);
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}


- (BOOL)checkPhoneNum {
    NSString *regex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.telephoneNum.text];
    return isMatch;

}

- (BOOL)checkRegistered:(NSString *)string{
    __block Boolean isRegistered = false;
    [User isRegisteredWithBlock:^(Boolean data, NSError *error) {
        if (!error) {
            if (data == YES) {
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"该手机号已经注册"
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"确定", nil];
                [alertview show];
            }
            else
            {
            VerificatieViewController *verificatieVC = [[VerificatieViewController alloc] init];
            verificatieVC.mobileString = string;
            [self.navigationController pushViewController:verificatieVC animated:YES];
            isRegistered = true;
            }
        }
        else if (error.code == -1009)
        {
            ALERTVIEW;
        }
        else  {
            isRegistered = false;
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil
                                                                message:[NSString stringWithFormat:@"%@", error.domain]
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确定", nil];
            [alertview show];
        }
    } withMobile:_telephoneNum.text];
    return isRegistered;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_telephoneNum resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_telephoneNum resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    DLog(@"-----------结束编辑-------");
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    if (textField.text.length>11) {
        DLog(@"---------------------");
    }
}
@end
