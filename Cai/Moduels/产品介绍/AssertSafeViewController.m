//
//  AssertSafeViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/10.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "AssertSafeViewController.h"

@interface AssertSafeViewController ()

@end

@implementation AssertSafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       
      self.title = @"资产安全";
      //[self loadWebPageWithString:@"http://apitest.cailai.com/test/4/zichananquan.html"];
    
    [self loadWebPageWithString: [URLSTRING stringByAppendingString:@"zichananquan.html"]];
}
- (void)loadWebPageWithString:(NSString *)urlString
{
    
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack:(id)sender
{
      
      [self.navigationController popViewControllerAnimated:YES];
}


@end
