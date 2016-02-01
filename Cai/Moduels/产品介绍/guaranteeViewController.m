//
//  guaranteeViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/10.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "guaranteeViewController.h"

@interface guaranteeViewController ()

@end

@implementation guaranteeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

      
      self.title = @"抵押物信息";
   // [self loadWebPageWithString:[NSString stringWithFormat:@"http://apitest.cailai.com/test/4/diyawuxinxi.html?bid=%d",self.bidId]];
   // [self loadWebPageWithString:@"http://www.51zovan.com/cs/dyw.html"];
   // self.webView.scalesPageToFit = YES;
    
     [self loadWebPageWithString: [URLSTRING stringByAppendingString:[NSString stringWithFormat:@"diyawuxinxi.html?bid=%d",self.bidId]]];

}

- (void)loadWebPageWithString:(NSString *)urlString
{
    
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
- (void)goBack:(id)sender
{
      
      [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
