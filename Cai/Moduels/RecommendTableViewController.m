//
//  RecommendTableViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/2.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "RecommendTableViewController.h"
#import "EYCarouselImageView.h"
#import "ParticularCell.h"
#import "UIImageView+WebCache.h"
#import "ProductIntrViewController.h"
#import "purchaseViewController.h"
#import "UIImageView+WebCache.h"
#import "Banner.h"
#import "CLLoginViewController.h"
#import "RecommendedObj.h"
#import "ActivityViewController.h"
#import "Introduce.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "CailaiAPIClient.h"
#import "AnimationView.h"
#define kHeightCycleScroll 128.0/ViewWithDevicHeight

@interface RecommendTableViewController ()
{
    MBProgressHUD *progressHUD ;
}
@property (strong,nonatomic) NSArray *bannerArray;
@property (nonatomic,strong) AnimationView *animationView ;
@property (nonatomic,strong) NSError *bannerError;
@property (nonatomic,strong) NSError *contentError;
@end

@implementation RecommendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bannerArray = [[NSArray alloc] init];
    
      //1 判断用户是否注册登录
      BOOL isLogin = YES;
      if (!isLogin) {
            CLLoginViewController *CLLoginVC = [[CLLoginViewController alloc] init];
            [self.navigationController pushViewController:CLLoginVC animated:YES];
      }
    
 
      CGRect  frame=CGRectMake(0, 0, DeviceSizeWidth, DeviceSizeHeight-44-49);
      _tableView = [[PullingRefreshTableView alloc] initWithFrame:frame pullingDelegate:self];
      _tableView.dataSource = self;
      _tableView.delegate = self;
      _tableView.backgroundColor = NORMALCOLOR;
     // _tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
      [self.view addSubview:_tableView];
      
      //设置背景色
      self.view.backgroundColor = BACKGROUND_COLOR;
      //设置导航条不是半透明的
      self.navigationController.navigationBar.translucent = NO;
    
      self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
      
      self.tableView.tableFooterView = [[UIView alloc] init];
      self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      
      //添加购买的通知
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseFn:) name:@"purchase" object:nil];    
    
    
    NSUserDefaults*  ud=[[NSUserDefaults alloc] init];
    NSString*  introductionCount=[ud objectForKey:@"IsNeedIntroduction"];
    int iIntroductionCount=[introductionCount intValue];
    //判断用户是否打开过应用（未打开过为1  打开过为0）    是否显示引导页
    if (iIntroductionCount==1) {
        [ud setValue:@"0" forKey:@"IsNeedIntroduction"];
        //设置引导页
        CGRect frame = [UIScreen mainScreen].bounds;
        Introduce *introduce = [[Introduce alloc] initWithFrame:frame];
        //NSLog(@"----%@",NSStringFromCGRect(introduce.frame));
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:introduce];
    }
   
    [self checkVersions];
    
    
    [self  loadData];
}


-(void)checkVersions
{
    //app版本检测
    [self checkVersionsWithBlock:^(id post, NSError *error) {
        if (!error) {
            NSString* versionString = post;
            
            NSString *localVersion = [NSString stringWithFormat:@"V%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
            DLog(@"%@",localVersion);
           
            
            if([versionString compare:localVersion] == NSOrderedDescending)//服务器版本  > 本地版本都会提示升级，< 本地版本不会提示   ----[versionString compare:localVersion] == NSOrderedSame || 
            {
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                imageView.image = [UIImage imageNamed:@"启动页750"];
                [[UIApplication sharedApplication].keyWindow addSubview:imageView];

                
                UIAlertView *aAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"新版本已发布,请升级" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                aAlertView.tag = 20000;
                [aAlertView show];
                
                
            }
        }
        
        
    }];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 20000) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/cai-lai-wang-li-cai/id1002974034?l=en&mt=8"]];

    }
}





     
-(void)checkVersionsWithBlock:(void(^)(id post,NSError *error))block
{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"app.latest.version.get", @"sname",             nil];
    [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        
        if (block) {
            block([JSON valueForKey:@"data"] , nil);
        }
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];
}




//跳转到 产品介绍
- (void)purchaseFn:(NSNotification *)notification
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}


