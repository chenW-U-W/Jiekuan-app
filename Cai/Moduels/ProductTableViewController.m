//
//  ProductTableViewController.m
//  Cai
//
//  Created by Cameron Ling on 15/4/2.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "ProductTableViewController.h"
#import "ProductCell.h"
#import "Product.h"
#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "ProductIntrViewController.h"
#import "Product.h"
#import "MBProgressHUD.h"
#import "Product_assignTableViewController.h"
#import "Product_assignTableViewCell.h"
#import "Product_assign.h"
#import "AnimationView.h"


@interface ProductTableViewController ()
{
    MBProgressHUD *progressHUD;
    int page;
    UIButton *productTab;
    UIButton *assignmentTab;
    UIImageView *TapView;
    NSString *type;
}
//产品列表
@property (readwrite, nonatomic, strong) NSMutableArray *productsArray;
//转让区
@property (nonatomic,strong)NSMutableArray *assignmentArray;
@property (nonatomic,strong)NSString *portString;
@property (nonatomic,strong) Product_assign *product_assign;

@end

@implementation ProductTableViewController



- (void)loadDataWithType:(NSString *)atype withIsrefresh:(BOOL)isRefresh
{
    if ([atype intValue]== 1) {
        _portString = @"borrow.list";
        
        if (isRefresh) {
            page = 1;
            [_productsArray removeAllObjects];
        }
        DLog(@"------%d",page);
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [Product getProductsWithBlock:^(id posts, NSError *error,NSString *listType) {
                //                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                [AnimationView hideCustomAnimationViweFromView:self.view];
                if (error) {
                    DLog(@"error.code = %ld",(long)error.code);
                    ALERTVIEW;
                    [self.productTableView tableViewDidFinishedLoading];
                    self.productTableView.reachedTheEnd  =YES;
                }
                else
                {
                    if ([_portString isEqualToString:@"borrow.list"] ) {
                        NSArray *post = (NSArray *)posts;
                        [_productsArray addObjectsFromArray:post];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_productTableView reloadData];
                            [self loadDataFinishWithArray:_productsArray isProductTableView:YES];
                        });
                        
                    }
                    
                    
                }
            } withPageSize:@"5" withPageNum:[NSString stringWithFormat:@"%d",page] withSname:_portString];
            
        });
        
    }
    else if ([atype intValue]==2)
    {
        
        if (isRefresh) {
            page = 1;
            [_assignmentArray removeAllObjects];
        }
        DLog(@"------%d",page);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [Product_assign getProduct_assignWithBlock:^(id posts, NSError *error) {
                //[MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                [AnimationView hideCustomAnimationViweFromView:self.view];
                if (error) {
                    DLog(@"error.code = %ld",(long)error.code);
                    ALERTVIEW;
                    [self.assignTableView tableViewDidFinishedLoading];
                    self.assignTableView.reachedTheEnd  =YES;
                }
                else{
                    NSArray *post = (NSArray *)posts;
                    [_assignmentArray addObjectsFromArray:post];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_assignTableView reloadData];
                        [self loadDataFinishWithArray:_assignmentArray isProductTableView:NO];
                    });
                }
            } withPageSize:@"5" withPageNum:[NSString stringWithFormat:@"%d",page]];
            
        });
        
    }
    
    
    
    
}

-(void)loadDataFinishWithArray:(NSArray *)array isProductTableView:(BOOL)isProductTableView
{
    if (isProductTableView) {
        //请求下来的数据个数<10，则表示请求完数据
        if (array.count < 5*page) {
            self.productTableView.reachedTheEnd = YES;
        }
        else
        {
            self.productTableView.reachedTheEnd = NO;
        }
        //结束
        [self.productTableView tableViewDidFinishedLoading];
    }
    else
    {
        
        //请求下来的数据个数<10，则表示请求完数据
        if (array.count < 5*page) {
            self.assignTableView.reachedTheEnd = YES;
        }
        else
        {
            self.assignTableView.reachedTheEnd = NO;
        }
        //结束
        [self.assignTableView tableViewDidFinishedLoading];
    }
    
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    page = 1;
    type = @"1";
    
    //初始化productsArray
    _productsArray = [[NSMutableArray alloc] init];
    _assignmentArray = [[NSMutableArray alloc] init];
    //设置背景色为白色
    self.view.backgroundColor = BACKGROUND_COLOR;
    //设置导航条不是半透明的
    self.navigationController.navigationBar.translucent = NO;
   // self.navigationController.navigationBar.barTintColor = NORMALCOLOR;
    self.navigationItem.title = @"产品列表";
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    TapView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-100, TAPHEIGHT)];
    TapView.layer.cornerRadius = 5;
    TapView.clipsToBounds = YES;
    TapView.userInteractionEnabled = YES;
    
    TapView.image = [UIImage imageNamed:@"理财专区"];
    TapView.center =CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, TAPHEIGHT/2.0+8);
