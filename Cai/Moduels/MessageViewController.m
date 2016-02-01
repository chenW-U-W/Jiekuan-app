//
//  MessageViewController.m
//  Cai
//
//  Created by csj on 15/9/10.
//  Copyright (c) 2015年 财来. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "AnimationView.h"
#import "CailaiAPIClient.h"
@interface MessageViewController ()
{
    int page;
    
    UIButton *unReadBtn;
    UIButton *readedBtn;
    UIView *TapView;
    NSString *isRead;
    
}

@property (nonatomic,strong)NSMutableArray *unreadArray;
@property (nonatomic,strong)NSMutableArray *readedArray;
@property (nonatomic,strong)NSString *portString;


@end

@implementation MessageViewController

- (void)loadDataWithType:(NSString *)atype withRefresh:(BOOL)isRefresh
{
    
    
    if ([isRead intValue]== 0) {
        //未读
        
        if (isRefresh) {
            page = 1;
            [_unreadArray removeAllObjects];
        }
        DLog(@"------%d",page);
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            
            [MessageObj getMessageObjWithBlock:^(id response,NSString *listType, NSError *error) {
                //                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            
                if (error) {
                    DLog(@"error.code = %ld",(long)error.code);
                    ALERTVIEW;
                    [self.unreadTableView tableViewDidFinishedLoading];
                    self.unreadTableView.reachedTheEnd  =YES;
                }
                else
                {
                    if ([isRead isEqualToString:@"0"] ) {
                        NSArray *post = (NSArray *)response;
                        [_unreadArray addObjectsFromArray:post];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                             [AnimationView hideCustomAnimationViweFromView:self.view];
                            [self loadDataFinishWithArray:_unreadArray isUnreadedTableView:YES];
                            [_unreadTableView reloadData];
                        });

                    }
                    
                    
                }
            } withPageSize:@"5" withPageNum:[NSString stringWithFormat:@"%d",page] withSname:_portString withIsRead:isRead];
            
            
        });
        
    }
    else if ([isRead intValue]==1)
    {
        
        if (isRefresh) {
            page = 1;
            [_readedArray removeAllObjects];
        }
        DLog(@"------%d",page);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [MessageObj getMessageObjWithBlock:^(id response,NSString *listType, NSError *error) {
                //                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            
                if (error) {
                    DLog(@"error.code = %ld",(long)error.code);
                    ALERTVIEW;
                    [self.readedTableView tableViewDidFinishedLoading];
                    self.readedTableView.reachedTheEnd  =YES;
                }
                else
                {
                    if ([isRead isEqualToString:@"1"] ) {
                        NSArray *post = (NSArray *)response;
                        [_readedArray addObjectsFromArray:post];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                           
                            [self loadDataFinishWithArray:_readedArray  isUnreadedTableView:NO];
                             [AnimationView hideCustomAnimationViweFromView:self.view];
                            [_readedTableView reloadData];
                        });
                        
                    }
                    
                    
                }
            } withPageSize:@"5" withPageNum:[NSString stringWithFormat:@"%d",page] withSname:_portString withIsRead:isRead];
            
           
        });
        
    }
    
    
    
    
}

