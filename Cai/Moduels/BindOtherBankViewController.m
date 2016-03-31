//
//  BindOtherBankViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/15.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "BindOtherBankViewController.h"
#import "BindOtherBankCell.h"
#import "BankcardsObj.h"
#import "BindbankViewController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
@interface BindOtherBankViewController ()

@property(nonatomic,strong) NSArray *bankArray;
@property(nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) NSArray *responseArray;
@property (nonatomic,strong) UIButton *bindBankBtn;
@property (nonatomic,strong) NSDictionary *bindBankDic;
@end

@implementation BindOtherBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
      self.tableView.delegate = self;
      self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
      [self.view addSubview:_tableView];
      
      
      
      self.title = @"我的银行卡";
      UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
      [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
      [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
      UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
      self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    _bankArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _bindBankBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_bindBankBtn   addTarget:self action:@selector(bindBankClick) forControlEvents:UIControlEventTouchUpInside];
    //_bindBankBtn.frame = CGRectMake(0, _tableView.frame.size.height-40, self.view.frame.size.width, 40);
     _bindBankBtn.frame =  CGRectMake(30/ViewWithDevicWidth, _tableView.frame.size.height-50, 261/ViewWithDevicWidth, 35/ViewWithDevicHeight);
    [_bindBankBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形按钮"] forState:UIControlStateNormal];
    [_bindBankBtn setTitle:@"绑定银行卡" forState:UIControlStateNormal];
    [_bindBankBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_bindBankBtn];
    
}


- (void)bindBankClick
{
    BindbankViewController *bindbankVC = [[BindbankViewController alloc] init];
    bindbankVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bindbankVC animated:YES];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadData];
    [super viewWillAppear:YES];
}



-(void)loadData
{

    // _bankArray = [NSArray arrayWithObjects:@"建设银行",@"中国工商银行",@"中国工商银行", nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [BankcardsObj bankCardWithBlock:^(id response, NSError *error) {
            if ([response isKindOfClass:[NSString class]]) {
                if (!_imageView) {
                    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 204, 258)];
                    _imageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0-40/ViewWithDevicHeight);
                    _imageView.image = [UIImage imageNamed:@"60"];
                    [self.view addSubview:_imageView];
                    
                }

            }
            else if ([response isKindOfClass:[NSArray class]]) {
                _bankArray = response;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
            else if (error)
            {
            
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alertView show];
            }
            
        }];
    });
    
}

- (void)goBack:(id)sender
{

      [self.navigationController popViewControllerAnimated:YES];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
      
      return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      
    if (_bankArray.count == 0) {
        return 0;
    }
      return _bankArray.count;
            
      
      
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      
            return 70;
      
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      BindOtherBankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BindOtherBanCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
      if (cell== nil) {            
            
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"BindOtherBankCell" owner:nil options:nil];
            for (BindOtherBankCell *objec in nibs) {
                  cell = objec;
                  break;
            }
          cell.bankCardObj = [_bankArray objectAtIndex:indexPath.row];
          
      }
      
      return cell;
      
      
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
