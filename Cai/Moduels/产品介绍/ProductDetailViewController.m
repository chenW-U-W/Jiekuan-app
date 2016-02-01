//
//  ProductDetailViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/10.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "CailaiAPIClient.h"
@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
      
    [super viewDidLoad];
      self.title = @"产品详情";
    //[self loadWebPageWithString:[NSString stringWithFormat:@"http://apitest.cailai.com/test/4/biaodexiangqing.html?bid=%d",self.bidId]];
    //清理webview的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    [self loadWebPageWithString: [URLSTRING stringByAppendingString:[NSString stringWithFormat:@"biaodexiangqing.html?bid=%d",self.bidId]]];
}

- (void)loadWebPageWithString:(NSString *)urlString
{
    
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}


//     NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"borrow.detail",@"sname",nil];
//    [self recommendedWithBlock:^(id response, NSError *error) {
//        
//    } withParam:param];
//    }

//- (NSURLSessionDataTask *)recommendedWithBlock:(void (^)(id response, NSError *error))block  withParam:(NSDictionary *)param{
//    
//   
//    
//    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
//        
//        NSString *responseString =  [JSON objectForKey:@"data"];
//        
//        
//        if (block) {
//            block(responseString,nil);
//        }
//        
//    } failure:^(NSError *error) {
//        if (block) {
//            block(@"请求失败", error);
//        }
//    } method:@"POST"];
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

- (void)goBack:(id)sender
{

      [self.navigationController popViewControllerAnimated:YES];

}
@end
