//
//  MyBidsViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/28.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "MyBidsViewController.h"
#import "InvestObj.h"
#import "UIView+Toast.h"
#import "BindingInvestObj.h"
#import "MBProgressHUD.h"
#import "Binding_buttonView.h"
#import "AllBidObj.h"
#import "InvestObj.h"
#import "AnimationView.h"

@interface MyBidsViewController ()
{
    MBProgressHUD *progressHUD;
}
@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong) NSMutableArray *bindingMutableArray;//投标中数组   名称
@property (nonatomic,strong) NSMutableArray *duein_mutableArray;//待收数组  名称
@property (nonatomic,strong) NSMutableArray *allbid_mutableArray;//全部标的数组
@property (nonatomic,strong) NSString *snameString;//接口名称

@property (nonatomic,assign) NSInteger typeID;

@property (nonatomic,strong) Binding_buttonView *bidButton_view;
//接收的数组
@property (nonatomic,strong) NSMutableArray *totalArray;

@property (nonatomic,strong) NSMutableArray *valueArray;
//@property (nonatomic,strong) NSMutableArray *valueTotalArray;

@end

@implementation MyBidsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    _typeID = 10;
    
    //待收(期)
      self.duein_mutableArray = [NSMutableArray arrayWithObjects:@"项目名称",@"投资金额",@"投资期限",@"年收益率",@"到期回款",@"已收利息",@"投资时间",@"下一期回款时间", nil];
    //投标中(标)
    self.bindingMutableArray = [NSMutableArray arrayWithObjects:@"项目名称",@"借款金额",@"收益率",@"借款期限",@"投资金额",@"到期回款",@"投资时间", nil];
    //全部  已收
    self.allbid_mutableArray = [NSMutableArray arrayWithObjects:@"项目名称",@"投资金额",@"投资期限",@"年收益率",@"到期回款",@"投资时间",@"回款时间",@"回款状态", nil];

    
    self.totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.valueArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.title = @"我的投标";
    //设置背景色
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [self loadDataWithType:_typeID];//全部标

}



-(void)loadDataWithType:(NSInteger)type
{
    [_totalArray removeAllObjects];
    switch (type) {
        case 10:
             //全部
        {
        _typeID = 10;
        _snameString = @"tendall.get";
        }
            break;
        case 11:
            //待收
        {
        _typeID = 11;
        _snameString = @"tendbacking.get";
        }
            break;
        case 12:
            //已收
        {
            _typeID = 12;
             _snameString = @"tendbacked.get";
       
        }
            break;
        case 13:
            //投标中
        {
            _typeID = 13;
           _snameString = @"tending.get";
        }
            break;
            
        default:
            break;
    }
    
        //添加MBProgressHUD
//        progressHUD = [[MBProgressHUD alloc] init];
//        progressHUD.color = [UIColor grayColor];
//        progressHUD.labelText = @"正在刷新";
//        progressHUD.labelFont = [UIFont systemFontOfSize:13];
//        [self.view addSubview:progressHUD];
//        [progressHUD show:YES];
    
    [AnimationView showCustomAnimationViewToView:self.view];
    
        if (_imageView) {
            [self hideImageViewAtCustomView];
            _imageView = nil;
        }
    
    [self loadDataWithSname:_snameString];
    
}


-(void)loadDataWithSname:(NSString *)snameString
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [BindingInvestObj bindingInvestWithBlock:^(id response, NSError *error,NSString *sname) {
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [AnimationView hideCustomAnimationViweFromView:self.view];
            [self loadDataFinish];
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ALERTVIEW;
                    if (!_imageView) {
                        [self showImageViewAtCustomView];
                    }
                    

                });
                
            }
            else if ([response isKindOfClass:[NSMutableArray class]])
            {
                //self.totalArray = response; 为何会执行2次？
                dispatch_async(dispatch_get_main_queue(), ^{
                     self.totalArray = response;
                    if (self.totalArray.count!=0) {
                        [self.tableView reloadData];
                        if (_imageView) {
                            [self hideImageViewAtCustomView];
                        }
                    }
                });
                
                
            }
            else if ([response isKindOfClass:[NSString class]])
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    if (!_imageView) {
                        [self showImageViewAtCustomView];
                    }
                    
                    
                });
                
            }
        } withSname:snameString];
    });
    
    

}



- (void)showImageViewAtCustomView
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 204, 258)];
    _imageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0-40/ViewWithDevicHeight);
    _imageView.image = [UIImage imageNamed:@"60"];
    [self.view addSubview:_imageView];
}

