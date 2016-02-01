//
//  RechargeDetaiViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/15.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "RechargeDetaiViewController.h"
#import "User.h"
#import "HuifuHttpService.h"
#import "CertificateViewController.h"
#import "MBProgressHUD.h"
#import "AnimationView.h"
@interface RechargeDetaiViewController ()


@end

@implementation RechargeDetaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.title = @"充值";
    self.webView.delegate = self;
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self getRecharge];
    
}
- (void)getRecharge
{

   // [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    [AnimationView showCustomAnimationViewToView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [User rechargeWithBlock:^(NSDictionary  *posts, NSError *error) {
            if (!error) {
                NSURL *url = [NSURL URLWithString: HUIFUURL];
               // NSURL *url = [NSURL URLWithString: @"https://lab.chinapnr.com/muser/publicRequests"];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
                [request setHTTPMethod: @"POST"];
                [request setHTTPBody: [[HuifuHttpService getFormDataString:posts] dataUsingEncoding: NSUTF8StringEncoding]];
                //[request setValue: forKey:<#(NSString *)#>];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [webView loadRequest: request];                    
                });
               
                
            } else {
                

                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    
                    if (error.code == 500) {
                        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                             message:[NSString stringWithFormat:@"%@", error.domain]
                                                                            delegate:nil
                                                                   cancelButtonTitle:nil
                                                                   otherButtonTitles:@"确定", nil];
                        alertview.delegate = self;
                        alertview.tag = 1000;
                        [alertview show];
                    }
                    else{
                        
                        
                        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                            message:[NSString stringWithFormat:@"%@", error.domain]
                                                                           delegate:nil
                                                                  cancelButtonTitle:nil
                                                                  otherButtonTitles:@"确定", nil];
                        [alertview show];
                    }
                    
                    
                });
                
            }
            
        } withAmount:_amountSting];
    });
    
    
}
- (void)goBack:(id)sender
{
    
      [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
 //[MBProgressHUD hideHUDForView:self.view animated:YES];
    [AnimationView hideCustomAnimationViweFromView:self.view];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
