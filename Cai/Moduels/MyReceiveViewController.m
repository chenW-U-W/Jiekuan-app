//
//  MyReceiveViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/7/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "MyReceiveViewController.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "MyReceiveObj.h"
#import "AnimationView.h"
@interface MyReceiveViewController ()
{
MBProgressHUD *progressHUD;
 
}
@property(nonatomic,strong)NSMutableArray *mutableArray;
@property(nonatomic,strong)NSMutableArray *valueArray;
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation MyReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景色
    self.view.backgroundColor = BACKGROUND_COLOR;
    _mutableArray = [NSMutableArray arrayWithObjects:@"项目名称",@"借款人姓名",@"应收本金",@"应收利息",@"应还日期",nil];
    _valueArray = [NSMutableArray arrayWithCapacity:0];
    
    
    self.title = @"本月收款";
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
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
    [self loadData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    if (_valueArray.count != 0) {
        _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.pullingDelegate = self;
        [self.view addSubview:_tableView];
        
    }else
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 204, 258)];
        _imageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0-40/ViewWithDevicHeight);
        _imageView.image = [UIImage imageNamed:@"60"];
        [self.view addSubview:_imageView];
        
    }
    [super viewDidAppear:YES];
}

- (void)loadData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [MyReceiveObj myReceiveWithBlcok:^(NSMutableArray *mutableArray, NSError *error) {
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
                self.valueArray = mutableArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (self.valueArray.count!=0) {
                        [self.tableView reloadData];
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
    if (_valueArray.count!=0) {
        
        MyReceiveObj *myReceiveObj = [self.valueArray objectAtIndex:indexPath.section];
        
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        [dateFormater setTimeZone:[NSTimeZone  localTimeZone]];
        NSString *dateString = [dateFormater stringFromDate:myReceiveObj.deadline];
        //DLog(@"%@",dateString);
        
        NSMutableArray * totalArray =[NSMutableArray arrayWithObjects:myReceiveObj.projiectName , myReceiveObj.borrowerName , [NSString stringWithFormat:@"%.2f元", myReceiveObj.capital ],[NSString stringWithFormat:@"%.2f元", myReceiveObj.interest] ,dateString , nil];
        
        cell.textLabel.text = [_mutableArray  objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [totalArray objectAtIndex:indexPath.row] ;
    }
    
    
    return cell;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [_valueArray count];
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
