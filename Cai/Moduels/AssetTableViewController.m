//
//  AssetTableViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/2.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//
typedef NS_ENUM(NSInteger,AlertType){
    AlertTypeShoushi = 2000,
    AlertTypeOverdue,
    AlertTypeNetWorkError,
    AlertTypeFingerPrint,
    AlertTypeEvaluateError
};

#import "AssetTableViewController.h"
#import "AssetCell.h"
#import "RechargeViewController.h"
#import "RecordViewController.h"
#import "DrawViewController.h"
#import "CLLoginViewController.h"
#import "WithDrawViewController.h"
#import "MyRecommendsViewController.h"
#import "MyBidsViewController.h"
#import "MyBorrowsViewController.h"
#import "AssetObj.h"
#import "CLRegisterViewController.h"
#import "BidsRecomendedViewController.h"
#import "GesturePasswordController.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "MyReceiveViewController.h"
#import "MYFMDB.h"
#import "User.h"
#import "MyReturnedMoneyTableViewController.h"
#import "DebitTableViewController.h"
#import "AnimationView.h"
#import "InterestCountViewController.h"
#import "AAPLLocalAuthentication.h"
#define rechageAndWithdrawBtnHeight  41
@interface AssetTableViewController ()<UIAlertViewDelegate>
{

      UIView *backView;//背景图
      UIImageView *backImageView;//财神图
      UIButton *loginBtn;//登录按钮
    MBProgressHUD *progressHUD;
    
    UIView *maskView;
    UIImageView *imageView;
    UIButton *btn;
    UIButton *registBtn ;
    
    NSMutableArray *cellImageArray;
}
@property(nonatomic,strong)GesturePasswordController *gestureVC;
@property(nonatomic,assign)AlertType alertType;
@end

@implementation AssetTableViewController

- (void)viewDidLoad {
     [super viewDidLoad];
    
    //创建手势密码视图
    _gestureVC = [[GesturePasswordController alloc] init];
    [_gestureVC clear];
    
    
      CGRect  frame=CGRectMake(0, 0, DeviceSizeWidth, DeviceSizeHeight-20-40-TABHEIGHT);
      _tableView = [[PullingRefreshTableView alloc] initWithFrame:frame pullingDelegate:self];
      
      
      //设置背景色为白色
      self.view.backgroundColor = BACKGROUND_COLOR;
      //设置导航条不是半透明的
      self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    
      self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
      self.tableView.tableFooterView = [[UIView alloc] init];
      self.tableView.dataSource = self;
      self.tableView.delegate = self;
      [self.view addSubview:self.tableView];
      
      
      DLog(@"%@",NSStringFromCGRect(self.view.frame));
      
    

      //网络请求
      _mutableArray = [NSMutableArray arrayWithObjects:@"我的投标",@"我的推荐",@"交易记录",@"我的借款",@"资金统计", nil];
    
     cellImageArray = [NSMutableArray arrayWithObjects:@"我的投标",@"我的推荐",@"交易记录",@"我的借款",@"利息统计", nil];
    //接受注册成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentView) name:@"sucessRegist" object:nil];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kUserMobile"]) {
        [self loadDataWithAnimationView];
    }
    

    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rechargeBacKMethod:) name:@"rechargeBackToRootNotification" object:nil];//充值成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawBacKMethod:) name:@"drawBackToRootNotification" object:nil];//提现成功的通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreLoginReturnBack:) name:@"moreLoginReturnBack" object:nil];//我的账户中，登陆成功
}

- (void)moreLoginReturnBack:(NSNotification *)info
{
    [self loadDataWithAnimationView];
}

- (void)rechargeBacKMethod:(NSNotification *)info
{
    [self loadDataWithAnimationView];
}

- (void)drawBacKMethod:(NSNotification *)info
{
    [self loadDataWithAnimationView];
}


-(void)presentView
{
    [[UIApplication sharedApplication].keyWindow makeToast:@"注册成功，请登录" duration:2 position:[NSValue valueWithCGPoint:CGPointMake(DeviceSizeWidth/2.0,DeviceSizeHeight/2.0-70/ViewWithDevicHeight)] title:@"温馨提示:"];
}



-(void)setBadgeNum:(int)badgeNum
{
    _badgeNum = badgeNum;
    [self.tableView reloadData];
}

