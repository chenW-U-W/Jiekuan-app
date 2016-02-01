//
//  ProductIntrViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/8.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "ProductIntrViewController.h"
#import "ProductIntrCell.h"
#import "ProductDetailViewController.h"
#import "borrowerViewController.h"
#import "guaranteeViewController.h"
#import "AssertSafeViewController.h"
#import "purchaseViewController.h"
#import "NSTimer+Util.h"
#import "QZProgressView.h"
#import "ProductDetail.h"
#import "BidsRecomendedViewController.h"
#import "CLLoginViewController.h"
#import "GesturePasswordController.h"
#import "MBProgressHUD.h"
#import "BidProtocolViewController.h"
#import "MYFMDB.h"
#import "User.h"
#import "AnimationView.h"
#import "AnimationView.h"
#define labelWidth 45/ViewWithDevicWidth
#define anotherCellHeight 40/ViewWithDevicWidth
#define timeIntFontSize 16
@interface ProductIntrViewController ()
{

      NSString *remaindTimeString;
      UILabel *daytimeLabel;
     
      UILabel *hourtimeLabel;
    
      UILabel *minuteTimeLabel;
   
      UILabel *secondTimeLabel;
      
      UIView *timeView;

      int timeout;
    
    NSTimeInterval b;
    
    NSTimer *timer;
    
    UIButton *purchaseButton ;
    
    UILabel *timeOutLabel;
    
    MBProgressHUD *progressHUD;
    
    UIImageView *animatedImageView;
    BOOL isDoAnimation;
    
    UIView *blockModelView;//模板视图
    UIView *countView;//计算器视图
    UILabel *MessageTextLabel;//提示信息
    UITextField *textVeiw;//文本框视图
    
    UILabel *perMonth_InterestLabel;//每月利息
    UILabel *totalInterestLabel;//利息收入
    UILabel *deadedLine_profileLabel;//到期收益
    UIButton *countBtn;//计算器按钮
}
@property(nonatomic,strong)GesturePasswordController *gestureVC;
@end

@implementation ProductIntrViewController

//转化时间  看距离截止时间的时间差
- (void)time:(NSInteger)remainedTime
{
   
//    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[_add_dateTime doubleValue]];
//    // NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:1435402658];
//    DLog(@"%@",startDate);
//    b = [startDate timeIntervalSinceDate:[NSDate date]];
    timeout = (double)remainedTime;
    if (timeout<0|timeout==0|_productDetail.ratio==100) {//如果时间小于或等于0，或者进度达到100  购买按钮变为灰色
        if (purchaseButton) {
            [purchaseButton removeFromSuperview];
            purchaseButton = [UIButton buttonWithType:UIButtonTypeSystem];
            purchaseButton.frame = CGRectMake(PURCHASEHEIGHT, [UIScreen mainScreen].bounds.size.height-PURCHASEHEIGHT-64, [UIScreen mainScreen].bounds.size.width-PURCHASEHEIGHT, PURCHASEHEIGHT);
            purchaseButton.userInteractionEnabled = NO;
            //[purchaseButton setBackgroundColor:[UIColor lightGrayColor]];
            [purchaseButton setBackgroundImage:[UIImage imageNamed:@"12-1"] forState:UIControlStateNormal];
            [purchaseButton setTitle:@"投 资 满 额" forState:UIControlStateNormal];
            [purchaseButton setTintColor:[UIColor whiteColor]];
            purchaseButton.titleLabel.font = [UIFont systemFontOfSize:18];
            [self.view addSubview:purchaseButton];

        }
        if (countBtn) {
            [countBtn removeFromSuperview];
            countBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            countBtn.frame =  CGRectMake(0, [UIScreen mainScreen].bounds.size.height-PURCHASEHEIGHT-64,PURCHASEHEIGHT, PURCHASEHEIGHT);
            [countBtn setBackgroundImage:[UIImage imageNamed:@"计算器按钮灰"] forState:UIControlStateNormal];
            countBtn.userInteractionEnabled = NO;
            [self.view addSubview:countBtn];
        }
           }

}