//    TapView.layer.borderWidth = 1;
//    TapView.layer.borderColor = NORMALCOLOR.CGColor;
    [self.view addSubview:TapView];
    
    //添加标签
    productTab = [UIButton buttonWithType:UIButtonTypeSystem];
    productTab.frame = CGRectMake(0, 0, TapView.frame.size.width/2.0, TAPHEIGHT);
    // [productTab setBackgroundImage:[UIImage imageNamed:@"产品列表左橙"] forState:UIControlStateNormal];
    [productTab setBackgroundColor:CLEARCOLOR];
    [productTab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [productTab setTitle:@"理财专区" forState:UIControlStateNormal];
    productTab.titleLabel.font = [UIFont systemFontOfSize:15];
    [productTab addTarget:self action:@selector(loadDateWithButtonType:) forControlEvents:UIControlEventTouchUpInside];
    productTab.tag = 2000;
    
    
    assignmentTab = [UIButton buttonWithType:UIButtonTypeSystem];
    assignmentTab.frame = CGRectMake(productTab.frame.size.width, 0, productTab.frame.size.width, TAPHEIGHT);
    //[assignmentTab setBackgroundImage:[UIImage imageNamed:@"产品列表由白"] forState:UIControlStateNormal];
    [assignmentTab setBackgroundColor:[UIColor clearColor]];
    assignmentTab.titleLabel.font = [UIFont systemFontOfSize:15];
    [assignmentTab setTitleColor:NORMALCOLOR forState:UIControlStateNormal];
    [assignmentTab setTitle:@"转让专区" forState:UIControlStateNormal];
    [assignmentTab addTarget:self action:@selector(loadDateWithButtonType:) forControlEvents:UIControlEventTouchUpInside];
    assignmentTab.tag = 2001;
    
    [TapView addSubview:productTab];
    [TapView addSubview:assignmentTab];
    
    
    
}

