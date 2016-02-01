//
//  FHViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/27.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "FHViewController.h"
#import "User.h"
#import "HuifuHttpService.h"
#import "MBProgressHUD.h"
#import "AnimationView.h"
@interface FHViewController ()

@end

@implementation FHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"提现";    
    self.webView.delegate = self;
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self drawFromFH];
}

- (void)drawFromFH
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AnimationView showCustomAnimationViewToView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [AnimationView hideCustomAnimationViweFromView:self.view];
        [User drawFromFHWithBlock:^(NSDictionary  *posts, NSError *error) {
            if (!error) {
              //  NSURL *url = [NSURL URLWithString: @"http://mertest.chinapnr.com/muser/publicRequests"];
                NSURL *url = [NSURL URLWithString: HUIFUURL];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
                [request setHTTPMethod: @"POST"];
                [request setHTTPBody: [[HuifuHttpService getFormDataString:posts] dataUsingEncoding: NSUTF8StringEncoding]];
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
                    else if(error.code == 501)
                    {
                       
                            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                 message:[NSString stringWithFormat:@"%@", error.domain]
                                                                                delegate:nil
                                                                       cancelButtonTitle:nil
                                                                       otherButtonTitles:@"确定", nil];
                            alertview.delegate = self;
                            alertview.tag = 1001;
                            [alertview show];
                        

                    }
                    else{
                        
                        
                        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                            message:[NSString stringWithFormat:@"%@", error.domain]
                                                                           delegate:nil
                                                                  cancelButtonTitle:nil
                                                                  otherButtonTitles:@"确定", nil];
                        alertview.delegate = self;
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


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [AnimationView hideCustomAnimationViweFromView:self.view];
     //[MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
