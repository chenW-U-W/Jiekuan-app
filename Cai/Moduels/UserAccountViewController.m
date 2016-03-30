//
//  UserAccountViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/15.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//
typedef NS_ENUM(NSInteger,AlertType){
    AlertTypeEvaluateError = 2000
};
#import "UserAccountViewController.h"
#import "UserAccountCell.h"
#import "BindbankViewController.h"
#import "CertificateViewController.h"
#import "User.h"
#import "BindOtherBankViewController.h"
#import "ChangePasswordViewController.h"
#import "AutoBidViewController.h"
#import "GesturePasswordController.h"
#import "KeychainItemWrapper.h"
#import "CLLoginViewController.h"
#import "MYFMDB.h"
#import "AAPLLocalAuthentication.h"
@interface UserAccountViewController ()<UIAlertViewDelegate>
{
      UISwitch *gestureSwitch;
      NSArray *textArray;
      NSMutableArray *userArray;
      MYFMDB *myFMDB;
      UISwitch *fingerPrintSwitch;
}
@property (nonatomic,strong)GesturePasswordController *gestureVC;
@end

@implementation UserAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.translucent = NO;
      _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
      self.tableView.delegate = self;
      self.tableView.dataSource = self;
      [self.view addSubview:_tableView];    
      
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
      self.title = @"我的帐户";
      UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
      [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
      [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
      UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
      self.navigationItem.leftBarButtonItem = leftItem;
      
      
      textArray = [NSArray arrayWithObjects:@"绑定银行卡",@"身份认证",@"修改登录密码",@"手势密码",@"指纹", nil];
     _gestureVC = [[GesturePasswordController alloc] init];
     userArray = [[NSMutableArray alloc] init];
    
    
   }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self loadData] ;
   
}
//身份认证后需要返回用户姓名
-(void)loadData
{

    [User getRealNameWithBlock:^(NSDictionary *posts, NSError *error) {
        if (error) {
            DLog(@"error");
            
        }
        else if (posts.allKeys.count == 0)
        {
        
        }
        else
        {
            NSString *realNameString = [posts objectForKey:@"real_name"];
            
                [[NSUserDefaults standardUserDefaults] setObject:realNameString forKey:@"kUserRealName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [_tableView reloadData]; 
            
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

      return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

      if (section == 0) {
            return 1;
      }else{
            NSLog(@"%lu",(unsigned long)textArray.count);
            return textArray.count;
      
      }
     
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

      return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
      
      return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

      if (indexPath.section == 0) {
            return 100;
      }
      else
      {
      
            return 50;
      }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        UserAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserAccountCell"];
        if (!cell) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UserAccountCell" owner:nil options:nil];
            for (id objec in array) {
                if ([objec isKindOfClass:[UserAccountCell class]]) {
                    cell = (UserAccountCell *)objec;
                    cell.textLabel.font = ConstFont;
                    break;
                }
                
            }
            
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kUserId"]) {
            cell.user= [User shared]; //如果用户登录则从本地读取用户信息
            //cell.userArray = userArray;
        }
        else
        {
        }
        
        cell.userInteractionEnabled = NO;
        return cell;
        
    }
    

    UITableViewCell*  cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableviewCell"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 17, 120, 16)];
        label.text = [textArray objectAtIndex:indexPath.row];
        label.font = ConstFont;
        [cell.contentView addSubview:label];
        UIImageView * arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-20, 17, 9, 16)] ;
        arrowView.image = [UIImage imageNamed:@"13"];
        [cell.contentView addSubview:arrowView];
        cell.userInteractionEnabled = YES;
        if (indexPath.row==3 || indexPath.row ==4) {
            [arrowView removeFromSuperview];
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //-------------------
    
    
        if (indexPath.section == 1) {
           //手势密码
        if(indexPath.row == 3)
        {
            
            
            if (!gestureSwitch) {
                gestureSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 10- 50, 14, 43, 22)];
                gestureSwitch.onTintColor = [UIColor orangeColor];
            } 
            
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isOpenGesturePassword"]) {
                    gestureSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isOpenGesturePassword"] boolValue];
                }
                else
                {
                    gestureSwitch.on = NO;
                }
                
                [gestureSwitch addTarget:self action:@selector(gestureCodeFn:) forControlEvents:UIControlEventValueChanged];
                
            
            [cell.contentView addSubview:gestureSwitch];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //如果用户未登录 隐藏cell
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"kUserId"]) {
                cell.hidden = YES;
                
            }
            
            return cell;
            
            
        }
            //指纹
            if(indexPath.row == 4)
            {
                
                
                if (!fingerPrintSwitch) {
                    fingerPrintSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 10- 50, 14, 43, 22)];
                    fingerPrintSwitch.onTintColor = [UIColor orangeColor];
                }
                
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isOpenFingerprint"]) {
                    fingerPrintSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isOpenFingerprint"] boolValue];
                }
                else
                {
                    fingerPrintSwitch.on = NO;
                }
                
                [fingerPrintSwitch addTarget:self action:@selector(fingerGestureCodeFn:) forControlEvents:UIControlEventValueChanged];
                
                
                [cell.contentView addSubview:fingerPrintSwitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                //如果用户未登录  隐藏cell
                if (![[NSUserDefaults standardUserDefaults] objectForKey:@"kUserId"] ) {
                    cell.hidden = YES;
                    
                }
                
                return cell;
                
                
            }

        
        
        
    }
    
    return cell;
 }