- (void)viewDidLoad {
     [super viewDidLoad];
    
    _gestureVC = [[GesturePasswordController alloc] init];
    [_gestureVC clear];
    
     timeout = 0;
      //设置标题
      self.title = _titleString;
      //隐藏tabbar这种方法不行
//      self.tabBarController.tabBar.hidden = YES;
      CGRect  frame=CGRectMake(0, 0, DeviceSizeWidth, DeviceSizeHeight);
      _tableView = [[PullingRefreshTableView alloc] initWithFrame:frame pullingDelegate:self];
      
      UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
      //leftButton.backgroundColor = [UIColor redColor];
      [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
      [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
      [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
      
      UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
      self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};

      //设置背景色为白色
      self.view.backgroundColor = [UIColor whiteColor];
      //设置导航条不是半透明的
      self.navigationController.navigationBar.translucent = NO;
      self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
      self.tableView.tableFooterView = [[UIView alloc] init];
      self.tableView.dataSource = self;
      self.tableView.backgroundColor = UIColorFromRGB(0xf0eff4);
      //self.tableView.backgroundColor = [UIColor redColor];
      self.tableView.delegate = self;
      self.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+60);
      [self.view addSubview:self.tableView];
    
    DLog(@"大小为---%@",NSStringFromCGRect(self.view.frame));
//       timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(runTime:) userInfo:nil repeats:YES];
//        NSRunLoop *myrunloop = [NSRunLoop currentRunLoop];
//        [myrunloop addTimer:timer forMode:NSRunLoopCommonModes];
    
    //添加立即抢购按钮
    
    purchaseButton = [UIButton buttonWithType:UIButtonTypeSystem];
   // purchaseButton.frame = CGRectMake(PURCHASEHEIGHT, [UIScreen mainScreen].bounds.size.height-PURCHASEHEIGHT, [UIScreen mainScreen].bounds.size.width-PURCHASEHEIGHT, PURCHASEHEIGHT);
     purchaseButton.frame = CGRectMake(PURCHASEHEIGHT, [UIScreen mainScreen].bounds.size.height-PURCHASEHEIGHT-64, [UIScreen mainScreen].bounds.size.width-PURCHASEHEIGHT, PURCHASEHEIGHT);
    [purchaseButton addTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
    [purchaseButton setBackgroundImage:[UIImage imageNamed:@"图层-0"] forState:UIControlStateNormal];
    [purchaseButton setTitle:@"立即抢购" forState:UIControlStateNormal];
    [purchaseButton setTintColor:[UIColor whiteColor]];
    purchaseButton.titleLabel.font = [UIFont systemFontOfSize:18];
    //[[UIApplication sharedApplication].keyWindow  addSubview:purchaseButton];
    [self.view addSubview:purchaseButton];
    //添加计算按钮
    countBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    countBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-PURCHASEHEIGHT,PURCHASEHEIGHT, PURCHASEHEIGHT);
    countBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-PURCHASEHEIGHT-64,PURCHASEHEIGHT, PURCHASEHEIGHT);
    [countBtn setBackgroundImage:[UIImage imageNamed:@"计算器按钮"] forState:UIControlStateNormal];
    [countBtn setBackgroundImage:[UIImage imageNamed:@"计算器按钮"] forState:UIControlStateHighlighted];
    [countBtn addTarget:self action:@selector(presentCountView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:countBtn];
      
}

- (void)presentCountView
{
//加载模板试图
    blockModelView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    blockModelView.backgroundColor = [UIColor grayColor];
    blockModelView.alpha = 0.4;
    [[UIApplication sharedApplication].keyWindow addSubview:blockModelView];
//加载计算器试图
//    countView = [[UIView alloc] initWithFrame:CGRectMake(40/ViewWithDevicWidth, 80/ViewWithDevicHeight, 240/ViewWithDevicWidth, 240/ViewWithDevicWidth)];
    countView = [[UIView alloc] initWithFrame:CGRectMake(40/ViewWithDevicWidth, [UIScreen mainScreen].bounds.size.height, 240, 240)];
    countView.center = CGPointMake(self.view.center.x, [UIScreen mainScreen].bounds.size.height+80/ViewWithDevicHeight);
    [UIView animateWithDuration:0.3 animations:^{
        countView.frame = CGRectMake(40/ViewWithDevicWidth, 80/ViewWithDevicHeight, 240, 240);
        countView.center = CGPointMake(self.view.center.x, self.view.frame.origin.y+130/ViewWithDevicHeight);
    } completion:^(BOOL finished) {
        
    }];
    countView.backgroundColor = [UIColor whiteColor];
    countView.layer.cornerRadius = 5;
    [[UIApplication sharedApplication].keyWindow addSubview:countView];
    
    //title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.text = @"收益计算器";
    label.font = [UIFont boldSystemFontOfSize:19];
    label.center = CGPointMake(120, 25);
    [countView addSubview:label];
    //XX
    UIButton  *removeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [removeBtn setBackgroundImage:[UIImage imageNamed:@"移除"] forState: UIControlStateNormal];
    removeBtn.frame = CGRectMake(countView.frame.size.width-32, 2, 30, 30);
    [removeBtn addTarget:self action:@selector(removeCurrentView) forControlEvents:UIControlEventTouchUpInside];
    [countView addSubview:removeBtn];
    
    //文本框
    textVeiw = [[UITextField alloc] initWithFrame:CGRectMake(10, 45, 220, 40 )];
    [textVeiw becomeFirstResponder];
    textVeiw.keyboardType = UIKeyboardTypeNumberPad;
    textVeiw.delegate = self;
    textVeiw.placeholder = @"请输入金额";
    textVeiw.center =  CGPointMake(120, 40+20+3);
    textVeiw.layer.borderWidth = 1;
    textVeiw.layer.cornerRadius = 5;
    textVeiw.layer.borderColor = [UIColor redColor].CGColor;
    UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 60, textVeiw.frame.size.height)];
    leftLabel.font = [UIFont systemFontOfSize:15];
    leftLabel.text = @"输入金额";
    textVeiw.leftView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, textVeiw.frame.size.height)] ;
    [textVeiw.leftView addSubview:leftLabel];
    textVeiw.leftView.backgroundColor = [UIColor clearColor];
    textVeiw.leftViewMode =UITextFieldViewModeAlways;
    
    
    textVeiw.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, textVeiw.frame.size.height)];
    UILabel * rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 20, textVeiw.frame.size.height)];
    rightLabel.text = @"元";
    [textVeiw.rightView addSubview:rightLabel];
    textVeiw.rightView.backgroundColor = [UIColor clearColor];
    textVeiw.rightViewMode =UITextFieldViewModeAlways;
    [textVeiw addTarget:self action:@selector(changeValueTap:) forControlEvents:UIControlEventEditingChanged];
    [countView addSubview:textVeiw];
    
    //提示
    MessageTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, textVeiw.frame.origin.y+textVeiw.frame.size.height+2, countView.frame.size.width-16, 25 )];
    MessageTextLabel.numberOfLines = 2;
    //MessageTextLabel.backgroundColor = [UIColor redColor];
    MessageTextLabel.font = [UIFont systemFontOfSize:12];
    [countView addSubview:MessageTextLabel];
    
    //到期收益
    deadedLine_profileLabel = [[UILabel alloc] initWithFrame:CGRectMake(MessageTextLabel.frame.origin.x, MessageTextLabel.frame.origin.y+MessageTextLabel.frame.size.height+2, MessageTextLabel.frame.size.width, 35)];
   // deadedLine_profileLabel.backgroundColor = [UIColor greenColor];
    deadedLine_profileLabel.text = @"-";
    deadedLine_profileLabel.textAlignment = NSTextAlignmentCenter;
    [countView addSubview:deadedLine_profileLabel];
    //到期收益title
    UILabel *title_deadedLine_profileLabel = [[UILabel alloc] initWithFrame:CGRectMake(MessageTextLabel.frame.origin.x, deadedLine_profileLabel.frame.size.height+deadedLine_profileLabel.frame.origin.y, MessageTextLabel.frame.size.width, 20)];
    title_deadedLine_profileLabel.text = @"到期收益(本息收益/元)";
    title_deadedLine_profileLabel.font = [UIFont systemFontOfSize:12];
    //title_deadedLine_profileLabel.backgroundColor = [UIColor grayColor];
    title_deadedLine_profileLabel.textAlignment = NSTextAlignmentCenter;
    [countView addSubview:title_deadedLine_profileLabel];
    //添加横分割线
    UIImageView *perateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MessageTextLabel.frame.origin.x, title_deadedLine_profileLabel.frame.origin.y+title_deadedLine_profileLabel.frame.size.height+2, MessageTextLabel.frame.size.width, 1)];
    perateImageView.image = [UIImage imageNamed:@"形状-18"];
    [countView addSubview:perateImageView];
    
    //添加利息收入
    totalInterestLabel = [[UILabel alloc] initWithFrame:CGRectMake(MessageTextLabel.frame.origin.x, perateImageView.frame.origin.y + perateImageView.frame.size.height+2, MessageTextLabel.frame.size.width/2.0-1, 35)];
   // totalInterestLabel.backgroundColor = [UIColor orangeColor];
    totalInterestLabel.text = @"-";
    totalInterestLabel.textAlignment = NSTextAlignmentCenter;
    [countView addSubview:totalInterestLabel];
    //添加利息收入标题
    UILabel *title_totalInterestLabel = [[UILabel alloc] initWithFrame:CGRectMake(MessageTextLabel.frame.origin.x, totalInterestLabel.frame.origin.y + totalInterestLabel.frame.size.height, MessageTextLabel.frame.size.width/2.0-1, 20)];
    title_totalInterestLabel.font = [UIFont systemFontOfSize:12];
   // title_totalInterestLabel.backgroundColor = [UIColor redColor];
    title_totalInterestLabel.text = @"利息共收入(元)";
    title_totalInterestLabel.textAlignment = NSTextAlignmentCenter;
    [countView addSubview:title_totalInterestLabel];
