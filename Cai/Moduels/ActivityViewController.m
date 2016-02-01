//
//  ActivityViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/5/11.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "ActivityViewController.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadWebPageWithString:@"http://www.baidu.com"];
//    [];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"了解我们" ofType:@"html"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
//    [webView loadRequest:request];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"了解我们" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *path = [[NSBundle mainBundle] resourcePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [webView loadHTMLString:htmlString baseURL:baseURL];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
   
}


@end
