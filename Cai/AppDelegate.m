//
//  AppDelegate.m
//  Cai
//
//  Created by 启竹科技 on 15/4/2.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "AppDelegate.h"
#import "RecommendTableViewController.h"
#import "MoreTableViewController.h"
#import "ProductTableViewController.h"
#import "AssetTableViewController.h"
#import "GesturePasswordController.h"
#import "KeychainItemWrapper.h"
#import "User.h"
#import "Reachability.h"
#import "UMSocial.h"
#import "MobClick.h"
#import "BPush.h"
#import "User.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "ProductIntrViewController.h"
#import "WithDrawViewController.h"
#import "AssetTableViewController.h"
#import "MYFMDB.h"
#import "CailaiAPIClient.h"
#import "AnimationView.h"
#import "AAPLLocalAuthentication.h"
//#import "UMSocialTencentWeiboHandler.h"
@interface AppDelegate ()
{
    UITabBarController *tabBarVC;
    UIImageView* adView;
    NSString * isFirstLoad;
    AssetTableViewController *assetVC;
}
@property (nonatomic,strong) ProductIntrViewController *productIntrVC;
@property (nonatomic,strong) AAPLLocalAuthentication *aapllocalAuthentic;
@property (nonatomic,strong) MYFMDB *db;
@end