//
    //添加竖分割线
    UIImageView *vertiacal_perateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(totalInterestLabel.frame.origin.x+totalInterestLabel.frame.size.width+1, totalInterestLabel.frame.origin.y, 1, 55)];
    vertiacal_perateImageView.image = [UIImage imageNamed:@"形状-1"];
    [countView addSubview:perateImageView];
//
    //添加每月收息
    perMonth_InterestLabel = [[UILabel alloc] initWithFrame:CGRectMake(vertiacal_perateImageView.frame.origin.x+1, vertiacal_perateImageView.frame.origin.y, MessageTextLabel.frame.size.width/2.0-1, 35)];
   // perMonth_InterestLabel.backgroundColor = [UIColor redColor];
    perMonth_InterestLabel.text = @"-";
    perMonth_InterestLabel.textAlignment = NSTextAlignmentCenter;
    [countView addSubview:perMonth_InterestLabel];
//    //添加每月收息标题
    UILabel *title_perMonth_InterestLabel = [[UILabel alloc] initWithFrame:CGRectMake(perMonth_InterestLabel.frame.origin.x, perMonth_InterestLabel.frame.origin.y+perMonth_InterestLabel.frame.size.height, MessageTextLabel.frame.size.width/2.0-1, 20)];
    title_perMonth_InterestLabel.font = [UIFont systemFontOfSize:12];
    title_perMonth_InterestLabel.text = @"平均每月可收息(元)";
   // title_perMonth_InterestLabel.backgroundColor = [UIColor blackColor];
    title_perMonth_InterestLabel.textAlignment = NSTextAlignmentCenter;
    [countView addSubview:title_perMonth_InterestLabel];
    
    
    MessageTextLabel.textColor= [UIColor colorWithRed:1 green:0.45 blue:0 alpha:1];
    perMonth_InterestLabel.textColor = [UIColor colorWithRed:1 green:0.45 blue:0 alpha:1];
    totalInterestLabel.textColor = [UIColor colorWithRed:1 green:0.45 blue:0 alpha:1];
    deadedLine_profileLabel.textColor = [UIColor colorWithRed:1 green:0.45 blue:0 alpha:1];


}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"------");
}

