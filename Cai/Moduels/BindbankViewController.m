//
//  BindbankViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/15.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "BindbankViewController.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "HuifuHttpService.h"
#import "AnimationView.h"
#define URL HUIFUURL
@interface BindbankViewController ()

@end

@implementation BindbankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.title = @"绑定银行卡";
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self binkbankFn];
}

-(void)binkbankFn
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AnimationView hideCustomAnimationViweFromView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [User bindBankCardWithBlock:^(NSDictionary *posts, NSError *error) {
            if (error) {
                
                if (error.code == 500) {
                    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:[NSString stringWithFormat:@"%@", error.domain]
                                                                       delegate:nil
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"确定", nil];
                    alertview.delegate = self;
                    alertview.tag = 1000;
                    [alertview show];

                }
                else
                {
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:[NSString stringWithFormat:@"%@", error.domain]
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"确定", nil];
                    alertview.tag = 1001;
                    alertview.delegate = self;
                [alertview show];
                }
                //[MBProgressHUD hideHUDForView:self.view animated:YES];

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
        }];
    });

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == 1000) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if (alertView.tag == 1001) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


@end
