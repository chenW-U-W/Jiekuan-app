//
//  GesturePasswordController.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "TentacleView.h"
#import "GesturePasswordView.h"

typedef void(^successedSetBlock)(void);
typedef void(^successedVerificateBlock)(void);

typedef void(^successedSetForProductIntrVCBlock)(void);

typedef void(^successedSetForUserAccountVCBlock)(void);
typedef void(^successedVerificateForUserAccountVCBlock)(void);

typedef void (^forgetPassWordWhenCloseBlock)(void);
typedef void (^forgetPassWordWhenGoBackBlock)(void);

@interface GesturePasswordController : UIViewController <VerificationDelegate,ResetDelegate,GesturePasswordDelegate>

@property(strong,nonatomic)successedSetBlock ssBlock;//我的资产界面回调
@property(strong,nonatomic)successedVerificateBlock sVBlock;

@property(strong,nonatomic)successedSetForUserAccountVCBlock ssForBlock;
@property(strong,nonatomic)successedVerificateForUserAccountVCBlock sVForBlock;//我的账户回调 switch开关的改变回调

@property(strong,nonatomic)successedSetForProductIntrVCBlock ssForProductInrB;//产品介绍界面的回调

@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;

@property (nonatomic,strong) forgetPassWordWhenCloseBlock FPWCBlock;
@property (nonatomic,strong) forgetPassWordWhenGoBackBlock FPWGBBlock;
- (void)clear;



@end