//文本信息变动时触发
- (void)changeValueTap:(UITextField *)textField
{
   
    
    if (textField.text.length<=0) {
        MessageTextLabel.text = @"请输入金额";
        perMonth_InterestLabel.text = @"-";
        totalInterestLabel.text = @"-";
        deadedLine_profileLabel.text = @"-";
        
        MessageTextLabel.textColor= [UIColor colorWithRed:1 green:0.45 blue:0 alpha:1];
        perMonth_InterestLabel.textColor = [UIColor colorWithRed:1 green:0.45 blue:0 alpha:1];
        totalInterestLabel.textColor = [UIColor colorWithRed:1 green:0.45 blue:0 alpha:1];
        deadedLine_profileLabel.textColor = [UIColor colorWithRed:1 green:0.45 blue:0 alpha:1];
        
    }
    {
    if ([textField.text intValue]>=100 && ([textField.text intValue]%100 == 0)) {
        int countMoney = [textField.text intValue];
        //到期收益
        float aRate = _productDetail.interest_rate;
        int aDuration = _productDetail.borrow_duration;
        
        NSString *expireString = [NSString stringWithFormat:@"%.2f",((aRate/100.0)/12.0)*aDuration*countMoney+countMoney];
        //利息共收
        NSString *total_interest = [NSString stringWithFormat:@"%.2f",((aRate/100.0)/12.0)*aDuration*countMoney];
        //每月利息
        
         NSString *per_interest = [NSString stringWithFormat:@"%.2f",[total_interest floatValue]/aDuration];
        
        perMonth_InterestLabel.text = per_interest;
        totalInterestLabel.text = total_interest;
        deadedLine_profileLabel.text = expireString;
        
        MessageTextLabel.text = @"";
    }
   else
   {
        MessageTextLabel.text = @"起投金额不少于100且需是100的倍数";
       perMonth_InterestLabel.text = @"-";
       totalInterestLabel.text = @"-";
       deadedLine_profileLabel.text = @"-";

   }
    }
}

