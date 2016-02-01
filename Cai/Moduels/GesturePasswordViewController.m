//
//  GesturePasswordViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/17.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "GesturePasswordViewController.h"
#import "GesturePasswordController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "AnimationView.h"

@interface GesturePasswordViewController ()
{
      GesturePasswordController *gestureVC;
}
@end

@implementation GesturePasswordViewController

- (void)viewDidLoad {
      
    [super viewDidLoad];
      self.view.backgroundColor = UIColorFromRGB(0xf0eff4);
     UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
      button.frame = CGRectMake(100,100,100,100);
      [button addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
      [button setBackgroundColor:[UIColor redColor]];
      [self.view addSubview:button];
      
      
      MBProgressHUD *MBPHUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
      [self.view addSubview:MBPHUD];
      MBPHUD.color = [UIColor whiteColor];
      MBPHUD.labelColor = [UIColor redColor];
      MBPHUD.activityIndicatorColor = [UIColor greenColor];
      MBPHUD.labelText = @"正在加载请稍候";
      MBPHUD.detailsLabelText = @"呵呵呵";
      MBPHUD.detailsLabelColor = [UIColor blueColor];
      [MBPHUD showAnimated:YES whileExecutingBlock:^{
            NSLog(@"%@",@"do somethings....");
            [NSThread sleepForTimeInterval:2.0];
      } completionBlock:^{
            [MBPHUD removeFromSuperview];
            
      }];
      
      gestureVC = [[GesturePasswordController alloc] init];
      [gestureVC clear];
      
      
      [self.view makeToast:@"启竹科技有限公司" duration:20.0 position:  [NSValue valueWithCGPoint:CGPointMake(100, 400)]     title:@"THIS"];
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnclick:(UIButton *)btn
{

//      [UMSocialSnsService presentSnsIconSheetView:self
//                                           appKey:@"507fcab25270157b37000010"
//                                        shareText:@"你要分享的文字"
//                                       shareImage:[UIImage imageNamed:@"icon.png"]
//                                  shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
//                                         delegate:self];
    
      
      
      
//      __weak GesturePasswordViewController *weakSelf = self;
//      __weak GesturePasswordController *weakgestureVC = gestureVC;
//      gestureVC.ssBlock = ^{
//      
//            [weakSelf dismissViewControllerAnimated:weakgestureVC completion:nil];
//      };
//      [self presentViewController:gestureVC animated:YES completion:nil];
    
}
@end
