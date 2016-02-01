//
//  LearnUsViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "LearnUsViewController.h"

@interface LearnUsViewController ()
{
    
    UIActivityIndicatorView *activityIndicatorView;
    UIWebView *webView;
}
@end

@implementation LearnUsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.title = @"了解财来";
   
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20 )];
    [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
     webView.delegate =self;
    [self loadWebPageWithString:[URLSTRING stringByAppendingString:@"liaojiewomen.html"]];//  @"http://apitest.cailai.com/test/4/liaojiewomen.html"];
    [self.view addSubview:webView];
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
   
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite] ;
    [self.view addSubview : activityIndicatorView] ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicatorView startAnimating] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicatorView stopAnimating];
}
- (void)goBack:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    
    if ([error code] == NSURLErrorCancelled)  return;
    
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
    
}

- (void)loadWebPageWithString:(NSString *)urlString
{
    
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}


@end
