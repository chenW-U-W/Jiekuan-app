//
//  MoreTableViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/2.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//



#import "MoreTableViewController.h"
#import "UserAccountViewController.h"
#import "LearnUsViewController.h"
#import "CLLoginViewController.h"
#import "CLRegisterViewController.h"
#import "VerificatieViewController.h"
#import "MessageViewController.h"
#import "MBProgressHUD.h"
#import "GesturePasswordViewController.h"
#import "User.h"
#import "UIView+Toast.h"
#import "AnimationView.h"
 NSString *const SharURL = @"https://itunes.apple.com/cn/app/cai-lai-wang-li-cai/id1002974034?l=en&mt=8";
 NSString *const SharText = @"强烈推荐高收益、安全又放心的理财app,精明理财人的首选";

#define numberSection 3

@interface MoreTableViewController ()
{

      NSArray *imageArray;
      NSArray *textArray;
      NSString *shareTitleString;//分享的标题
}
@property(nonatomic,strong)UIButton *existButton;
@end

@implementation MoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    shareTitleString = @"财来网理财";

    self.tableView.tableFooterView = [[UIView alloc] init];
  
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    
    
    
    //添加退出按钮
    _existButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _existButton.frame = CGRectMake(0, 0, 280/ViewWithDevicWidth, 43);
    _existButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height - 140/ViewWithDevicHeight);
    [_existButton setBackgroundColor:NORMALCOLOR];
    _existButton.layer.cornerRadius = 5;
    [_existButton setTitle:@"退出" forState:UIControlStateNormal];
    [_existButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_existButton addTarget:self action:@selector(existClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_existButton];
    _existButton.alpha = 0;
    
    self.navigationController.navigationBar.barTintColor = NORMALCOLOR;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kUserId"])
    {
        _existButton.alpha = 1;
    }
    NSArray *image_myArray = [NSArray arrayWithObjects:@"账户",@"我的消息", nil];
    NSArray *image_caiLaiArray = [NSArray arrayWithObjects:@"了解财来",@"公众号",@"财来客服", nil];
    NSArray *image_functionArray = [NSArray arrayWithObjects:@"版本号",@"分了个享", nil];
    
    
    NSArray *text_myArray = [NSArray arrayWithObjects:@"我的帐户",@"我的消息", nil];
    NSArray *text_caiLaiArray = [NSArray arrayWithObjects:@"了解财来",@"财来公众号",@"财来客服", nil];
    NSArray *text_functionArray = [NSArray arrayWithObjects:@"版本号",@"分享", nil];

    
    
    
    
    imageArray = [NSArray arrayWithObjects:image_myArray,image_caiLaiArray,image_functionArray,nil];//47
    
    textArray = [NSArray arrayWithObjects:text_myArray,text_caiLaiArray,text_functionArray,nil];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return numberSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 3;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 20;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{


      return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
   
      if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 17,15 , 15)];
            imageView.image = [UIImage imageNamed:[[imageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            [cell.contentView addSubview:imageView];
            
            UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(50, 17, 145, 15)];
            label.text = [[textArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
          label.font = [UIFont systemFontOfSize:13];
          
            //label.font = [UIFont boldSystemFontOfSize:15];
            [cell.contentView addSubview:label];
            
            UIImageView * arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-20, 17, 9, 16)] ;
            arrowView.image = [UIImage imageNamed:@"13"];
            [cell.contentView addSubview:arrowView];
      }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            UILabel *telephoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-20-15-120, 17, 120, 13)];
            telephoneLabel.text = @"400-079-8558";
            telephoneLabel.textAlignment = NSTextAlignmentRight;
            telephoneLabel.font = [UIFont systemFontOfSize:14];
            telephoneLabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:telephoneLabel];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 17,15 , 15)];
            imageView.image =[UIImage imageNamed:[[imageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            [cell.contentView addSubview:imageView];
            
            UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(50, 17, 145, 15)];
            label.text = [[textArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            label.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:label];

        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 17,15 , 15)];
            imageView.image = [UIImage imageNamed:[[imageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            [cell.contentView addSubview:imageView];
            
            UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(50, 17, 145, 15)];
            label.text = [[textArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            label.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:label];
            
            UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-20-15-120, 17, 120, 13)];
            versionLabel.text = [NSString stringWithFormat:@"当前版本:V%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
            versionLabel.textAlignment = NSTextAlignmentRight;
            versionLabel.font = [UIFont systemFontOfSize:14];
            versionLabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:versionLabel];
        }
    }
    
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//我的账户
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"kUserId"]) {
                CLLoginViewController *CLLoginVC = [[CLLoginViewController alloc] init];
                CLLoginVC.hidesBottomBarWhenPushed = YES;
                // __block MoreTableViewController *weakself =self;
                CLLoginVC.sucessLB = ^{
                    
                    [self.view makeToast:@"登录成功，手势密码可在我的账户中设置" duration:2 position:[NSValue valueWithCGPoint:CGPointMake(DeviceSizeWidth/2.0,DeviceSizeHeight/2.0-70/ViewWithDevicHeight)] title:@"温馨提示:"];
                    
                };
                [self.navigationController pushViewController:CLLoginVC animated:YES];
                
            }
            else
            {
                UserAccountViewController *userAccountVC = [[UserAccountViewController alloc] init];
                userAccountVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userAccountVC animated:YES];
            }
            
        }
        
        if (indexPath.row == 1) {
            MessageViewController *myMeeageVC = [[MessageViewController alloc] init];
            myMeeageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myMeeageVC animated:YES];
        }


    }
    
    
    if (indexPath.section == 1) {
        //了解我们
        if (indexPath.row == 0) {
            LearnUsViewController *learnUsVC = [[LearnUsViewController alloc] init];
            learnUsVC.hidesBottomBarWhenPushed   = YES;
            [self.navigationController pushViewController:learnUsVC animated:YES];
        }
        //财来公众号
        if (indexPath.row == 1) {
            DLog(@"-------");
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"关注财来公众号:公众号已复制到剪切板,去微信搜索添加马上关注" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.delegate = self;
            alertView.tag = 1003;
            [alertView show];

        }
        if (indexPath.row == 2) {
            //客服电话
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000798558"]];
        }
    }
    
    
                //      if (indexPath.row == 7) {//退出