-(void)loadDataFinishWithArray:(NSArray *)array isUnreadedTableView:(BOOL)isUnreadedTableView
{
    if (isUnreadedTableView) {
        
        self.unreadTableView.reachedTheEnd = YES;
        
                //结束
        [self.unreadTableView tableViewDidFinishedLoading];
    }
    else
    {
        
        //请求下来的数据个数<10，则表示请求完数据
       
        self.readedTableView.reachedTheEnd = YES;
        
                //结束
        [self.readedTableView tableViewDidFinishedLoading];
    }
    
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    page = 1;
    isRead = @"0";//未读
    
    //初始化productsArray
    _unreadArray  = [[NSMutableArray alloc] init];
    _readedArray = [[NSMutableArray alloc] init];
    //设置背景色为白色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航条不是半透明的
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationItem.title = @"我的消息";
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    TapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TAPHEIGHT)];
    TapView.center =CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, TAPHEIGHT/2.0+8);
    TapView.layer.borderWidth = 1;
    TapView.layer.borderColor = NORMALCOLOR.CGColor;
    [self.view addSubview:TapView];
    //添加标签
    unReadBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    unReadBtn.frame = CGRectMake(0, 0, TapView.frame.size.width/2.0, TAPHEIGHT);
    // [unReadBtn setBackgroundImage:[UIImage imageNamed:@"产品列表左橙"] forState:UIControlStateNormal];
    [unReadBtn setBackgroundColor:NORMALCOLOR];
    [unReadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [unReadBtn setTitle:@"未读消息" forState:UIControlStateNormal];
    unReadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [unReadBtn addTarget:self action:@selector(loadDateWithButtonType:) forControlEvents:UIControlEventTouchUpInside];
    unReadBtn.tag = 2000;
    
    
    readedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    readedBtn.frame = CGRectMake(unReadBtn.frame.size.width, 0, unReadBtn.frame.size.width, TAPHEIGHT);
    //[assignmentTab setBackgroundImage:[UIImage imageNamed:@"产品列表由白"] forState:UIControlStateNormal];
    [readedBtn setBackgroundColor:[UIColor whiteColor]];
    readedBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [readedBtn setTitleColor:NORMALCOLOR forState:UIControlStateNormal];
    [readedBtn setTitle:@"已读消息" forState:UIControlStateNormal];
    [readedBtn addTarget:self action:@selector(loadDateWithButtonType:) forControlEvents:UIControlEventTouchUpInside];
    readedBtn.tag = 2001;
    
    [TapView addSubview:unReadBtn];
    [TapView addSubview:readedBtn];
    
    
}

