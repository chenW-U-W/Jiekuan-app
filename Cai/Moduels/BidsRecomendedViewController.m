//
//  BidsRecomendedViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/5/20.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "BidsRecomendedViewController.h"
#import "BidRecommendedObj.h"
#import "BidRecommendedCell.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "AnimationView.h"
@interface BidsRecomendedViewController ()
{
    MBProgressHUD *progressHUD;
}
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation BidsRecomendedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (!_tableView) {
        CGRect  frame=CGRectMake(0, 0, DeviceSizeWidth, DeviceSizeHeight-64);
        _tableView = [[PullingRefreshTableView alloc] initWithFrame:frame pullingDelegate:self];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_tableView];
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
    self.navigationItem.title = @"已投资的用户";
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    //设置背景色
    self.view.backgroundColor = BACKGROUND_COLOR;
    //设置导航条不是半透明的
    self.navigationController.navigationBar.translucent = NO;
    
    
    _totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    
}


- (void)goBack:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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

- (void)loadData
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [BidRecommendedObj BidRecommendedWithBlock:^(id response, NSError *error) {
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [AnimationView hideCustomAnimationViweFromView:self.view];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView tableViewDidFinishedLoading];
                self.tableView.reachedTheEnd  = YES;
                
            });
            if (error) {
                DLog(@"%@",error);
                //完成后
                ALERTVIEW;
            }
            else
            {
                _totalArray= response;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_totalArray.count!=0) {
                        [_tableView reloadData];

                    }
                    else
                    {
                        if (!_imageView) {
                            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 204, 258)];
                            _imageView.image = [UIImage imageNamed:@"60"];
                            _imageView.center = self.view.center;
                            [self.view addSubview:_imageView];
                            
                        }
                        
                    }

                    
                });
            }

        } withBid:self.bid];
        
    });
    
    
    
    
    
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_totalArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BidRecommendCell";
    BidRecommendedCell *bidRecommendedCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (!bidRecommendedCell) {
        //利用xib创建cell
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"BidRecommendedCell" owner:nil options:nil];
        
        
        //      目的：是找LPCustomCell对应的 拖拽的cell
        for (id obj in nibs)
        {
            if ([obj isKindOfClass:[BidRecommendedCell class]])
            {
                bidRecommendedCell = (BidRecommendedCell *)obj ;
                bidRecommendedCell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            }
        }
       
    }
    
    bidRecommendedCell.bidRecommendObj = [_totalArray objectAtIndex:indexPath.row];
    bidRecommendedCell.yaerRateLabel.text =[NSString stringWithFormat:@"收益率:%@%%",self.yearRate ];
    return bidRecommendedCell;
    
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
