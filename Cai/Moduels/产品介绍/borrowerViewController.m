//
//  borrowerViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/5/22.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "borrowerViewController.h"

@interface borrowerViewController ()

@end

@implementation borrowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebPageWithString: [URLSTRING stringByAppendingString:[NSString stringWithFormat:@"jiekuanrenxinxi.html?bid=%d",self.bidId]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadWebPageWithString:(NSString *)urlString
{
    
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