@implementation AppDelegate
static BOOL ispresentGVC = NO;//是否在前台
static BOOL fingerPrintPresentVC = NO;//指纹界面是否在前台
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
     //创建一个数据库
    if (!_db) {
        MYFMDB *myFMDB= [[MYFMDB alloc] init];
       [myFMDB creatDateBase];

    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    
    
   //如果客户登录过应用，服务器发送用户的设备类型 3 android 4 ios 手机号 userID
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"KuserID"]) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"channelID"]) {
        }
    };
    
    
    
    // 用NSUserDefaults判断用户是否需要重新登录
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"IsNeedIntroduction"]) {
        NSUserDefaults*  ud=[[NSUserDefaults alloc] init];
        [ud setValue:@"1" forKey:@"IsNeedIntroduction"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"IsNeedIntroduction"];
    }

    
    
    
    //1. 沙河路径（模拟器专用）
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory,NSUserDomainMask, YES);
    NSString *pathStr = [pathArray objectAtIndex:0];
    NSLog(@"沙河路径-----：%@",pathStr);
    
    
    
    
    //2.默认无手势
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isOpenGesturePassword"]) {
        BOOL isOpenGesturePassword = NO;
        [[NSUserDefaults  standardUserDefaults] setObject:[NSNumber numberWithBool:isOpenGesturePassword] forKey:@"isOpenGesturePassword"];
    }
    
    
      
    
    //3.创建手势图
    _gesturePasswordVC = [[GesturePasswordController alloc] init];
    //3.1创建指纹视图
    _aapllocalAuthentic = [[AAPLLocalAuthentication alloc] init];
    
    
    //4.创建tabbar视图
    tabBarVC = [[UITabBarController alloc] init];
    ProductTableViewController *productListVC = [[ProductTableViewController alloc] init];
    productListVC.navigationItem.title = @"产品列表";
    UINavigationController *productNav = [[UINavigationController alloc] initWithRootViewController:productListVC];
    
    RecommendTableViewController *recommendVC = [[RecommendTableViewController alloc] init];
    recommendVC.navigationItem.title = @"精选推荐";
    UINavigationController *recommendNav = [[UINavigationController alloc] initWithRootViewController:recommendVC];
    
    MoreTableViewController *MoreVC = [[MoreTableViewController alloc] initWithStyle:UITableViewStylePlain];
    MoreVC.navigationItem.title = @"更多";
    UINavigationController *MoretNav = [[UINavigationController alloc] initWithRootViewController:MoreVC];
    
    assetVC = [[AssetTableViewController alloc] init];
    assetVC.navigationItem.title = @"我的资产";
    UINavigationController *assetNav = [[UINavigationController  alloc] initWithRootViewController:assetVC];
    
    NSArray *tabBarItemArray = [NSArray arrayWithObjects:recommendNav,  productNav ,assetNav,MoretNav, nil];
      
      
      tabBarVC.viewControllers = tabBarItemArray;
      tabBarVC.selectedIndex = 0;
      tabBarVC.tabBar.backgroundColor = [UIColor whiteColor];
    
    
    
      [[tabBarVC.tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"底栏图标8"] ];
      [[tabBarVC.tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"底栏图标2"] ];
      [[tabBarVC.tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"底栏图标3"] ];
     // [[tabBarVC.tabBar.items objectAtIndex:3] setImage:[UIImage imageNamed:@"menu_map_0@2x"] ];
      [[tabBarVC.tabBar.items objectAtIndex:3] setImage:[UIImage imageNamed:@"底栏图标4"] ];
      
      UITabBarItem *item0 = [tabBarVC.tabBar.items objectAtIndex:0];
      item0.selectedImage = [[UIImage imageNamed:@"底栏图标1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      UITabBarItem *item1 = [tabBarVC.tabBar.items objectAtIndex:1];
      item1.selectedImage = [[UIImage imageNamed:@"底栏图标7"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      UITabBarItem *item2 = [tabBarVC.tabBar.items objectAtIndex:2];
      item2.selectedImage = [[UIImage imageNamed:@"底栏图标6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      UITabBarItem *item3 = [tabBarVC.tabBar.items objectAtIndex:3];
      item3.selectedImage = [[UIImage imageNamed:@"底栏图标5"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      item0.title = @"精选推荐";
      item1.title = @"产品列表";
      item2.title = @"我的资产";
      item3.title = @"更多";
    
    

    self.window.rootViewController = tabBarVC;
    
    //设置高亮字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
    [UIColor grayColor], NSForegroundColorAttributeName,
    nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = NORMALCOLOR;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    
    
//    //判断网络信号
//    Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
//    
//    reach.reachableBlock = ^(Reachability*reach)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            DLog(@"REACHABLE!");
//            
//        });
//    };
//    
//    reach.unreachableBlock = ^(Reachability*reach)
//    {
//        NSLog(@"UNREACHABLE!");
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//             UIViewController *VC = [self getCurrentVC];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"网络异常" delegate:VC cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alertView show];
//            });
//        });
//        
//       
//        
//    };
//    [reach startNotifier];


    
    
    //6 崩溃统计
    //设置友盟appkey
      [UMSocialData setAppKey:@"55a8b23567e58e1a0f0018f7"];
//    [MobClick startWithAppkey:@"55a8b23567e58e1a0f0018f7" reportPolicy:BATCH   channelId:nil];
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];
//    [MobClick setCrashReportEnabled:YES];

    //友盟分享
    //设置友盟社会化组件appkey
    //-----------在崩溃统计中已经设置----------
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxb62466b76562242b" appSecret:@"d888d4f8c55b6c31e3450347f7af0d88" url:@"http://www.cailai.com"];
    
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"1104728408" appKey:@"jc1r7yHEgARAPzyD" url:@"http://www.cailai.com"];
    
    //使用新浪微博原生的SDK
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://www.cailai.com"];
//   使用非原生的sdk
//   [UMSocialSinaHandler openSSOWithRedirectURL:@"http://www.cailai.com"];
//   打开腾讯微博SSO开关，设置回调地址，只支持32位
//   [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
    
    //由于苹果审核政策需求，建议大家对未安装客户端平台进行隐藏
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    
    
    
    //设置通知
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    
    [BPush registerChannel:launchOptions apiKey:@"SfybxQG6wvvQG0GLm1YhzYjn" pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    //获取channelID 并保存
    if (! [[NSUserDefaults standardUserDefaults] objectForKey:@"channelID"]) {
        NSString *channelID =  [BPush getChannelId];
        if (channelID) {
            [[NSUserDefaults standardUserDefaults] setObject:channelID forKey:@"channelID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    NSString *channelID =  [[NSUserDefaults standardUserDefaults] objectForKey:@"channelID"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserId"];
    if (channelID && userID) {
        [User putPropertyWithBlock:^(NSDictionary *posts, NSError *error) {
           
        } withChannelID:channelID withType:@"4" withUserId:userID];
    }

    

    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    
    //设置启动页（类似网易新闻）
    adView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [adView setImage:[UIImage imageNamed:@"640x1136.png"]];
    [self.window addSubview:adView];
    [self.window bringSubviewToFront:adView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeSplashView];
    });
    
    
    
    NSString * version = [self getIOSVersion];
    //当用户打开app的时候 需要验证指纹解锁
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kUserMobile"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"isOpenGesturePassword"] && [version doubleValue] >= 8.0) {
        [self vertifyFingerPrint];
    }
    
    
    
    [self.window makeKeyAndVisible];

      return YES;
}


//接收到远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    DLog(@"--------%@",userInfo);
    if ([userInfo objectForKey:@"borrow_id"]) {
        int bidID = [[userInfo objectForKey:@"borrow_id"] intValue];
        //  由产品列表界面跳到产品界面
        tabBarVC.selectedIndex = 1;
        _productIntrVC = [[ProductIntrViewController alloc] init];
        _productIntrVC.bidId = bidID;
        _productIntrVC.hidesBottomBarWhenPushed = YES;
        UINavigationController *VC = [ tabBarVC.viewControllers objectAtIndex:1];
        [VC pushViewController:_productIntrVC animated:YES];
    }
    else if([userInfo objectForKey:@"member_phone"])
    {
        tabBarVC.selectedIndex = 2;
    }
    completionHandler(UIBackgroundFetchResultNewData);
    
    }


- (NSString *)getIOSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}
// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];//向云推送注册 device token
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
       //取出channelID
        NSString *channelID = [result objectForKey:@"channel_id"];
        [[NSUserDefaults standardUserDefaults] setObject:channelID forKey:@"channelID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    NSLog(@"%@",userInfo);
}



//移除“启动页"
- (void)removeSplashView
{
    [adView removeFromSuperview];
    adView = nil;
}


//获取当前VC
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    
}
 

//  系统回调方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
        //判断是否弹出手势开关  且手势密码为开
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isOpenGesturePassword"] boolValue] == YES ) {
        [self doShowGesturePasswordView];
        }
    
    
}
- (void)vertifyFingerPrint
{

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isOpenFingerprint"] boolValue] == YES) {
        
        __block   AppDelegate *weaDdelegate  = self;
        if (!fingerPrintPresentVC) {
            [self doShowFingerView];
        }
        
        
        _aapllocalAuthentic.evaluateSucessedCallBackB = ^(NSString *msg){
            [weaDdelegate.window.rootViewController dismissViewControllerAnimated:NO completion:^{
            }];
            
        };
        _aapllocalAuthentic.evaluateFailedCallBackB = ^(NSString *msg,NSInteger errorCode)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"指纹验证失败改为手势验证" delegate:weaDdelegate cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alertView.tag = 100;
                [alertView show];
            });
            
        };
        [_aapllocalAuthentic evaluatePolicy];
        
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isOpenGesturePassword"] boolValue] == YES )
    {
        [self doShowGesturePasswordView];
    }


}