-(void)unLoginFn
{
   
        //未登录
    if (!maskView) {
    
        //1 .添加蒙版图
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40)];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.6;
        [self.view addSubview:maskView];
    }
        //2.添加图片
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 200/ViewWithDevicWidth, 300/ViewWithDevicHeight)];
        imageView.center = CGPointMake(maskView.center.x, maskView.center.y-20/ViewWithDevicHeight) ;
        imageView.image = [UIImage  imageNamed:@"28"];
        [self.view addSubview:imageView];

    }
        DLog(@"self.view 的frame为：%@",NSStringFromCGRect(self.view.frame));
        //添加登录和注册的按钮
    if (!btn) {
        
        //登录
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(imageView.frame.origin.x , self.view.frame.size.height-40/ViewWithDevicHeight-170/ViewWithDevicHeight, 166/ViewWithDevicWidth, 40/ViewWithDevicHeight);
        btn.backgroundColor = [UIColor clearColor];
       // [btn setBackgroundColor:[UIColor blueColor]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(LoginIn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    if (!registBtn) {
        
        //注册
        
        registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        registBtn.frame = CGRectMake(imageView.frame.origin.x, btn.frame.origin.y+40, 166/ViewWithDevicWidth, 40/ViewWithDevicHeight);
        registBtn.backgroundColor = [UIColor clearColor];
      //  registBtn.backgroundColor = [UIColor redColor];
        [registBtn addTarget:self action:@selector(RegestIn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:registBtn];

    }
       
   
    
}

- (void)checkCalendar
{
     MyReturnedMoneyTableViewController *myReturnedTVC = [[MyReturnedMoneyTableViewController alloc] init];
    myReturnedTVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myReturnedTVC animated:YES];

}

- (void)rechargeFn
{
    
      RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
      rechargeVC.hidesBottomBarWhenPushed = YES;
    rechargeVC.returnBackB = ^{
        [self loadData];
    };
      [self.navigationController pushViewController:rechargeVC animated:YES];
      

}
- (void)withDrawFn
{

      DLog(@"提现");
      DrawViewController   *withDrawVC = [[DrawViewController alloc] init];
      withDrawVC.hidesBottomBarWhenPushed = YES;
      withDrawVC.returnBackB = ^{
        [self loadData];
    };
      [self.navigationController pushViewController:withDrawVC animated:YES];
}

- (void)debitFN
{

    DLog(@"借贷");
    DebitTableViewController   *debitVC = [[DebitTableViewController alloc] init];
    debitVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:debitVC animated:YES];

}

- (void)viewWillAppear:(BOOL)animated
{
    
     [super viewWillAppear:YES];
    //如果已经有......
    if(maskView||imageView||btn||registBtn)
    {
    
        [maskView removeFromSuperview];
        [imageView removeFromSuperview];
        [btn removeFromSuperview];
        [registBtn removeFromSuperview];
        maskView = nil;
        imageView = nil;
        btn= nil;
        registBtn = nil;
        
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"kUserId"]) {
        [self unLoginFn];
        return;
    }
    
    
}


-(void)LoginIn:(id)sender
{

    CLLoginViewController *CLLoginVC = [[CLLoginViewController alloc] init];
    CLLoginVC.hidesBottomBarWhenPushed = YES;
    CLLoginVC.sucessToAssetLB = ^{
       
        
        [maskView removeFromSuperview];
        [imageView removeFromSuperview];
        [btn removeFromSuperview];
        [registBtn removeFromSuperview];
        maskView = nil;
        imageView = nil;
        btn= nil;
        registBtn = nil;

        
        //检测是否手势密码打开
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isOpenGesturePassword"] boolValue]== NO ) {            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录成功是否打开手势密码" message:@"还可以在更多->我的账户中打开" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"打开", nil];
            alertView.tag = AlertTypeShoushi;
            [alertView show];
        }
        [self loadDataWithAnimationView];

    };
    
    [self.navigationController pushViewController:CLLoginVC animated:YES];
    
}

-(void)RegestIn:(id)sender
{
    CLRegisterViewController *CLRegistVC = [[CLRegisterViewController alloc] init];
    CLRegistVC.hidesBottomBarWhenPushed = YES;
    
    [maskView removeFromSuperview];
    [imageView removeFromSuperview];
    [btn removeFromSuperview];
    [registBtn removeFromSuperview];
    maskView = nil;
    imageView = nil;
    btn= nil;
    registBtn = nil;
    
    [self.navigationController pushViewController:CLRegistVC animated:YES];
}

- (void)loadDataWithAnimationView
{
    [AnimationView showCustomAnimationViewToView:self.view];
    [self loadData];
}