- (void)loadData
{
    [AnimationView showCustomAnimationViewToView:self.view];
    
    //请求滚动栏图片
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [Banner bannerViewWithBlock:^(id response, NSError *error) {
            if (!error) {
                _bannerArray = response;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
                
            }
            
        }];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [RecommendedObj recommendedWithBlock:^(id response, NSError *error) {
            [AnimationView hideCustomAnimationViweFromView:self.view];
            self.view.userInteractionEnabled = YES;
            //如果请求失败
           if (error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    DLog(@"%@",error);
                    
                    ALERTVIEW;
                   
                });

            }          
            
            else
            {
                self.recomendedObj = response;
                //刷新表视图
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];                    
                });

            }
            //完成后
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd  =YES;
        }];
        
        
    });
    
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

      if (indexPath.row == 0) {
            return 128.0/ViewWithDevicHeight;
      }
      else
      {
      
           return (376.0)/ViewWithDevicHeight;
      }
      
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      if (indexPath.row == 0) {
            static NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
                            }
         
          
          
          //加载轮播图
          EYCarouselImageView* cyclicScroll = [[EYCarouselImageView alloc]initWithFrame:(CGRect){0,0,DeviceSizeWidth,kHeightCycleScroll} animationDuration:2.7];
          
          NSMutableArray *imageViewArr = [[NSMutableArray alloc]init];
          
          
          // 无网络图片的时候加载的本地图片
          //                  NSArray *imgNameArr = @[@"HomePageCarous0",@"HomePageCarous1",@"HomePageCarous2"];
          //                  for (int i = 0; i < imgNameArr.count; i++) {
          //                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:(CGRect){0,0,[UIScreen mainScreen].bounds.size.width,kHeightCycleScroll}];
          //                        imageView.image = [UIImage imageNamed:imgNameArr[i]];
          //                        imageView.tag = 1000+i;
          //                        [imageViewArr addObject:imageView];
          //                        imageView.contentMode = UIViewContentModeScaleAspectFill;
          //                  }
          int i = 0;
          for (Banner *bannerObj in _bannerArray) {
              DLog(@"%ld----------",_bannerArray.count);
              UIImageView *imageView = [[UIImageView alloc]initWithFrame:(CGRect){0,0,[UIScreen mainScreen].bounds.size.width,kHeightCycleScroll}];
              [imageView setImageWithURL:[NSURL URLWithString:bannerObj.pic_url]];
              imageView.tag = 1000+i;
              [imageViewArr addObject:imageView];
              imageView.contentMode = UIViewContentModeScaleAspectFill;
          }
          
          
          
          cyclicScroll.EasyBlockGetContentArr = ^(void){
              return imageViewArr;
          };
          
          
          cyclicScroll.EasyBlockRevokeClickedView = ^(UIView *view){
              DLog(@"------clicked :%ld",(long)view.tag);
              Banner *banner =  [_bannerArray objectAtIndex:view.tag-1000];
              NSString *linkString = banner.link;
              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkString]];
          };
          [cell.contentView addSubview:cyclicScroll];
          
          //添加pagecontroll
          UIPageControl *pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 128.0/ViewWithDevicHeight-30, [UIScreen mainScreen].bounds.size.width, 30)];
          pageControll.numberOfPages = _bannerArray.count;
          pageControll.currentPage = 0;
          pageControll.backgroundColor = [UIColor clearColor];
          [cell.contentView addSubview:pageControll];
         
          
          cyclicScroll.EasyBlockRevokeShowView = ^(UIView *view,NSUInteger idx){
              pageControll.currentPage = idx;
          };

            return cell;
          
          
      }
      else{
          
            static NSString *CellIdentifier = @"ParticularCell";
            ParticularCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                  cell = [[ParticularCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
         
            //  点击某一行，去除蓝底
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
          cell.recommendObj = self.recomendedObj;
          
            return cell;
      }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      if (indexPath.row == 1) {
            //进入产品介绍界面
            ProductIntrViewController *productIntr = [[ProductIntrViewController alloc] init];
            productIntr.hidesBottomBarWhenPushed = YES;
          productIntr.bidId = _recomendedObj.bid;
          productIntr.titleString = _recomendedObj.bname;
          productIntr.returnedCallBB = ^{
              [self loadData];
          };
          [self.navigationController pushViewController:productIntr animated:YES];
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

@end