- (void)hideImageViewAtCustomView
{

    [_imageView removeFromSuperview];
    _imageView = nil;
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

    
   
}
-(void)viewDidAppear:(BOOL)animated
{
    
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"Binding_buttonView" owner:nil options:nil];;
    _bidButton_view = [viewArray objectAtIndex:0];
    _bidButton_view.oldTag = 10;
    _bidButton_view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, _bidButton_view.frame.size.height/2.0+5);
    DLog(@"------------%@",NSStringFromCGRect(_bidButton_view.frame));
    [self.view addSubview:_bidButton_view];
    
    
    __block MyBidsViewController *weakSelf  = self;
    _bidButton_view.buttoncliclBlcok = ^(NSInteger tag)
    {
        [weakSelf loadDataWithType:tag];
    };
    

  //  if (_totalArray.count != 0 ) { 在分线程中执行顺序无法确定
    
        if (!_tableView) {
            _tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 20+_bidButton_view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-60) style:UITableViewStyleGrouped];
            _tableView.pullingDelegate = self;
            _tableView.dataSource = self;
            _tableView.delegate = self;
            if (_imageView) {
                [self.view insertSubview:_tableView belowSubview:_imageView];
            }
            else
            {
                [self.view addSubview:_tableView];
            }
            
            
        }
    [super viewDidAppear:YES];
}
    //}
    



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (section == 0) {
        return 1;
    }
    return 30;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _totalArray.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //全部 已收
    if (_typeID == 10 || _typeID == 12) {
        return _allbid_mutableArray.count;
    }
    //待收
    if (_typeID == 11) {
        return _duein_mutableArray.count;
    }
    return _bindingMutableArray.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell11";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
      if (_typeID == 10 || _typeID == 12) {
        if (self.totalArray.count != 0) {
            //全部  已收
            if (_typeID == 10 || _typeID == 12) {
                AllBidObj *allBidObj = [self.totalArray objectAtIndex:indexPath.section];
                self.valueArray = [NSMutableArray arrayWithObjects:allBidObj.borrow_name,[NSString stringWithFormat:@"%@元",allBidObj.investor_capital], [NSString stringWithFormat:@"%@期",allBidObj.borrow_duration],[NSString stringWithFormat:@"%@%%",allBidObj.borrow_interest_rate],[NSString stringWithFormat:@"%@元",allBidObj.overdue],allBidObj.add_time_formator,allBidObj.deadline_formator,allBidObj.statusString, nil];
            }
            
            
            
            if (self.valueArray.count != 0) {
               cell.detailTextLabel.text =  [self.valueArray objectAtIndex:indexPath.row] ;
            }
            cell.textLabel.text = [self.allbid_mutableArray objectAtIndex:indexPath.row];
        }
        
    }
    else if (_typeID == 11)
    {
        //待收
        // self.duein_mutableArray = [NSMutableArray arrayWithObjects:@"项目名称",@"投资金额",@"已还本息",@"收益率",@"总共期限",@"已还期数",@"下一期还款时间", nil];

        
        if (self.totalArray.count != 0) {
            
            InvestObj *invest = [self.totalArray objectAtIndex:indexPath.section];
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
            [dateFormater setDateFormat:@"yyyy-MM-dd"];
            [dateFormater setTimeZone:[NSTimeZone  localTimeZone]];
            NSString *dateString = [dateFormater stringFromDate:invest.next_pay_date];
            self.valueArray =[NSMutableArray arrayWithObjects:invest.bname,[NSString stringWithFormat:@"%.2f元",invest.invest_money],[NSString stringWithFormat:@"%d期",invest.total_periods],[NSString stringWithFormat:@"%.1f%%",invest.borrow_interest_rate], [NSString stringWithFormat:@"%.2lf",invest.returned_money] ,[NSString stringWithFormat:@"%.2f元",invest.repayment_money], invest.tender_date, dateString,nil];
        }
        
        if (self.valueArray.count != 0) {
            cell.detailTextLabel.text =  [self.valueArray objectAtIndex:indexPath.row] ;
        }
        cell.textLabel.text = [self.duein_mutableArray objectAtIndex:indexPath.row];
    }
    else if (_typeID == 13)
        {
            //投标中
            if (self.totalArray.count != 0) {
                
                BindingInvestObj *bindingInvest = [self.totalArray objectAtIndex:indexPath.section];
                
                
                self.valueArray =[NSMutableArray arrayWithObjects:bindingInvest.bidName,[NSString stringWithFormat:@"%.2f元",bindingInvest.borrow_money],[NSString stringWithFormat:@"%.1f%%",bindingInvest.borrow_interest_rate],[NSString stringWithFormat:@"%d期",bindingInvest.borrow_duration],[NSString stringWithFormat:@"%.2f元",bindingInvest.investor_capital],[NSString stringWithFormat:@"%.2f元",bindingInvest.benxi],bindingInvest.add_time,nil];
                
                
                if (self.valueArray.count !=0) {
                    cell.detailTextLabel.text =  [self.valueArray objectAtIndex:indexPath.row] ;
                    
                }
                cell.textLabel.text = [self.bindingMutableArray objectAtIndex:indexPath.row];
                
            }
    

        }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];   
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark----------
#pragma mark - PullingRefreshTableViewDelegate
//在pullingTableView触发此代理方法------

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
  
   [self performSelector:@selector(loadDataWithType:) withObject:nil afterDelay:0.1f];
    
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    //NSDate *date = [df dateFromString:@"2013-11-03 10:10"];
    NSDate *date = [NSDate date];
    
    return date;
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadDataWithType:) withObject:nil afterDelay:0.1f];
}


- (void)loadDataFinish
{
    //请求下来的数据个数<10，则表示请求完数据
   
        self.tableView.reachedTheEnd = YES;
    
       //结束
    [self.tableView tableViewDidFinishedLoading];

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