- (void)loadData
{
    
    
      dispatch_async(dispatch_get_global_queue(0, 0), ^{
          
         
          //加载数据
          [AssetObj getAssetWithBlock:^(id posts, NSError *error) {
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [AnimationView hideCustomAnimationViweFromView:self.view];
              });
              if(error.code == -1009)
              {
                  ALERTVIEW;
              }
              else if (error.code == 103)
              {
               //登陆账号失效 退出登陆 并加载UI视图
                  UIAlertView *aletview =  [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                  aletview.tag = AlertTypeOverdue;
                  [aletview show];
                  
              }
             
              else if(error.code>6)
              {
               UIAlertView *aletview =  [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                  aletview.tag = AlertTypeNetWorkError;
                  [aletview show];
                  
              }
              else if   (error)
              {
                  ALERTVIEW;
              }
              else
              {
                  self.assetObj = posts;
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [_tableView reloadData];
                  });
              }
//              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              
              //完成后
              [self.tableView tableViewDidFinishedLoading];
              self.tableView.reachedTheEnd  =YES;
              
          }];
          
 
      });
    
    
      
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
      if (section == 0) {
            return 1;
      }
      return _mutableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      if (indexPath.section == 0) {
            return 275;
      }
      else
      {
            return 40;
      }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      
    if (indexPath.section == 0) {
        //利用xib创建cell
        static NSString *CellIdentifier = @"AssetCell";
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"AssetCell" owner:nil options:nil];
        AssetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //      目的：是找LPCustomCell对应的 拖拽的cell
        for (id obj in nibs)
        {
            if ([obj isKindOfClass:[AssetCell class]])
            {
                cell = (AssetCell *)obj ;
                break;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clickCellBTNBlock = ^(NSInteger tag){
        //充值
            if (tag == 3000) {
                [self rechargeFn];
            }
            //借贷
            if (tag == 3001) {
                [self debitFN];
            }
            //提现
            if (tag == 3002) {
                [self withDrawFn];
            }
            if (tag == 3003) {
                [self checkCalendar];
            }
            
        };
        cell.userInteractionEnabled = YES;
        cell.assetObj = _assetObj;
        return cell;
      }
    else
    {
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell  =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            UIImageView *accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-20, 17, 9, 16)];
            accessoryImageView.tag = 1000;
            [cell.contentView addSubview:accessoryImageView];
            
            UIImageView *cellimageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 13, 15, 15)];
            cellimageView.tag = 1002;
            [cell.contentView addSubview:cellimageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12+16+ 12, 6, DeviceSizeWidth-100, 33)];
            label.tag = 1001;
            label.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:label];
            
            if (indexPath.row == 2) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
                label.backgroundColor = [UIColor redColor];
                label.layer.cornerRadius = 8.0;
                label.alpha = 0;              
                label.tag = 1003;
                [cell addSubview:label];
            }
            
            

        }
        UIImageView *accessoryImageView = (UIImageView *)[cell.contentView viewWithTag:1000];
        accessoryImageView.image = [UIImage imageNamed:@"13"];
        
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:1001];
        label.text = [_mutableArray objectAtIndex:indexPath.row];
        
        UIImageView *cellImageView = (UIImageView *)[cell.contentView viewWithTag:1002];
        cellImageView.image = [UIImage imageNamed:[cellImageArray objectAtIndex:indexPath.row]];
        
        if (_badgeNum>0) {
            UILabel *lab = (UILabel *)[cell viewWithTag:1003];
            lab.alpha = 1;
            lab.text = @"1";
        }
        if (_badgeNum==0) {
            UILabel *lab = (UILabel *)[cell viewWithTag:1003];
            lab.alpha = 0;
            
        }
        return cell;
    }
    
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
      if (section == 0) {
            return 0;
      }
      else{
      return 10;
      }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
      
      UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceSizeWidth, 20)];
      view.backgroundColor =BACKGROUND_COLOR;
      return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
      
      return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
      
      UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceSizeWidth, 20)];
      view.backgroundColor = [UIColor grayColor];
      return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      

      if (indexPath.row == 0 && indexPath.section == 1) {
            MyBidsViewController *myBidsVC = [[MyBidsViewController alloc] init];
            myBidsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myBidsVC animated:YES];
      }
      if (indexPath.row == 1) {
            MyRecommendsViewController *myRecommendVC = [[MyRecommendsViewController alloc] init];
            myRecommendVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myRecommendVC animated:YES];
      }
      if (indexPath.row == 2) {
            WithDrawViewController *withDrawVC = [[WithDrawViewController alloc] init];
            withDrawVC.hidesBottomBarWhenPushed = YES;
           self.badgeNum = 0;
            [self.navigationController pushViewController:withDrawVC animated:YES];
      }
      if (indexPath.row == 3) {
            MyBorrowsViewController *myBorrowsVC = [[MyBorrowsViewController alloc] init];
            myBorrowsVC.hidesBottomBarWhenPushed = YES;
          
            [self.navigationController pushViewController:myBorrowsVC animated:YES];
            
      }
    if (indexPath.row == 4) {
        InterestCountViewController *interestVC = [[InterestCountViewController alloc] init];
        interestVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:interestVC animated:YES];
        
    }

   
}


