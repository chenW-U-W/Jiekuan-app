//
//  BidProtocolViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/7/24.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "BidProtocolViewController.h"

@interface BidProtocolViewController ()

@end

@implementation BidProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"借款协议";
    [self loadWebPageWithString: [URLPROTOCOLSTRING stringByAppendingString:[NSString stringWithFormat:@"bid=%d",self.bidId]]];
    
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