-(void)removeCurrentView
{
    [countView removeFromSuperview];
    [blockModelView removeFromSuperview];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
   

    
   
    if (!animatedImageView && ![self.bidStatus isEqualToString:@"立即投标"]) {
        animatedImageView = [[UIImageView alloc] init];
        animatedImageView.frame = CGRectMake(0, 0, 500, 500);
        animatedImageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, 80);
        animatedImageView.alpha = 1;
        isDoAnimation = YES;
        [self.tableView addSubview:animatedImageView];
        if ([self.bidStatus isEqualToString:@"已完成"]) {
           animatedImageView.image = [UIImage imageNamed:@"已售罄"];
        }
        if ([self.bidStatus isEqualToString:@"还款中"]) {
            animatedImageView.image = [UIImage imageNamed:@"还款中"];//
        }
        if ([self.bidStatus isEqualToString:@"复审中"]) {
            animatedImageView.image = [UIImage imageNamed:@"复审中"];
        }
        if ([self.bidStatus isEqualToString:@"已流标"]) {
            animatedImageView.image = [UIImage imageNamed:@"已流标"];
        }
    }
    if (isDoAnimation ) {
        [UIView animateWithDuration:1.25 animations:^{
        animatedImageView.transform = CGAffineTransformMakeScale(0.25, 0.25);
            
        } completion:^(BOOL finished) {
            isDoAnimation = NO;
        }];

    }
   
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)purchase:(UIButton *)sender
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kUserId"]) {//登陆成功
        
        //购买
        
        //购买之前判断是否已经实名认证
        
        NSString *realNameString =  [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserRealName"];
        if (realNameString && realNameString.length>0) {//认证成功
            purchaseViewController *purchaseVC = [[purchaseViewController alloc] init];
            purchaseVC.borrow_duration = _productDetail.borrow_duration;
            purchaseVC.interest_rate = _productDetail.interest_rate;
            purchaseVC.borrow_max = _productDetail.borrow_max;
            purchaseVC.borrow_min = _productDetail.borrow_min;
            purchaseVC.canBidMoney = _productDetail.can_invest_money;
            purchaseVC.hidesBottomBarWhenPushed  = YES;
            purchaseVC.bid = [NSString stringWithFormat:@"%d",_bidId ];
            [self.navigationController pushViewController:purchaseVC animated:YES];
        }
        else
        {
        //尚未认证
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请去  更多->我的账户->身份认证 中进行汇付认证" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
            [alertView show];
        }
       
    }
    else
    {//尚未登陆
        CLLoginViewController *loginVC = [[CLLoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        loginVC.sucessToProductIntrB = ^{
            //检测是否手势密码打开
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isOpenGesturePassword"] boolValue]== NO ) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录成功是否打开手势密码" message:@"还可以在更多->我的账户中打开" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"打开", nil];
                [alertView show];
            }
            
        };

        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
      [super viewWillAppear:YES];
  
   
//    //添加MBProgressHUD
//    progressHUD = [[MBProgressHUD alloc] init];
//    progressHUD.color = [UIColor grayColor];
//    progressHUD.labelText = @"正在刷新";
//    progressHUD.labelFont = [UIFont systemFontOfSize:13];
//    [self.view addSubview:progressHUD];
//    [progressHUD show:YES];
    [AnimationView showCustomAnimationViewToView:self.view];

      [self  loadData];

}