#pragma mark----------
#pragma mark - PullingRefreshTableViewDelegate
//在pullingTableView触发此代理方法------

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    
      [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
      NSDateFormatter *df = [[NSDateFormatter alloc] init ];
      df.dateFormat = @"yyyy-MM-dd HH:mm";
      //NSDate *date = [df dateFromString:@"2013-11-03 10:10"];
      NSDate *date = [NSDate date];
      
      return date;
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
      [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1f];
}
#pragma mark------------
#pragma mark - Scroll
//下拉 触发 UIScrollview的代理方法-----------------------调用pulling的方法--
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
      [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
      [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark----------
#pragma mark alertviewDelegate-------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{//取消
    
    switch (alertView.tag) {
        case AlertTypeShoushi:
        {
            if (buttonIndex==0) {
                DLog(@"忽略");
                BOOL isOpenGesturePassword = NO;
                [[NSUserDefaults  standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenGesturePassword] forKey:@"isOpenGesturePassword"];
                
            }
            else
            {
                
                
                __block AssetTableViewController *weakSelf = self;
                _gestureVC.ssBlock = ^{
                    
                    //在我的资产设置手势成功后 。。。。
                    BOOL isOpenGesturePassword = YES;
                    [[NSUserDefaults  standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenGesturePassword] forKey:@"isOpenGesturePassword"];
                    [[NSUserDefaults  standardUserDefaults] synchronize];
                    DLog(@"设置成功");
                    
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    
                    UIAlertView *fingerAlertview = [[UIAlertView alloc] initWithTitle:nil message:@"开启指纹解锁" delegate:weakSelf cancelButtonTitle:@"不开启" otherButtonTitles:@"好的", nil];
                    fingerAlertview.tag = AlertTypeFingerPrint;
                    [fingerAlertview show];
                    
                };
                //1 查询数据库看数据库中是否有用户的信息
                MYFMDB *_myFMDB = [[MYFMDB alloc] init];
                if (![_myFMDB isTableOK]) {
                    [_myFMDB createTable];
                }
                User *user = [User shared];
                BOOL isExist =  [_myFMDB selectData:user.mobile];//用户是否登录过本机
                if (isExist) {//登陆过
                    BOOL isOpenGesturePassword = YES;
                    //..........手势密码状态打开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenGesturePassword] forKey:@"isOpenGesturePassword"] ;
                    [[NSUserDefaults standardUserDefaults] synchronize];//同步
                    //.........查询数据库在本地保存手势密码
                    NSString  *passWord =  [_myFMDB selectKeyWordFromTableWithData:user.mobile];
                    [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:@"kSecValueData"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }                
                else
                {
                    [self presentViewController:_gestureVC animated:YES completion:nil];
                }
                
            }

        }
            break;
        case AlertTypeNetWorkError:
            
            break;
        case AlertTypeOverdue:
        {
            //点击确定之后跳转到登陆接口
        }
            break;
        case AlertTypeFingerPrint:
        {
            if (buttonIndex==1) {
            
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
            AAPLocalAu.evaluateFailedCallBackB = ^(NSString *msg,NSInteger errorCoe)
            {
            //失败分为很多种   后弹出设置失败，可在'我的账户'-'指纹'中再次设置
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *errorAlert = [[UIAlertView alloc]  initWithTitle:nil message:@"设置失败，可在'我的账户'-'指纹'中再次设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    errorAlert.tag = AlertTypeEvaluateError;
                    [errorAlert show];
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
            else if (buttonIndex == 0)
            {//取消
                BOOL isOpenFingerprint = NO;
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenFingerprint]  forKey:@"isOpenFingerprint"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
            break;
            case AlertTypeEvaluateError:
        {
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
        }
            break;
            
        default:
            break;
    }
    
    
    
}



@end
