
//
//  MyReturnedMoneyTableViewController.m
//  Cai
//
//  Created by csj on 15/8/18.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "MyReturnedMoneyTableViewController.h"
#import "CustomCalendarViewController.h"
#import "MessageTableViewController.h"
#import "MyReceiveObj.h"
#import "TimeObj.h"
@interface MyReturnedMoneyTableViewController ()
{
    float shouldReturnedMoney;
    float returnedMoney ;
}

@property(nonatomic,strong)NSMutableArray *dateMutableArray;
@property(nonatomic,strong) UIView *mont_releatedView;

@end

@implementation MyReturnedMoneyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"还款日历";
    
    self.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;

    //加载monthReleatedView
    shouldReturnedMoney = 0;
    returnedMoney = 0;
    
    [self creatMonth_releatedView];

    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    //加载日历VC 和 列表VC
    _customCalendarVC = [[CustomCalendarViewController alloc] init];
    __block MyReturnedMoneyTableViewController *weakself = self;
    _customCalendarVC.month_releatedBlock = ^(NSMutableArray *month_releatedArray){
        [weakself setMont_releatedTotalArray:month_releatedArray];
    };
    [self.tableView addSubview:_customCalendarVC.view];
    
    _messageTVC = [[MessageTableViewController alloc] initWithStyle:UITableViewStylePlain];
    __block  MyReturnedMoneyTableViewController *weakSelf = self;
    _messageTVC.notifyBlock=^(NSUInteger num){
    //刷新试图  [UIScreen mainScreen].bounds.size.height+
        CGFloat bottomSize = (num +1)*(CellSize+30)+150;
        weakSelf.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottomSize, 0);
    };
    [self.tableView addSubview:_messageTVC.view];
    
    _customCalendarVC.messageTVC = self.messageTVC;//强行建立关系
    
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)creatMonth_releatedView
{    
    _mont_releatedView = [[UIView alloc] initWithFrame:CGRectMake(0, 310/ViewWithDevicHeight, [UIScreen mainScreen].bounds.size.width, CellSize)];
    _mont_releatedView.backgroundColor = [UIColor whiteColor];
    UILabel *shouldHuiKuanTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, [UIScreen mainScreen].bounds.size.width/2.0, 20)];
    shouldHuiKuanTitle.textAlignment = NSTextAlignmentCenter;
    shouldHuiKuanTitle.text = @"本月应回款(元)";
    shouldHuiKuanTitle.font = [UIFont systemFontOfSize:13];
    [_mont_releatedView addSubview:shouldHuiKuanTitle];
    
    UILabel *shouldHuiKuan = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width/2.0, CellSize-20)];
    shouldHuiKuan.tag = 10001;
    shouldHuiKuan.textAlignment = NSTextAlignmentCenter;
    shouldHuiKuan.font = [UIFont systemFontOfSize:20];
    shouldHuiKuan.textColor = [UIColor colorWithRed:1.000 green:0.451 blue:0.000 alpha:1];
    [_mont_releatedView addSubview:shouldHuiKuan];
    
    UIImageView *verticalImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2.0, 2, 1, CellSize-4)];
    [_mont_releatedView addSubview:verticalImageView];
    verticalImageView.image = [UIImage imageNamed:@"形状-18"];
    
    UILabel *huiKuanTitle = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2.0+1, 2, [UIScreen mainScreen].bounds.size.width/2.0-1, 20)];
    huiKuanTitle.textAlignment = NSTextAlignmentCenter;
    huiKuanTitle.text = @"已回款(元)";
    huiKuanTitle.font = [UIFont systemFontOfSize:13];
    [_mont_releatedView addSubview:huiKuanTitle];
    
    
    UILabel *huiKuan = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2.0+1, 20, [UIScreen mainScreen].bounds.size.width/2.0-1,CellSize-20)];
    huiKuan.textAlignment = NSTextAlignmentCenter;
    huiKuan.tag = 10002;
    huiKuan.textColor = [UIColor colorWithRed:1.000 green:0.451 blue:0.000 alpha:1];
    huiKuan.font = [UIFont systemFontOfSize:20];
    [_mont_releatedView addSubview:huiKuan];
    [self.view addSubview:_mont_releatedView];        
    
}

- (void)setMonthReleatedViewWithShouldReturnedString:(NSString *)shouldString withReturnedString:(NSString *)returnedString
{
    
    UILabel *shouldHuiKuan = (UILabel *)[_mont_releatedView viewWithTag:10001];
    shouldHuiKuan.text = shouldString;
    shouldReturnedMoney = 0;
    
    UILabel *huiKuan = (UILabel *)[_mont_releatedView viewWithTag:10002];
    huiKuan.text =  returnedString;
    returnedMoney = 0;
}

-(void)setMont_releatedTotalArray:(NSMutableArray *)monthReleatedArray
{
    for (MyReceiveObj *myreceiveOBJ in monthReleatedArray) {
        //header的日期
        NSString *repaymentDateTimeString =[TimeObj  stringFromReceivedDate:myreceiveOBJ.repayment_time withDateFormat:@"yyyy-MM-dd"];
        [_dateMutableArray addObject:repaymentDateTimeString];
        
        // 应回款加本金
        shouldReturnedMoney += (myreceiveOBJ.interest + myreceiveOBJ.capital);
        
        //已回款
        
        //当前日期大于本月截至日期
        if (myreceiveOBJ.repayment_timeInt != 0) {
            returnedMoney += (myreceiveOBJ.interest + myreceiveOBJ.capital);
        }
        
    }
    
    self.shouldReturnedMoneyString = [NSString stringWithFormat:@"%.2f", shouldReturnedMoney];
    self.returnedMoneyString = [NSString stringWithFormat:@"%.2f", returnedMoney];
    [self setMonthReleatedViewWithShouldReturnedString:self.shouldReturnedMoneyString withReturnedString:self.returnedMoneyString];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

- (void)goBack:(id)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//空白的tableview
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *CellIdentifier = @"Cell";
     UITableViewCell *cell  =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }    return cell;
}



@end
