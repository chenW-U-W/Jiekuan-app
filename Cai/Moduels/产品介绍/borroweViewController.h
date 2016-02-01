//
//  borroweViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/10.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface borroweViewController : UIViewController<UIWebViewDelegate>
{

      UIActivityIndicatorView *activityIndicatorView;
      UIWebView *webView;
}
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,assign)int bidId;
@end
