//
//  InterestCountViewController.m
//  Cai
//
//  Created by 陈思远 on 16/1/26.
//  Copyright © 2016年 财来. All rights reserved.
//

#import "InterestCountViewController.h"
#import "InterestObj.h"
#import "DetailInterestObj.h"
#import "InterestTableViewCell.h"
#import "AnimationView.h"
@interface InterestCountViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *totalView;

@property(nonatomic,assign) NSInteger currentTag;

@property(nonatomic,strong) NSString *transformBtnTag;

@property(nonatomic,strong) NSMutableArray *detailTitleArray;
@property(nonatomic,strong) NSMutableArray *detailValueArray;
@property(nonatomic,strong) NSMutableArray *constDetailTitleArray;

@property(nonatomic,strong) UIButton *previousBtn;

@end

@implementation InterestCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _collectedInterestTextField.layer.borderColor = NORMALCOLOR.CGColor;
    _collectedInterestTextField.layer.borderWidth = 1.0f;
    _collectedInterestTextField.layer.cornerRadius = 5;
    
    _waitRorCollectedTextfield.layer.borderColor = NORMALCOLOR.CGColor;
    _waitRorCollectedTextfield.layer.borderWidth = 1.0f;
    _waitRorCollectedTextfield.layer.cornerRadius = 5;
    
    self.title = @"资金统计";
    self.view.backgroundColor = UIColorFromRGB(0xf0eff4);
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;

    self.currentTag = 10;//默认当月
    
    //网络请求 已收利息 代收利息
    [self loadInterestData];
    
    
    _totalView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 376.0*[UIScreen mainScreen].bounds.size.height/568.0-20) style:UITableViewStyleGrouped];
    _totalView.delegate = self ;
    _totalView.dataSource = self;
    [_contentView addSubview:_totalView];
    
    _totalArray = [[NSMutableArray alloc] init];
    _detailValueArray= [[NSMutableArray alloc] init];
    _detailTitleArray = [[NSMutableArray alloc] initWithObjects:@"充值总额",@"投资总额",@"已收利息",@"已收本金",@"提现总额", nil];
    _constDetailTitleArray = [[NSMutableArray alloc] init];
    
    _previousBtn = _currentMontBtn;
    
    [_currentMontBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _chosedImage.backgroundColor = NORMALCOLOR;
}

//重置数组
- (void)setDetailTitleArray:(NSMutableArray *)detailTitleArray
{
    _detailTitleArray = detailTitleArray;
    if (_detailTitleArray) {
        _detailTitleArray = nil;
    }
  _detailTitleArray = [[NSMutableArray alloc] initWithObjects:@"充值总额",@"投资总额",@"已收利息",@"已收本金",@"提现总额", nil];}

- (void)loadInterestData
{
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [InterestObj getInterestWithBlock:^(InterestObj *posts, NSError *error) {
        if (error) {
            
        }
        else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _collectedNum.text = [NSString stringWithFormat:@"%@" ,posts.repaymentInterestMoneySum ];
            _waitedForNum.text = [NSString stringWithFormat:@"%@" ,posts.unrepaymentInterestMoneySum];
        });
        }
    }];
});
 
}


- (void)goBack:(id)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCurrentTag:(NSInteger)currentTag
{
    
    switch (currentTag) {
        case 10:
            _transformBtnTag = @"1";
            break;
        case 11:
            _transformBtnTag = @"3";
            break;

        case 12:
             _transformBtnTag = @"6";
            break;

        case 13:
             _transformBtnTag = @"12";
            break;

        case 14:
             _transformBtnTag = @"";
            break;

            
        default:
            break;
    }
    
    [self loadMonthDetailData];
}

- (void)loadMonthDetailData
{
    [AnimationView showCustomAnimationViewToView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [DetailInterestObj getDetailInterestWithBlock:^(id posts,id keyArray, NSString *tag, NSError *error) {
            
            [AnimationView hideCustomAnimationViweFromView:self.view];
            if (error) {
                DLog(@"%@",error.domain);
                if (error.code >= 2000) {
                    UIAlertView *alertaview = [[UIAlertView alloc] initWithTitle:nil message:error.domain delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertaview show];
                }
                else
                {
                    ALERTVIEW;
                }
            }
            else
            {
                if (tag == _transformBtnTag) {
                    //刷新
                    self.totalArray = posts;
                    self.detailTitleArray = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_totalView reloadData];
                    });
                }
                else
                {
                    //不刷新 清空数组
                    [_totalArray removeAllObjects];
                }
                
            }
        } withType:_transformBtnTag withBtnTag:_transformBtnTag];
    });
    
}



- (IBAction)monthBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.currentTag = btn.tag;
    [btn setTitleColor:NORMALCOLOR forState:UIControlStateNormal];
    [_previousBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _previousBtn = btn;

    [UIView animateWithDuration:0.25 animations:^{
        _chosedImage.frame = CGRectMake(_previousBtn.frame.origin.x, 73, _previousBtn.frame.size.width, 2);
    }];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Identifier = @"cellIdentifier";
    InterestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[InterestTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   
    if (_totalArray.count>0) {
        DetailInterestObj *detailObj = [_totalArray objectAtIndex:indexPath.section];
            _constDetailTitleArray = [detailObj.mutableArray mutableCopy];
            self.detailTitleArray = nil;
            [_detailTitleArray insertObject:[detailObj.mutableArray objectAtIndex:indexPath.row] atIndex:0];
            cell.textLabel.text = [_detailTitleArray objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            
            [_constDetailTitleArray replaceObjectAtIndex:0 withObject:@""];
            
            cell.detailTextLabel.text = [_constDetailTitleArray  objectAtIndex:indexPath.row];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];

            
    }
       return cell;
}

 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _totalArray.count;
}

@end