-(void)loadDateWithButtonType:(UIButton *)sender
{
    if (sender.tag == 2001) {
        //改变btn的颜色
        [productTab setBackgroundColor:[UIColor whiteColor]];
        [productTab setTitleColor:NORMALCOLOR forState:UIControlStateNormal];
        [assignmentTab setBackgroundColor:NORMALCOLOR];
        [assignmentTab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if (_productTableView) {
            [_productTableView removeFromSuperview];
            _productTableView = nil;
        }
        
        if (!_assignTableView) {
            //添加转让专区
            CGRect  frame= CGRectMake(0,TAPHEIGHT+16, DeviceSizeWidth, DeviceSizeHeight-TABHEIGHT - 64-TAPHEIGHT-16);//
            _assignTableView = [[PullingRefreshTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
            _assignTableView.tag = 3001;
            _assignTableView.backgroundColor = BACKGROUND_COLOR;
            DLog(@"%@",NSStringFromCGRect(_assignTableView.frame));
            [self.view addSubview:_assignTableView];
            _assignTableView.dataSource = self;
            _assignTableView.delegate = self;
            _assignTableView.pullingDelegate = self;
            [self.view addSubview:_assignTableView];
            _assignTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        
        
        type = @"2";
        page = 1;
        
        
        [self loadDataWithType:type withIsrefresh:YES];
        
        //        //添加MBProgressHUD
        //        progressHUD = [[MBProgressHUD alloc] init];
        //        progressHUD.color = [UIColor grayColor];
        //        progressHUD.labelText = @"正在刷新";
        //        progressHUD.labelFont = [UIFont systemFontOfSize:13];
        //        [self.view addSubview:progressHUD];
        //        [progressHUD show:YES];
        
        [AnimationView showCustomAnimationViewToView:self.view];
    }
    if (sender.tag == 2000) {
        if (_assignTableView) {
            [_assignTableView removeFromSuperview];
            _assignTableView = nil;
        }
        
        //改变btn的颜色
        [productTab setBackgroundColor:NORMALCOLOR];
        [productTab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [assignmentTab setBackgroundColor:[UIColor whiteColor]];
        [assignmentTab setTitleColor:NORMALCOLOR forState:UIControlStateNormal];
        
        
        if(!_productTableView)
        {
        CGRect  frame= CGRectMake(0,TAPHEIGHT+16, DeviceSizeWidth, DeviceSizeHeight-TABHEIGHT - 64-TAPHEIGHT-16);//
        _productTableView = [[PullingRefreshTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _productTableView.tag = 3000;
        _productTableView.backgroundColor = BACKGROUND_COLOR;
        DLog(@"%@",NSStringFromCGRect(_productTableView.frame));
        _productTableView.dataSource = self;
        _productTableView.delegate = self;
        _productTableView.pullingDelegate = self;
        [self.view addSubview:_productTableView];
        _productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        type = @"1";
        page = 1;
        
        
        [self loadDataWithType:type withIsrefresh:YES];
        
        //        //添加MBProgressHUD
        //        progressHUD = [[MBProgressHUD alloc] init];
        //        progressHUD.color = [UIColor grayColor];
        //        progressHUD.labelText = @"正在刷新";
        //        progressHUD.labelFont = [UIFont systemFontOfSize:13];
        //        [self.view addSubview:progressHUD];
        //        [progressHUD show:YES];
        [AnimationView showCustomAnimationViewToView:self.view];
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (!_productTableView) {
        CGRect  frame= CGRectMake(0,TAPHEIGHT+16, DeviceSizeWidth, DeviceSizeHeight-TABHEIGHT - 64-TAPHEIGHT-16);
        _productTableView = [[PullingRefreshTableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _productTableView.backgroundColor = BACKGROUND_COLOR;
        DLog(@"%@",NSStringFromCGRect(_productTableView.frame));
        [self.view addSubview:_productTableView];
        _productTableView.pullingDelegate = self;
        _productTableView.dataSource = self;
        _productTableView.delegate = self;
        _productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _productTableView.tag = 3000;
    }
   
   // type = @"1";
    page = 1;
    
    //    //添加MBProgressHUD
    //    progressHUD = [[MBProgressHUD alloc] init];
    //    progressHUD.color = [UIColor grayColor];
    //    progressHUD.labelText = @"正在刷新";
    //    progressHUD.labelFont = [UIFont systemFontOfSize:13];
    //    [self.view addSubview:progressHUD];
    //    [progressHUD show:YES];
   // [AnimationView showCustomAnimationViewToView:self.view];
    
    if ([type intValue] == 1) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:2000];
        [self loadDateWithButtonType:btn];
    }
    else
    {
        UIButton *btn = (UIButton *)[self.view viewWithTag:2001];
        [self loadDateWithButtonType:btn];

    }
    //[self loadDataWithType:type withIsrefresh:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(tableView.tag == 3000)
        return [_productsArray count];
    else
        return [_assignmentArray count];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 3000) {
        static NSString *CellIdentifier = @"ProductCell";
        ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
        }
        if (_productsArray.count>0) {
            cell.product = [_productsArray objectAtIndex:indexPath.section];
            
        }
        return cell;
        
    }
    static NSString *CellIdentifier = @"Product_assignCell";
    Product_assignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Product_assignTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
    if (_assignmentArray.count >0) {
        cell.product_assign = [_assignmentArray objectAtIndex:indexPath.section];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 3000) {
        _productIntrVC = [[ProductIntrViewController alloc] init];
        _productIntrVC.hidesBottomBarWhenPushed = YES;
        if (_productsArray.count>0) {
            self.product = [_productsArray objectAtIndex:indexPath.section];
        }
        _productIntrVC.bidId = _product.pid;
        _productIntrVC.titleString = _product.bname;
        _productIntrVC.bidStatus = _product.borrow_status;
        [self.navigationController pushViewController:_productIntrVC animated:YES];
        
    }
    else
    {
        _productIntrVC = [[ProductIntrViewController alloc] init];
        _productIntrVC.hidesBottomBarWhenPushed = YES;
        if (_assignmentArray.count>0) {
            self.product_assign = [_assignmentArray objectAtIndex:indexPath.section];
        }
        _productIntrVC.bidId = [_product_assign.assign_id intValue];
        _productIntrVC.titleString = _product_assign.assign_borrow_name;
        _productIntrVC.bidStatus = _product_assign.assign_borrow_status;
        [self.navigationController pushViewController:_productIntrVC animated:YES];
        
    }
    
}



//在pullingTableView触发此代理方法------

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // [self performSelector:@selector(loadDataWithType:withIsrefresh:) withObject:nil afterDelay:0.1f];
    [self loadDataWithType:type withIsrefresh:YES];
    
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [NSDate date];
    return date;
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    
    page++;
    [self loadDataWithType:type withIsrefresh:NO];
}
#pragma mark------------
#pragma mark - Scroll
//下拉 触发 UIScrollview的代理方法-----------------------调用pulling的方法--
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UITableView *tablview = (UITableView *)scrollView;
    if (tablview.tag == 3000) {
        [self.productTableView tableViewDidScroll:tablview];
    }
    if (tablview.tag == 3001) {
        [self.assignTableView tableViewDidScroll:tablview];
    }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    UITableView *tablview = (UITableView *)scrollView;
    if (tablview.tag == 3000) {
        [self.productTableView tableViewDidEndDragging:tablview];
    }
    if (tablview.tag == 3001) {
        [self.assignTableView tableViewDidEndDragging:tablview];
    }
    
    
}




@end
