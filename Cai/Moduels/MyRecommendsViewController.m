//
//  MyBorrowsViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/28.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//



#import "MyRecommendsViewController.h"
#import "Recommender.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "AnimationView.h"
  enum LabelTag{
      nameLabelTag = 100,
      valueLabelTag = 1000
};

@interface MyRecommendsViewController ()
{
    MBProgressHUD *progressHUD;
}
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation MyRecommendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景色
    self.view.backgroundColor = BACKGROUND_COLOR;
      _mutableArray = [NSMutableArray arrayWithObjects:@"姓名",@"注册时间",@"贡献奖金",@"电话号码", nil];
    _valueArray = [NSMutableArray arrayWithCapacity:0];
    
      
      self.title = @"我的推荐";
      UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
      [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
      [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
      UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
      self.navigationItem.leftBarButtonItem = leftItem;
    
    
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(void)viewDidAppear:(BOOL)animated
{
    
        _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.pullingDelegate = self;
        [self.view addSubview:_tableView];
    
    [self loadData];
    [super viewDidAppear:YES];
}

- (void)loadData
{
    
    [AnimationView showCustomAnimationViewToView:self.view];

dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    [Recommender recommenderWithBlock:^(id response, NSError *error) {
       // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [AnimationView hideCustomAnimationViweFromView:self.view];
        if (error) {
            DLog(@"%@",error);
            if (error) {
                ALERTVIEW;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView tableViewDidFinishedLoading];
                self.tableView.reachedTheEnd =YES;
            });
                   }
        else
        {
            self.totalArray = response;
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (self.totalArray.count!=0) {
                    [self.tableView reloadData];
                }
                if (self.totalArray.count == 0) {
                    
                    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 204, 258)];
                    _imageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0-40/ViewWithDevicHeight);
                    _imageView.image = [UIImage imageNamed:@"60"];
                    [self.view addSubview:_imageView];
                    
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getFinishedLoad];

                });
                
            });
        }

    }];

});
   
}
- (void)getFinishedLoad
{

    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd =YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

      return [_mutableArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

      return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

      static NSString *identifier = @"cell";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
      if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
      }
    if (_totalArray.count!=0) {
        
        Recommender *recommender = [self.totalArray objectAtIndex:indexPath.section];
//        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
//        [dateFormater setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//        [dateFormater setTimeZone:[NSTimeZone  localTimeZone]];
//
//        NSString *dateString = [dateFormater stringFromDate:recommender.reg_date];
        self.valueArray =[NSMutableArray arrayWithObjects:recommender.real_name,recommender.reg_date,[NSString stringWithFormat:@"%.2f",recommender.bonus],recommender.mobile,nil];
        
        cell.textLabel.text = [_mutableArray  objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [_valueArray objectAtIndex:indexPath.row] ;
        
        cell.textLabel.font = ConstFont;
        cell.detailTextLabel.font = ConstFont;
    }
   
   
      return cell;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

      return [_totalArray count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack:(id)sender
{
      [self.navigationController popViewControllerAnimated:YES];

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
