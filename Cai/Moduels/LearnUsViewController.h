//
//  LearnUsViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "borroweViewController.h"

@interface LearnUsViewController : UIViewController<UIWebViewDelegate>


- (void)loadWebPageWithString:(NSString *)urlString;

@end
