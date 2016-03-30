//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>
#import "MYFMDB.h"
#import "GesturePasswordController.h"
#import "User.h"

#import "KeychainItemWrapper.h"

@interface GesturePasswordController ()
{
    MYFMDB *myFMDB;
}
//@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;

@end

@implementation GesturePasswordController {
    NSString * previousString;
    NSString * password;
}

@synthesize gesturePasswordView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    previousString = @"";
    
    
//    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
//    password = [keychin objectForKey:(__bridge id)kSecValueData];
    //每次弹出都要根据手势密码判断
    password = [[NSUserDefaults standardUserDefaults] objectForKey:@"kSecValueData"];
    if (!password) {//未设置手势前  不存在password 就需要看数据库是否存在用户
        //先查询数据库
        myFMDB = [[MYFMDB alloc] init];
        User *user = [User shared];

        password =  [myFMDB selectKeyWordFromTableWithData:user.mobile];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"kSecValueData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    if ([password isEqualToString:@""]) {
        
        [self reset];
    }
    else {
        [self verify];
    }

}

- (void)viewDidLoad
{
      [super viewDidLoad];
    
    
      //[self clear];
   
//    previousString = [NSString string];
//    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
//    password = [keychin objectForKey:(__bridge id)kSecValueData];
//    if ([password isEqualToString:@""]) {
//        
//        [self reset];
//    }
//    else {
//        [self verify];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma -mark 验证手势密码
- (void)verify{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    gesturePasswordView.backgroundColor = [UIColor whiteColor];
      [gesturePasswordView.tentacleView enterArgin];
    [gesturePasswordView.tentacleView setRerificationDelegate:self];
    [gesturePasswordView.tentacleView setStyle:1];//1 verify  2 reset
    gesturePasswordView.messageLabel.text = @"请输入财来网的解锁密码";
    [gesturePasswordView setGesturePasswordDelegate:self];
    [self.view addSubview:gesturePasswordView];
}

#pragma -mark 重置手势密码
- (void)reset{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    gesturePasswordView.backgroundColor = [UIColor whiteColor];
    [gesturePasswordView.tentacleView enterArgin];
    [gesturePasswordView.tentacleView setResetDelegate:self];
    [gesturePasswordView.tentacleView setStyle:2];
    gesturePasswordView.messageLabel.text = @"请设置财来网手势密码";
    [gesturePasswordView.imgView setHidden:YES];
    [gesturePasswordView.forgetButton setHidden:YES];
    [gesturePasswordView.changeButton setHidden:YES];
    [self.view addSubview:gesturePasswordView];
}

#pragma -mark 清空记录
- (void)clear{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    [keychin resetKeychainItem];
}

#pragma -mark 改变手势密码
- (void)change{
      
      
}

#pragma -mark 忘记手势密码
- (void)forget{
      //重新登录  改变手势
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"忘记手势密码会退出当前用户，需重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    
}

- (BOOL)verification:(NSString *)result{
    if ([result isEqualToString:password]) {
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        [gesturePasswordView.state setText:@"输入正确"];
        //[self presentViewController:(UIViewController) animated:YES completion:nil];
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [gesturePasswordView.state setText:@""];
              //程序进入前台激活验证手势
              if (_sVBlock) {
                  self.sVBlock();
              }
              //在我的账户设置switch的开关后调用的方法
              if (_sVForBlock) {
                  self.sVForBlock();
                  
              }
              

              
          });
        return YES;
    }
    [gesturePasswordView.state setTextColor:[UIColor redColor]];
    [gesturePasswordView.state setText:@"手势密码错误"];
   // [gesturePasswordView.tentacleView enterArgin];
    return NO;
}

- (BOOL)resetPassword:(NSString *)result{
    if ([previousString isEqualToString:@""]) {
        previousString=result;
        [gesturePasswordView.tentacleView enterArgin];
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:0.529 green:0.529 blue:0.529 alpha:1]];
        [gesturePasswordView.state setText:@"请验证输入密码"];
        return YES;
    }
    else {
        
        if ([result isEqualToString:previousString]) {
            //保存到数据库和本地
            MYFMDB *_myfmdb = [[MYFMDB alloc] init];
            User *user = [User shared];
            //保存到数据库
            [_myfmdb insertDataWithUser:user withPassWord:result];
            //保存到本地
            [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"kSecValueData"];
            
           
            [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
            [gesturePasswordView.state setText:@"已保存手势密码"];
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  //我的资产
                  if (_ssBlock) {
                    self.ssBlock();
                  }
                  //我的账户
                  if (_ssForBlock) {
                      self.ssForBlock();
                      
                  }
                  //产品介绍
                  if (_ssForProductInrB) {
                      self.ssForProductInrB();
                  }

              });
            
            return YES;
        }
        else{
            previousString =@"";
            [gesturePasswordView.state setTextColor:[UIColor redColor]];
            [gesturePasswordView.state setText:@"两次密码不一致，请重新设置"];
            [gesturePasswordView.tentacleView enterArgin];
            return NO;
        }
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

   
        //这个block是在我的账户中设置手势关闭时触发
        if (_FPWCBlock) {
            self.FPWCBlock();//清空当前保存的内容
        }
        //这个block是在由后台进入前台时触发
        else if (_FPWGBBlock)
        {
          self.FPWGBBlock();//清空当前保存的内容
        }
    
    //通知更多页面 隐藏退出按钮
    [[NSNotificationCenter defaultCenter] postNotificationName:@"exitLogin" object:nil];
}



@end
