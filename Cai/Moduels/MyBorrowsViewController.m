//
//  MyRecommendsViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/28.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "MyBorrowsViewController.h"
#import "UIView+Toast.h"
#import "MyBorrow.h"
enum LabelTag{
      nameLabelTag = 100,
      valueLabelTag = 1000
};


@interface MyBorrowsViewController ()
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation MyBorrowsViewController

- (void)viewDidLoad {
      [super viewDidLoad];
    
      _mutableArray = [NSMutableArray arrayWithObjects:@"项目名称",@"还款方式",@"借款金额",@"已还金额",@"收益率",@"总共期限",@"已还期数",@"下一期还款时间", nil];
    _valueArray = [NSMutableArray arrayWithCapacity:0];
      
      self.title = @"我的借款";
      UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
      [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
      [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
      UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
      self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    //设置背景色
    self.view.backgroundColor = BACKGROUND_COLOR;
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];
    [self loadData];
    //[_tableView launchRefreshing];
}
-(void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:YES];
    if (_totalArray.count != 0) {
        if (!_tableView) {
            _tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
            _tableView.pullingDelegate = self;
            _tableView.dataSource = self;
            _tableView.delegate = self;
            [self.view addSubview:_tableView];
        }

    }
    else
    {
        if (!_imageView) {
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 204, 258)];
            _imageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0-40/ViewWithDevicHeight);
            _imageView.image = [UIImage imageNamed:@"60"];
            [self.view addSubview:_imageView];
        }
        
    }
}

-(void)loadData
{
   dispatch_async(dispatch_get_global_queue(0, 0), ^{
       [MyBorrow MyBorrowWithBlock:^(id response, NSError *error) {
           if (error) {
               DLog(@"%@",error);
               dispatch_async(dispatch_get_main_queue(), ^{
                   
                   if (error.code == -1009) {
                       [self.view makeToast:@"您的网络状态异常" duration:5.0 position:@"top"];
                   }
                   else
                   {
                       [self.view makeToast:error.domain duration:5.0 position:@"top"];
                   }

                   [self.tableView tableViewDidFinishedLoading];
                   self.tableView.reachedTheEnd = YES;
                                  });

           }
           else
           {
              self.totalArray = response;
               dispatch_async(dispatch_get_main_queue(), ^{
                   [self.tableView tableViewDidFinishedLoading];
                   self.tableView.reachedTheEnd = YES;
                   if (self.totalArray.count!=0) {
                       
                       [self.tableView reloadData];
                       
                   }

               });
           }
       }];
   });
   
    

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
    if (self.totalArray.count!= 0) {
        MyBorrow *borrow = [self.totalArray objectAtIndex:indexPath.section];

         self.valueArray =[NSMutableArray arrayWithObjects:borrow.bname,borrow.repayment_type,[NSString stringWithFormat:@"%.2f元",borrow.borrow_money],[NSString stringWithFormat:@"%.2f元",borrow.repayment_money],[NSString stringWithFormat:@"%.2f%%",borrow.borrow_interest_rate],[NSString stringWithFormat:@"%d期",borrow.total_periods],[NSString stringWithFormat:@"%d期",borrow.payed_periods],borrow.next_pay_date,nil];

        cell.textLabel.text = [_mutableArray  objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [_valueArray objectAtIndex:indexPath.row] ;
    }
    
      return cell;
      
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
      
      return [self.totalArray count];
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
