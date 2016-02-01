//
//  Product_assignTableViewController.m
//  Cai
//
//  Created by csj on 15/8/25.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "Product_assignTableViewController.h"
#import "Product_assignTableViewCell.h"
#import "Product_assign.h"
#import "ProductIntrViewController.h"
#import "MBProgressHUD.h"
#import "AnimationView.h"


@interface Product_assignTableViewController ()
{
    MBProgressHUD *progressHUD;
    int page;
    
    UIButton *productTab;
    UIButton *assignmentTab;
    UIImageView *TapView;
}

//转让区
@property (nonatomic,strong)NSMutableArray *assignmentArray;
@property (nonatomic,strong)NSString *portString;


@end

@implementation Product_assignTableViewController

- (void)loadDataWithIsrefresh:(BOOL)isRefresh
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
                
            }
            else{
            NSArray *post = (NSArray *)posts;
            [_assignmentArray addObjectsFromArray:post];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
               
            });
            }
         } withPageSize:@"5" withPageNum:[NSString stringWithFormat:@"%d",page]];
        
    });
    
    
    
}




- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    //初始化productsArray
   
    _assignmentArray = [[NSMutableArray alloc] init];
    //设置背景色为白色
    self.view.backgroundColor = BACKGROUND_COLOR;
    //设置导航条不是半透明的
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"产品列表";
   
    
    
    
    
    TapView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-100, TAPHEIGHT)];
    TapView.layer.cornerRadius = 5;
    TapView.clipsToBounds = YES;
    TapView.center =CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, TAPHEIGHT/2.0+8);
    TapView.image = [UIImage imageNamed:@"转让专区"];
//    TapView.layer.borderWidth = 1;
//    TapView.layer.borderColor = NORMALCOLOR.CGColor;
    TapView.userInteractionEnabled = YES;
    [self.view addSubview:TapView];
    //添加标签
    productTab = [UIButton buttonWithType:UIButtonTypeSystem];
    productTab.frame = CGRectMake(0, 0, TapView.frame.size.width/2.0, TAPHEIGHT);
    // [productTab setBackgroundImage:[UIImage imageNamed:@"产品列表左橙"] forState:UIControlStateNormal];
    [productTab setBackgroundColor:[UIColor clearColor]];
    [productTab setTitleColor:NORMALCOLOR forState:UIControlStateNormal];
    [productTab setTitle:@"理财专区" forState:UIControlStateNormal];
    productTab.titleLabel.font = [UIFont systemFontOfSize:15];
    [productTab addTarget:self action:@selector(loadDateWithButtonType:) forControlEvents:UIControlEventTouchUpInside];
    productTab.tag = 2000;
    
    
    assignmentTab = [UIButton buttonWithType:UIButtonTypeSystem];
    assignmentTab.frame = CGRectMake(productTab.frame.size.width, 0, productTab.frame.size.width, TAPHEIGHT);
    //[assignmentTab setBackgroundImage:[UIImage imageNamed:@"产品列表由白"] forState:UIControlStateNormal];
    assignmentTab.layer.cornerRadius = 5;
    [assignmentTab setBackgroundColor:CLEARCOLOR];
    assignmentTab.titleLabel.font = [UIFont systemFontOfSize:15];
    [assignmentTab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [assignmentTab setTitle:@"转让专区" forState:UIControlStateNormal];
    [assignmentTab addTarget:self action:@selector(loadDateWithButtonType:) forControlEvents:UIControlEventTouchUpInside];
    assignmentTab.tag = 2001;
    
    [TapView addSubview:productTab];
    [TapView addSubview:assignmentTab];
    

    
    CGRect  frame=CGRectMake(0, TapView.frame.origin.y+TapView.frame.size.height+15, DeviceSizeWidth, DeviceSizeHeight-TABHEIGHT-64-TAPHEIGHT-16);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.backgroundColor = BACKGROUND_COLOR;
    DLog(@"%@",NSStringFromCGRect(_tableView.frame) );
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    

    
}

-(void)loadDateWithButtonType:(UIButton *)sender
{
    
    if (sender.tag == 2000) {
        
        [self loadDataWithIsrefresh:YES];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    page = 1;
   
    
//    //添加MBProgressHUD
//    progressHUD = [[MBProgressHUD alloc] init];
//    progressHUD.color = [UIColor grayColor];
//    progressHUD.labelText = @"正在刷新";
//    progressHUD.labelFont = [UIFont systemFontOfSize:13];
//    [self.view addSubview:progressHUD];
//    [progressHUD show:YES];
    
    [AnimationView showCustomAnimationViewToView:self.view];
  

    
    
}
- (void)loadNewData
{
    [self loadDataWithIsrefresh:YES];
    
}
- (void)loadMoreData
{
    [self loadDataWithIsrefresh:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_assignmentArray count];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Product_assignTableViewCell";
    Product_assignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Product_assignTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (_assignmentArray.count >0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    if(section == 0)
    {
        return 0.1;
    }
    return 12;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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



@end