- (void)loadData
{
      //加载数据源    
    
      //数组
      _array = [NSArray arrayWithObjects:@"产品详情",@"借款人信息",@"抵押物信息",@"资产安全",@"已投资的用户",@"借款协议", nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ProductDetail getProductDetailWithBlock:^(id posts, NSError *error) {
            
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [AnimationView hideCustomAnimationViweFromView:self.view];
            //完成后 下拉刷新
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd  =YES;
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 260/ViewWithDevicHeight, 0);
            //如果请求失败
                        if (error) {
                            DLog(@"%@",posts);
                            
                            if (timeOutLabel) {
                                [timeOutLabel removeFromSuperview];
                            }
                           
                            ALERTVIEW;
            
                        }
                        else
                        {
                            self.productDetail = posts;
                            self.bidStatus = _productDetail.borrow_status;
                            [self time:_productDetail.remained_time];
                            //刷新表视图
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                
                                if (!timer) {
                                    timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(runTime:) userInfo:nil repeats:YES];
                                    NSRunLoop *myrunloop = [NSRunLoop currentRunLoop];
                                    [myrunloop addTimer:timer forMode:NSRunLoopCommonModes];

                                }
                                 [_tableView reloadData];
                                
                            });
                            
                           
                        }

        } withBidId:[NSString stringWithFormat:@"%d",self.bidId]];
        
    });
    
    
    
     
     
      
      
      
}

- (void)runTime:(NSTimer *)atimer
{
   
    
    
      int days    = timeout/24/3600;
      int houre   = (timeout - days*24*3600)/3600;
      int minutes = (timeout - days*24*3600 - houre*3600)/60;
      int seconds = timeout - days*24*3600 - houre*3600 -minutes*60;
      
      
      NSString *daystring = [NSString stringWithFormat:@"%d天",days];
      
      daytimeLabel.font = [UIFont systemFontOfSize:14];
      NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString: daystring];
      //添加属性
      
      //给所有字符设置字体为Zapfino，字体高度为15像素
      [attributedStr01 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:timeIntFontSize] range: NSMakeRange(0,daystring.length-1)];
      //分段控制，颜色设置
      [attributedStr01 addAttribute: NSForegroundColorAttributeName value: [UIColor orangeColor] range: NSMakeRange(0, daystring.length-1)];
      //赋值给显示控件label01的 attributedText
      daytimeLabel.attributedText = attributedStr01;
      daytimeLabel.textAlignment = NSTextAlignmentCenter;
    
    
      
      
      NSString *hourstring = [NSString stringWithFormat:@"%d时",houre];
      
      hourtimeLabel.font = [UIFont systemFontOfSize:14];
      NSMutableAttributedString *attributedStr02 = [[NSMutableAttributedString alloc] initWithString: hourstring];
      //添加属性
      
      //给所有字符设置字体为Zapfino，字体高度为15像素
      [attributedStr02 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:timeIntFontSize] range: NSMakeRange(0,hourstring.length-1)];
      //分段控制，颜色设置
      [attributedStr02 addAttribute: NSForegroundColorAttributeName value: [UIColor orangeColor] range: NSMakeRange(0, hourstring.length-1)];
      //赋值给显示控件label01的 attributedText
      hourtimeLabel.attributedText = attributedStr02;
      hourtimeLabel.textAlignment = NSTextAlignmentCenter;
    
      
      minuteTimeLabel.font = [UIFont systemFontOfSize:14];
      NSString *minutestring = [NSString stringWithFormat:@"%d分",minutes];
  
      NSMutableAttributedString *attributedStr03 = [[NSMutableAttributedString alloc] initWithString: minutestring];
      //添加属性
      
      //给所有字符设置字体为Zapfino，字体高度为15像素
      [attributedStr03 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:timeIntFontSize] range: NSMakeRange(0,minutestring.length-1)];
      //分段控制，颜色设置
      [attributedStr03 addAttribute: NSForegroundColorAttributeName value: [UIColor orangeColor] range: NSMakeRange(0, minutestring.length-1)];
      //赋值给显示控件label01的 attributedText
      minuteTimeLabel.attributedText = attributedStr03;
      minuteTimeLabel.textAlignment = NSTextAlignmentCenter;
      
      NSString *secondsting = [NSString stringWithFormat:@"%d秒",seconds];
      secondTimeLabel.font = [UIFont systemFontOfSize:14 ];
      NSMutableAttributedString *attributedStr04 = [[NSMutableAttributedString alloc] initWithString: secondsting];
      //添加属性
      
      //给所有字符设置字体为Zapfino，字体高度为15像素
      [attributedStr04 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:timeIntFontSize] range: NSMakeRange(0,secondsting.length-1)];
      //分段控制，颜色设置
      [attributedStr04 addAttribute: NSForegroundColorAttributeName value: [UIColor orangeColor] range: NSMakeRange(0, secondsting.length-1)];
      //赋值给显示控件label01的 attributedText
      secondTimeLabel.attributedText = attributedStr04;
      secondTimeLabel.textAlignment = NSTextAlignmentCenter;
    
    
    if (timeout == 0) {
        [atimer invalidate];
    }
    timeout--;
      
    
    
      
      

}



