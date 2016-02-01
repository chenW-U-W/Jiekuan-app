//
//  CLLoginViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^successLoginBlock)(void);
typedef void(^successLoginToAssetBlock)(void);
typedef void(^successLoginToProductIntrBlock)(void);//产品介绍登录成功回调

@interface CLLoginViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *telephoneLabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordLabel;
@property (strong, nonatomic) successLoginBlock sucessLB;
@property (strong, nonatomic) successLoginToAssetBlock sucessToAssetLB;
@property (strong, nonatomic) successLoginToProductIntrBlock sucessToProductIntrB;
@property (strong, nonatomic) IBOutlet UIButton *LoginBtn;

- (IBAction)loginBtn:(id)sender;
- (IBAction)FindBackPassWord:(id)sender;
- (IBAction)registIn:(id)sender;

@end