- (void)doShowFingerView
{
    [self.window.rootViewController presentViewController:_aapllocalAuthentic animated:NO completion:^{
        
    }];

}

- (void)doShowGesturePasswordView
{
    
    NSString *string  =  [[NSUserDefaults standardUserDefaults] objectForKey:@" kSecAttrAccount"];
    __weak GesturePasswordController *weakGestureC = _gesturePasswordVC;
    __weak AppDelegate *weakSelf = self;
    //如果  手势密码 不存在
    if ([string isEqualToString: @""]) {
        
        DLog(@"-------");
        return;
    }
    else
    {
        //验证手势成功 的回掉
        _gesturePasswordVC.sVBlock = ^{
            
            [weakSelf.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
            [weakGestureC.gesturePasswordView.tentacleView enterArgin];
            ispresentGVC = NO;
        };
        
        //手势 界面不在前台时：
        if (!ispresentGVC) {
            [self.window.rootViewController presentViewController:_gesturePasswordVC animated:YES completion:nil];
            ispresentGVC = YES;
        }
        
        __block   UITabBarController *weakTabbarVC = tabBarVC;
        __block   AppDelegate *weaDdelegate  = self;
        
        _gesturePasswordVC.FPWGBBlock = ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您已退出当前账户请重新登录" delegate:weaDdelegate cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            [weakSelf.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
            [User logout];
            ispresentGVC = NO;
            weakTabbarVC.selectedIndex = 0;//我的资产
        };
        
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   // [self vertifyFingerPrint];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.window.rootViewController dismissViewControllerAnimated:NO completion:^{
        
    }];
    [self doShowGesturePasswordView];

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
//    UIViewController *VC = [self getCurrentVC];
//    for (AnimationView *animationView in VC.view.subviews) {
//        [animationView animationedWithCustomViewOption:UIViewAnimationOptionCurveLinear];
//    }
   
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}



@end