//          [tableView deselectRowAtIndexPath:indexPath animated:YES];
//          if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kUserId"]) {
//              
//              UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
//              cell.tag = 1000;
//      }
//          
//          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认要退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//          alertView.tag = 1001;
//          [alertView show];
//         
//
//      }
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            //这里的APPkey不要写错欧，要不然除了新浪微博其它的都行就是新浪微博会出现乱码（模拟器）(真机)服务器繁忙
            
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"55a8b23567e58e1a0f0018f7"
                                              shareText:SharText
                                             shareImage:[UIImage imageNamed:@"80.png"]
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToQQ,nil]
                                               delegate:self];
        }

        
    }
       
      

}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    
    if (platformName == UMShareToQQ) {
        //qq
        [UMSocialData defaultData].extConfig.qqData.title = shareTitleString;

    }
    if (platformName == UMShareToQzone) {
        //qq空间
        [UMSocialData defaultData].extConfig.qzoneData.title = shareTitleString;
        
    }
    if (platformName == UMShareToSina) {
        //[UMSocialData defaultData].extConfig.sinaData.title = @"财来网理财";
        
    }
    if (platformName == UMShareToWechatSession) {
        [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitleString;
        
    }
    if (platformName == UMShareToWechatFavorite) {
        [UMSocialData defaultData].extConfig.wechatFavoriteData.title = shareTitleString;
        
    }

    if (platformName == UMShareToWechatTimeline) {
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitleString;
        
    }
    
    [UMSocialData defaultData].extConfig.qqData.url = SharURL;
   


}
//如果点击直接分享内容
//弹出列表方法presentSnsIconSheetView需要设置delegate为self
-(BOOL)isDirectShareInIconActionSheet
{
    return NO;
}

//实现回调方法(可选)
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        if (buttonIndex == 0) {
            
        }
        else
        {
//            UITableViewCell *cell = (UITableViewCell *)[self.view viewWithTag:1000];
//            cell.hidden = YES;
            _existButton.alpha = 0;
            [User logout];
            self.tabBarController.selectedIndex = 0;
        }
    }
    else if (alertView.tag == 1003)
    {
        UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
        [pastboard setString:@"财来网"];//财来公众号
    
    }
}

-(void)existClick
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kUserId"]) {
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认要退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                  alertView.tag = 1001;
        [alertView show];
    }

}


@end
