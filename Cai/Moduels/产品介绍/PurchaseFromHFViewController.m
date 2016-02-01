//
//  PurchaseFromHFViewController.m
//  Cai
//
//  Created by qiuqiuqiu on 15/5/27.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "PurchaseFromHFViewController.h"
#import "User.h"
#import "HuifuHttpService.h"
#import "MBProgressHUD.h"
#import "AnimationView.h"
@interface PurchaseFromHFViewController ()

@end

@implementation PurchaseFromHFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买";
    webView.delegate = self;
    [self drawFromFH];
}

- (void)drawFromFH
{   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       // NSURL *url = [NSURL URLWithString: @"http://mertest.chinapnr.com/muser/publicRequests"];
        NSURL *url = [NSURL URLWithString: HUIFUURL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: [[HuifuHttpService getFormDataString:_dic] dataUsingEncoding: NSUTF8StringEncoding]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [webView loadRequest: request];
            [AnimationView hideCustomAnimationViweFromView:self.view];
        });
       
    });
    
    
}

- (void)goBack:(id)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[AnimationView showCustomAnimationViewToView:self.view];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //[AnimationView hideCustomAnimationViweFromView:self.view];
}


//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alertView show];
//
//}
@end
