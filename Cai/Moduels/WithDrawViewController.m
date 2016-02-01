//
//  WithDrawViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/15.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "WithDrawViewController.h"
#import "WithDrawDetailCell.h"
#import "TransactionObj.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "AnimationView.h"

@interface WithDrawViewController ()
{
    MBProgressHUD *progressHUD;
      NSArray *rowsNumArray;
      int page;
    
}
@property(nonatomic,strong)UIImageView *imageView;
@property (readwrite, nonatomic, strong) NSMutableArray *productsArray;
@property (nonatomic,assign)BOOL isRefresh;

@end

@implementation WithDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
      self.navigationItem.title = @"交易记录";
      UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
      [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
      [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
      UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
      self.navigationItem.leftBarButtonItem = leftItem;
    
      
      //设置背景色
      self.view.backgroundColor = BACKGROUND_COLOR;
      //设置导航条不是半透明的
      self.navigationController.navigationBar.translucent = NO;
    

      _productsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
}


- (void)goBack:(id)sender
{

      [self.navigationController popToRootViewControllerAnimated:YES];
      
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
    if (self.isRefresh) {
        page = 1;
        [_productsArray removeAllObjects];
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [TransactionObj transactionWithBlock:^(id response,NSArray *array, NSError *error) {
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [AnimationView hideCustomAnimationViweFromView:self.view];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView tableViewDidFinishedLoading];
                self.tableView.reachedTheEnd  = YES;
            });
            if (error) {
                DLog(@"%@",error);
                //完成后
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      if (error) {
                          ALERTVIEW;
                      }
               
                  });

            }
            else
            {
                NSArray *post = (NSArray *)response;
                [_productsArray addObjectsFromArray:post];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                    //完成后
                   [self loadDataFinish];
                });
            }
        } withPageSize:@"15" withPageNum:[NSString stringWithFormat:@"%d",page]];
 
    });
    
    
    


}

-(void)loadDataFinish
{
    
    if (_productsArray.count!=0) {
        if (!_tableView) {
            CGRect  frame=CGRectMake(0, 0, DeviceSizeWidth, DeviceSizeHeight-64);
            _tableView = [[PullingRefreshTableView alloc] initWithFrame:frame pullingDelegate:self];
            _tableView.dataSource = self;
            _tableView.delegate = self;
            _tableView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_tableView];
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.tableView.tableFooterView = [[UIView alloc] init];
        }
    }    

    else if (_productsArray.count == 0) {
        if (!_imageView) {
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 204, 258)];
            _imageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0-40/ViewWithDevicHeight);
            _imageView.image = [UIImage imageNamed:@"60"];
            [self.view addSubview:_imageView];
            
        }
    }
    
    
    //请求下来的数据个数<10，则表示请求完数据
    if (self.productsArray.count < 10) {
        self.tableView.reachedTheEnd = YES;
    }
    else
    {
        self.tableView.reachedTheEnd = NO;
    }
    //结束
    [self.tableView tableViewDidFinishedLoading];
    
}


#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_productsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      
       static NSString *CellIdentifier = @"WithDrawDetailCell";
      WithDrawDetailCell *drawCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
      if (!drawCell) {
            //利用xib创建cell
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"WithDrawDetailCell" owner:nil options:nil];
            
            //      目的：是找LPCustomCell对应的 拖拽的cell
            for (id obj in nibs)
            {
                  if ([obj isKindOfClass:[WithDrawDetailCell class]])
                  {
                        drawCell = (WithDrawDetailCell *)obj ;
                        break;
                  }
            }
            
      }
    if (_productsArray.count>0) {
        drawCell.recordProduct = [_productsArray objectAtIndex:indexPath.row];

    }
    
       drawCell.selectionStyle = UITableViewCellSelectionStyleNone;
     return drawCell;
}







#pragma mark----------
#pragma mark - PullingRefreshTableViewDelegate
//在pullingTableView触发此代理方法------

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    
      [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1f];
    self.isRefresh = YES;
    DLog(@"%@",NSStringFromCGRect(_tableView.frame) );
    _tableView.frame = CGRectMake(0, 0, DeviceSizeWidth, DeviceSizeHeight-104);//不太明白为啥_tabView的最后一个单元格会被tabbar挡住
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
      NSDateFormatter *df = [[NSDateFormatter alloc] init ];
      df.dateFormat = @"yyyy-MM-dd HH:mm";
      //NSDate *date = [df dateFromString:@"2013-11-03 10:10"];
      NSDate *date = [NSDate date];
      
      return date;
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.isRefresh = NO;
    page++;
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
