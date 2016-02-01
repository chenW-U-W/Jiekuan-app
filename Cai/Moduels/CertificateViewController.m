//
//  CertificateViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/15.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "CertificateViewController.h"
#import "User.h"
#import "HuifuHttpService.h"
#import "MBProgressHUD.h"
#import "AnimationView.h"
@interface CertificateViewController ()

@end

@implementation CertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定汇付天下账号";
    self.webView.delegate = self;
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self getAuth];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)getAuth {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AnimationView showCustomAnimationViewToView:self.view];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [User authHuifuWithBlock:^(NSDictionary *posts, NSError *error) {
            if (!error) {
                if (posts.allKeys.count == 1) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您已经进行过身份认证" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                    [alertView show];
                }
                else
                {
                
               // NSURL *url = [NSURL URLWithString: @"http://mertest.chinapnr.com/muser/publicRequests"];
                    NSURL *url = [NSURL URLWithString: HUIFUURL];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
                [request setHTTPMethod: @"POST"];
                [request setHTTPBody: [[HuifuHttpService getFormDataString:posts] dataUsingEncoding: NSUTF8StringEncoding]];
                dispatch_async(dispatch_get_main_queue(), ^{
                      [webView loadRequest: request];
                });
                }
              
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:[NSString stringWithFormat:@"%@", error.domain]
                                                                       delegate:nil
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"确定", nil];
                    [alertview show];
                });
                
            }
        } withPhoneNumber:[[NSUserDefaults standardUserDefaults] objectForKey:@"kUserMobile"]];

    });
   }

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    [AnimationView hideCustomAnimationViweFromView:self.view];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