-(void)loadDateWithButtonType:(UIButton *)sender
{
    if (sender.tag == 2001) {
        //改变btn的颜色
        [unReadBtn setBackgroundColor:[UIColor whiteColor]];
        [unReadBtn setTitleColor:NORMALCOLOR forState:UIControlStateNormal];
        [readedBtn setBackgroundColor:NORMALCOLOR];
        [readedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if (_unreadTableView) {
            [_unreadTableView removeFromSuperview];
            _unreadTableView = nil;
        }
        
        if (!_readedTableView) {
            //添加已读
            CGRect  frame= CGRectMake(0,TAPHEIGHT+16, DeviceSizeWidth, DeviceSizeHeight-TABHEIGHT - 64-TAPHEIGHT-16);//
            _readedTableView= [[PullingRefreshTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
            _readedTableView.tag = 3001;
            _readedTableView.backgroundColor = BACKGROUND_COLOR;
            DLog(@"%@",NSStringFromCGRect(_readedTableView.frame));
            [self.view addSubview:_readedTableView];
            _readedTableView.dataSource = self;
            _readedTableView.delegate = self;
            _readedTableView.pullingDelegate = self;
            [self.view addSubview:_readedTableView];
            _readedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        }
        
        isRead = @"1";
        page = 1;
        
        
        [self loadDataWithType:isRead withRefresh:YES];
        [AnimationView showCustomAnimationViewToView:self.view];
    }
    if (sender.tag == 2000) {
        if (_readedTableView) {
            [_readedTableView removeFromSuperview];
            _readedTableView = nil;
        }
        
        //改变btn的颜色
        [unReadBtn setBackgroundColor:NORMALCOLOR];
        [unReadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [readedBtn setBackgroundColor:[UIColor whiteColor]];
        [readedBtn setTitleColor:NORMALCOLOR forState:UIControlStateNormal];
        
        
        if (!_unreadTableView) {
            CGRect  frame= CGRectMake(0,TAPHEIGHT+16, DeviceSizeWidth, DeviceSizeHeight-TABHEIGHT - 64-TAPHEIGHT-16);//
            _unreadTableView = [[PullingRefreshTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
            _unreadTableView.tag = 3000;
            _unreadTableView.backgroundColor = BACKGROUND_COLOR;
            DLog(@"%@",NSStringFromCGRect(_unreadTableView.frame));
            _unreadTableView.dataSource = self;
            _unreadTableView.delegate = self;
            _unreadTableView.pullingDelegate = self;
            [self.view addSubview:_unreadTableView];
            _unreadTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        
        
        isRead = @"0";
        page = 1;
        
        [self loadDataWithType:isRead withRefresh:YES];
        [AnimationView showCustomAnimationViewToView:self.view];
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    CGRect  frame= CGRectMake(0,TAPHEIGHT+16, DeviceSizeWidth, DeviceSizeHeight-TABHEIGHT - 64-TAPHEIGHT-16);
//    _unreadTableView = [[PullingRefreshTableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
//    _unreadTableView.backgroundColor = BACKGROUND_COLOR;
//    DLog(@"%@",NSStringFromCGRect(_unreadTableView.frame));
//    [self.view addSubview:_unreadTableView];
//    _unreadTableView.pullingDelegate = self;
//    _unreadTableView.dataSource = self;
//    _unreadTableView.delegate = self;
//    _unreadTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _unreadTableView.tag = 3000;
   
    
    
    //如果在
    if ([isRead intValue] == 0) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:2000];
        [self loadDateWithButtonType:btn];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag == 3000)
        return [_unreadArray count];
    else
        return [_readedArray count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 3000) {
        static NSString *CellIdentifier = @"MessageCell";
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            
           
        }
        if (_unreadArray.count>0) {
            cell.messageOBJ = [_unreadArray objectAtIndex:indexPath.section];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    }
    static NSString *CellIdentifier = @"IsReadedMessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        
        
    }
    if (_readedArray.count >0) {
        cell.messageOBJ = [_readedArray objectAtIndex:indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
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
    _messageDeatilVC = [[MessageDetailViewController alloc] init];
    _messageDeatilVC.hidesBottomBarWhenPushed = YES;
    if (tableView.tag == 3000) {        
        if (_unreadArray.count>0) {
            _messageDeatilVC.messageObj = [_unreadArray objectAtIndex:indexPath.section];
        }
      MessageObj *selectedMessageObj = [_unreadArray objectAtIndex:indexPath.row];
        //向server端发送数据
        [self  postMessageWithBlock:^(id response, NSError *error) {
            DLog(@"------");
            [self.navigationController pushViewController:_messageDeatilVC animated:YES];
        } withMessageId:selectedMessageObj.MessageId];

    }
    else
    {
        if (_readedArray.count>0) {
            _messageDeatilVC.messageObj = [_readedArray objectAtIndex:indexPath.section];
        }
        [self.navigationController pushViewController:_messageDeatilVC animated:YES];
    }
    
    
    
    
}

- (void)goBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


//在pullingTableView触发此代理方法------

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    // [self performSelector:@selector(loadDataWithType:withIsrefresh:) withObject:nil afterDelay:0.1f];
    [self loadDataWithType:isRead withRefresh:YES];
    
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [NSDate date];
    return date;
}

//没有分页
//- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
//    
//    page++;
//    [self loadDataWithType:isRead withRefresh:NO];
//}
#pragma mark------------
#pragma mark - Scroll
//下拉 触发 UIScrollview的代理方法-----------------------调用pulling的方法--
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UITableView *tablview = (UITableView *)scrollView;
    if (tablview.tag == 3000) {
        [self.unreadTableView tableViewDidScroll:tablview];
    }
    if (tablview.tag == 3001) {
        [self.readedTableView tableViewDidScroll:tablview];
    }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    UITableView *tablview = (UITableView *)scrollView;
    if (tablview.tag == 3000) {
        [self.unreadTableView tableViewDidEndDragging:tablview];
    }
    if (tablview.tag == 3001) {
        [self.readedTableView tableViewDidEndDragging:tablview];
    }
    
    
}

- (void)postMessageWithBlock:(void(^)(id response,NSError *error))block withMessageId:(NSString *)messageID
{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"user.messageslist.get",@"sname",messageID,@"messageId",nil];
    
    [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        
        id response =  [JSON objectForKey:@"data"];
        if (block) {
            block(response,nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }
    } method:@"POST"];
    
    
}


@end