- (void)goBack:(UIButton *)sender
{

      [self.navigationController popViewControllerAnimated:YES];
    [timer isValid];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
      
      return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      
      return _array.count+2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      
      if (indexPath.row == 0) {
            return 202.0;
      }
      else
      {
            
            return anotherCellHeight;
      }
      
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      if (indexPath.row == 0) {
            
            
            
            static NSString *CellIdentifier = @"ProductIntrCell";
            ProductIntrCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
         
            if (cell == nil)
            {
                 cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                  //利用xib创建cell
                  NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ProductIntrCell" owner:nil options:nil];
                  
                  // 目的：是找LPCustomCell对应的 拖拽的cell
                  for (id obj in nibs)
                  {
                        if ([obj isKindOfClass:[ProductIntrCell class]])
                        {
                              cell = (ProductIntrCell *)obj ;
                              
                              break;
                        }
                  }
                  

                 
            }
            
           cell.productDetail = self.productDetail;

                  return cell;
            
            
      }
      
      else      {
            
            
            if (indexPath.row == 1) {
                  static NSString *identifier = @"Timecell";
                  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                  if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                      
                      cell.backgroundColor = UIColorFromRGB(0xf0eff4);
                      cell.selectionStyle = UITableViewCellSelectionStyleNone;
                      _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 70, anotherCellHeight)];
                      _timeLabel.text = @"剩余时间：";
                      _timeLabel.font = [UIFont systemFontOfSize:14];
                      [cell.contentView addSubview:_timeLabel];
                      
                      
                      //剩余时间UI
                      timeView = [[UIView alloc] initWithFrame:CGRectMake(70+12, 0, DeviceSizeWidth-82, anotherCellHeight)];
                    
                      [cell.contentView addSubview:timeView];
                      daytimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, labelWidth-8, anotherCellHeight)];
                      [timeView addSubview:daytimeLabel];
                      hourtimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, 0, labelWidth, anotherCellHeight)];
                      [timeView addSubview:hourtimeLabel];
                      minuteTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth*2, 0, labelWidth, anotherCellHeight)];
                      [timeView addSubview:minuteTimeLabel];
                      secondTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth*3, 0, labelWidth, anotherCellHeight)];
                      [timeView addSubview:secondTimeLabel];
                      
                     
                  }
                //过期的  已经满标的
                if (timeout==0|timeout<0|self.productDetail.ratio==100) {
                    DLog(@"---------");
                    if (timeView) {
                        [timeView removeFromSuperview];
                    }
                    
                    timeOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(100+12, 0, DeviceSizeWidth-200, anotherCellHeight)];
                    timeOutLabel.text = @"投标已经结束";
                    timeOutLabel.font = [UIFont systemFontOfSize:15];
                    timeOutLabel.textAlignment = NSTextAlignmentCenter;
                    timeOutLabel.textColor = [UIColor grayColor];
                    [cell.contentView addSubview:timeOutLabel];
                    
                }
                else{
                    if (timeOutLabel) {
                        [timeOutLabel removeFromSuperview];
                    }
                    [cell.contentView addSubview:timeView];
                }

                    return cell;

                 
            }
            //  点击某一行，去除蓝底
            else{
            static NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceSizeWidth-30/ViewWithDevicWidth, 11, 9, 16)];
                imageView.tag = 1000;
                imageView.image = [UIImage imageNamed:@"13"];
                [cell.contentView addSubview:imageView];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, DeviceSizeWidth-70, 31)];
                label.font = [UIFont systemFontOfSize:14];
                if (_array.count !=0) {
                     label.text = [_array objectAtIndex:indexPath.row-2];
                }               
                label.tag = 1001;
                [cell.contentView addSubview:label];

            }
                
                  cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                  return cell;
            }
      }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      //产品详情：
      if (indexPath.row == 2) {
            ProductDetailViewController *ProductDetailVC = [[ProductDetailViewController alloc] init];
            ProductDetailVC.hidesBottomBarWhenPushed = YES;
          ProductDetailVC.bidId = _bidId;
            [self.navigationController pushViewController:ProductDetailVC animated:YES];

      }
      //借款人信息
      if (indexPath.row == 3) {
            borrowerViewController *borrowerVC = [[borrowerViewController alloc] init];
            borrowerVC.hidesBottomBarWhenPushed = YES;
          borrowerVC.bidId = self.bidId;
            [self.navigationController pushViewController:borrowerVC animated:YES];
      }
      if (indexPath.row == 4) {
            guaranteeViewController *guaranteeVC = [[guaranteeViewController alloc] init];
            guaranteeVC.hidesBottomBarWhenPushed = YES;
          guaranteeVC.bidId = self.bidId;
            [self.navigationController pushViewController:guaranteeVC animated:YES];
      }
      if (indexPath.row == 5) {
            AssertSafeViewController *assertVC = [[AssertSafeViewController alloc] init];
            assertVC.hidesBottomBarWhenPushed = YES;
          assertVC.bidId = self.bidId;
            [self.navigationController pushViewController:assertVC animated:YES];
      }
    if (indexPath.row == 6) {
        BidsRecomendedViewController *bidRecommendedVC = [[BidsRecomendedViewController alloc] init];
        bidRecommendedVC.yearRate = [NSString stringWithFormat:@"%.1f", self.productDetail. interest_rate];
        bidRecommendedVC.bid = [NSString stringWithFormat:@"%d",self.bidId ];
        bidRecommendedVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bidRecommendedVC animated:YES];
    }
    //借款协议
    if (indexPath.row == 7) {
        BidProtocolViewController *bidProtocolVC = [[BidProtocolViewController alloc] init];
        bidProtocolVC.hidesBottomBarWhenPushed = YES;
        bidProtocolVC.bidId = self.bidId;
        [self.navigationController pushViewController:bidProtocolVC animated:YES];
        
    }

}

#pragma mark----------
#pragma mark - PullingRefreshTableViewDelegate
//在pullingTableView触发此代理方法------

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
      //      self.refreshing = YES;
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



- (void)runPercent
{
      _percent= _percent-2;
}

#pragma mark----------
#pragma mark alertviewDelegate-------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        DLog(@"忽略");
        BOOL isOpenGesturePassword = NO;
        [[NSUserDefaults  standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenGesturePassword] forKey:@"isOpenGesturePassword"];
    }
    else
    {        
        
        __block ProductIntrViewController *weakSelf = self;
      //  __block GesturePasswordController *weakgestureVC = _gestureVC;
        _gestureVC.ssForProductInrB = ^{
            //在我的资产设置手势成功后 。。。。
            BOOL isOpenGesturePassword = YES;
            [[NSUserDefaults  standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenGesturePassword] forKey:@"isOpenGesturePassword"];
                [[NSUserDefaults  standardUserDefaults] synchronize];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            DLog(@"设置成功");
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


- (void)dealloc
{
    animatedImageView = nil;
}


@end