#pragma mark  ----指纹开关-------
- (void)fingerGestureCodeFn:(UISwitch *)aswitch
{
    BOOL isOpenGesturePassword =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"isOpenFingerprint"] boolValue];
    isOpenGesturePassword = !isOpenGesturePassword;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenGesturePassword] forKey:@"isOpenFingerprint"] ;
    [[NSUserDefaults standardUserDefaults] synchronize];//同步
    
    if (isOpenGesturePassword) {//由关闭到打开
        //点击确定之后开启密码
        AAPLLocalAuthentication *AAPLocalAu = [[AAPLLocalAuthentication alloc] init];
        
        [AAPLocalAu canEvaluatePolicy];
        AAPLocalAu.aapLocalAuSucessedCallBackB= ^(NSString *msg){
            
            NSLog(@"验证成功");
        };
        
        [self presentViewController:AAPLocalAu animated:NO completion:^{
            
        }];
        
        AAPLocalAu.evaluateSucessedCallBackB = ^(NSString *msg)
        {
            NSLog(@"-----");
            BOOL isOpenFingerprint = YES;
            [[NSUserDefaults  standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenFingerprint] forKey:@"isOpenFingerprint"];
            [[NSUserDefaults  standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
        };
        DLog(@"----%d",[[NSThread currentThread] isMainThread]);
        __block BOOL isOpenGesturePasswordWeak = isOpenGesturePassword;
        AAPLocalAu.evaluateFailedCallBackB = ^(NSString *msg,NSInteger errorCoe)
        {
            //失败分为很多种   后弹出设置失败，可在'我的账户'-'指纹'中再次设置
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *errorAlert = [[UIAlertView alloc]  initWithTitle:nil message:@"设置失败，可在'我的账户'-'指纹'中再次设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                errorAlert.tag = AlertTypeEvaluateError;
                [errorAlert show];
            });
            isOpenGesturePasswordWeak = !isOpenGesturePasswordWeak;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenGesturePasswordWeak] forKey:@"isOpenFingerprint"] ;
            [[NSUserDefaults standardUserDefaults] synchronize];//同步
            
            dispatch_async(dispatch_get_main_queue(), ^{
                gestureSwitch.on = isOpenGesturePasswordWeak;
            });
            
            switch (errorCoe) {
                case -1:
                {
                    //三次错误
                }
                    break;
                case -2:
                {
                    //点击取消
                    
                }
                    
                    break;
                case -4:
                {
                    //被系统取消
                }
                    break;
                case -3:
                {
                    //输入密码   被隐藏了
                }
                    
                    break;
                    
                default:
                    break;
            }
            
        };
        [AAPLocalAu evaluatePolicy];

    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

      if (indexPath.row == 0) {
          BindOtherBankViewController *bindOtherBank = [[BindOtherBankViewController alloc] init];
          bindOtherBank.hidesBottomBarWhenPushed = YES;
          [self.navigationController pushViewController:bindOtherBank animated:YES];

      }
      if (indexPath.row == 1) {//身份验证
            CertificateViewController *certificateVC = [[CertificateViewController alloc] init];
            certificateVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:certificateVC animated:YES];
      }
      if (indexPath.row == 2) {
            DLog(@"修改登录密码");
          ChangePasswordViewController *changePassWordVC = [[ChangePasswordViewController alloc] init];
          changePassWordVC.hidesBottomBarWhenPushed  = YES;
          [self.navigationController pushViewController:changePassWordVC animated:YES];
      }

}
-(void)goBack:(id)sender
{

      [self.navigationController popViewControllerAnimated:YES];
}


