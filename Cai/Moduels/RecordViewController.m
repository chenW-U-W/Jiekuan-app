//
//  RecordViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/13.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      CGRect  frame=CGRectMake(0, 0, DeviceSizeWidth, DeviceSizeHeight);
      _tableView = [[PullingRefreshTableView alloc] initWithFrame:frame pullingDelegate:self];
      _tableView.dataSource = self;
      _tableView.delegate = self;
      _tableView.backgroundColor = [UIColor whiteColor];
      [self.view addSubview:_tableView];
      
      //设置背景色为白色
      self.view.backgroundColor = [UIColor whiteColor];
      //设置导航条不是半透明的
      self.navigationController.navigationBar.translucent = NO;
      self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
      self.tableView.tableFooterView = [[UIView alloc] init];

    
}

-(void)viewWillAppear:(BOOL)animated
{
      [super viewWillAppear:YES];
      //加载数据
      [self loadData];
}


-(void)loadData
{

      //加载数据
      
      
      //完成后
//      if (数组数小于总数) {
//            [self.tableView tableViewDidFinishedLoading];
//            self.tableView.reachedTheEnd  =NO;
//      }
//
//      else
//      {
//            [self.tableView tableViewDidFinishedLoading];
//            self.tableView.reachedTheEnd  =YES;
//      
//      }
      


      
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
      
     
      return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      // Return the number of rows in the section.
      if (section == 0) {
            return 1;
      }
      
      return 1;
      
      
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      if (indexPath.section == 0) {
            return 300;
      }
      else
      {
            
            return 40;
      }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      
      if (indexPath.section == 0) {
            //利用xib创建cell
            static NSString *CellIdentifier = @"AssetCell";
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"AssetCell" owner:nil options:nil];
            AssetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            //      目的：是找LPCustomCell对应的 拖拽的cell
            for (id obj in nibs)
            {
                  if ([obj isKindOfClass:[AssetCell class]])
                  {
                        cell = (AssetCell *)obj ;
                        break;
                  }
            }
            cell.userInteractionEnabled = NO;
            return cell;
      }
      else
      {
            
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell  =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                  cell.selectionStyle = UITableViewCellSelectionStyleNone;
                  cell.backgroundColor = [UIColor whiteColor];
            }
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceSizeWidth-30/ViewWithDevicWidth, 11, 10, 23)];
            imageView.image = [UIImage imageNamed:@"13"];
            [cell.contentView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, DeviceSizeWidth-70, 33)];
            label.text = [_mutableArray objectAtIndex:indexPath.row];
            [cell.contentView addSubview:label];
            
            return cell;
      }
      
      
      
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
      if (section == 0) {
            return 0;
      }
      else{
            return 10;
      }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
      
      UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceSizeWidth, 20)];
      view.backgroundColor = [UIColor grayColor];
      return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
      
      return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
      
      UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceSizeWidth, 20)];
      view.backgroundColor = [UIColor grayColor];
      return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      
      
      if (indexPath.row == 0) {
            DLog(@"交易记录");
      }
      if (indexPath.row == 1) {
            DLog(@"累积收益");
      }
      if (indexPath.row == 2) {
            DLog(@"资产总额");
      }
      if (indexPath.row == 3) {
            DLog(@"负债总额");
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