- (void)gestureCodeFn:(UISwitch *)aswitch
{
    
    BOOL isOpenGesturePassword =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"isOpenGesturePassword"] boolValue];
    isOpenGesturePassword = !isOpenGesturePassword;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenGesturePassword] forKey:@"isOpenGesturePassword"] ;
    [[NSUserDefaults standardUserDefaults] synchronize];//同步
    
   // __block UserAccountViewController *weakSelf = self;
    //__block GesturePasswordController *weakgestureVC = _gestureVC;
    __block UISwitch *weakgestureSwitch = gestureSwitch;
    
    
    myFMDB = [[MYFMDB alloc] init];
    User *user = [User shared];
    
    //当 改变switch开关后   由 NO->YES时  是设置手势
    if (isOpenGesturePassword == YES) {
        //如果已经设置过手势就不需要在设置手势
        NSString* password = [[NSUserDefaults standardUserDefaults] objectForKey:@"kSecValueData"];
        if (!password) {//未设置手势前  不存在password 就需要看数据库是否存在用户
            //先查询数据库
            
            password =  [myFMDB selectKeyWordFromTableWithData:user.mobile];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"kSecValueData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }     
        // 注：不存在用户 返回的password为@“”
        // 存在时：
        if (![password isEqualToString:@""]) {
            //改变switch的状态
            gestureSwitch.on = YES;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenGesturePassword] forKey:@"isOpenGesturePassword"] ;
           
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        //不存在时：
        else{
        DLog(@"设置手势");
            
            //数据库中有此用户，数据库中无此用户
            //有此用户
            //1 查询数据库看数据库中是否有用户的信息
            
            if (![myFMDB isTableOK]) {
                [myFMDB createTable];
            }
           
            BOOL isExist =  [myFMDB selectData:user.mobile];//用户是否登录过本机
            if (isExist) {
                BOOL isOpenGesturePassword = YES;
                //..........
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenGesturePassword] forKey:@"isOpenGesturePassword"] ;
                [[NSUserDefaults standardUserDefaults] synchronize];//同步
                
                //同时要取得手势密码
               NSString *passWord = [myFMDB selectKeyWordFromTableWithData:user.mobile];
               //保存到本地
                [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:@"kSecValueData"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
            }
            //弹出 验证手势
            else
            {
           // password =  [myFMDB selectKeyWordFromTableWithData:user.mobile];
       
        _gestureVC.ssForBlock = ^{
            BOOL isOpenGesturePassword = YES;
            [[NSUserDefaults  standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenGesturePassword] forKey:@"isOpenGesturePassword"];
            [[NSUserDefaults  standardUserDefaults] synchronize];
            //改变switch的状态
            weakgestureSwitch.on = YES;            
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
        };
                
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_gestureVC animated:YES completion:nil];
        }
            
        }
        

    }
    //当 改变switch开关后   由 YES->NO时  是验证手势
    else
    {      
        _gestureVC.sVForBlock = ^{
            BOOL isOpenGesturePassword = NO;
            [[NSUserDefaults  standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenGesturePassword] forKey:@"isOpenGesturePassword"];
            [[NSUserDefaults  standardUserDefaults] synchronize];
            //改变switch的状态
            weakgestureSwitch.on = NO;
            
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
        };
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_gestureVC animated:YES completion:nil];
        
        
        //这个block不能放在viewDidLoad中
         __block UserAccountViewController *weakSelf = self;
        _gestureVC.FPWCBlock= ^{
            [weakSelf forgetPassWord];
        };
        
        DLog(@"验证手势，正确后关闭手势");
    }

    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}


- (void)forgetPassWord
{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您已退出当前账户请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [User logout];
    [_gestureVC dismissViewControllerAnimated:YES completion:^{DLog(@"---------------");}];
    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
