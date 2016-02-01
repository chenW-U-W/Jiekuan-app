//
//  MessageTableViewController.m
//  Cai
//
//  Created by csj on 15/8/18.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "MessageTableViewController.h"
#import "CustomTableViewCell.h"
#import "MyReceiveObj.h"
#import "TimeObj.h"
@interface MessageTableViewController ()
//{
//    float shouldReturnedMoney;
//    float returnedMoney ;
//}
@property(nonatomic,strong)NSMutableArray *dateMutableArray;
@property(nonatomic,strong) UIView *mont_releatedView;
@end

@implementation MessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    //创建本月应回款和已回款
//    [self creatMonth_releatedView];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    //self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.frame = CGRectMake(0, 310/ViewWithDevicHeight+CellSize , [UIScreen mainScreen].bounds.size.width,1000);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    shouldReturnedMoney = 0;
//    returnedMoney = 0;
    _totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    _dateMutableArray = [[NSMutableArray alloc] initWithCapacity:0];
//    _mont_releatedTotalArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setTotalArray:(NSMutableArray *)totalArray
{
    if (totalArray.count>0) {
        NSInteger count = totalArray.count;
        self.tableView.frame = CGRectMake(0, 310/ViewWithDevicHeight+CellSize , [UIScreen mainScreen].bounds.size.width, count *(20+CellSize));
        _totalArray = totalArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            self.notifyBlock(_totalArray.count);
            
        });
 
    }
    else if (totalArray.count == 0)
    {
    
        self.tableView.frame = CGRectMake(0, 310/ViewWithDevicHeight+CellSize , [UIScreen mainScreen].bounds.size.width, 1 *(20+CellSize));
        _totalArray = totalArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            self.notifyBlock(1);
            
        });
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _totalArray.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //同一天有多个标重叠//--------------//暂不考虑
  
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
        if (_totalArray.count>0) {
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 150, 18)];
            [dateLabel setBackgroundColor:[UIColor whiteColor]];
            dateLabel.font = [UIFont systemFontOfSize:13];
            dateLabel.textColor = [UIColor grayColor];            
            //dateLabel.textAlignment = NSTextAlignmentRight;
            MyReceiveObj *myreceiveObj = [_totalArray objectAtIndex:section];
            NSDate *deadlineDate = myreceiveObj.deadline;
            NSString *deadlineDateString =  [TimeObj stringFromReceivedDate:deadlineDate withDateFormat:@"   yyyy年MM月dd日"];//
            if(myreceiveObj.deadlineTime > 0)
                dateLabel.text = deadlineDateString;
            else
                dateLabel.text = @"";
            return dateLabel;
        }
   
    return nil;

    

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellSize;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MessageCellIdentifier = @"MessageCell";
    CustomTableViewCell *cell  =  [tableView dequeueReusableCellWithIdentifier:MessageCellIdentifier];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:nil options:nil];
        
        //      目的：是找LPCustomCell对应的 拖拽的cell
        for (id obj in nibs)
        {
            if ([obj isKindOfClass:[CustomTableViewCell class]])
            {
                cell = (CustomTableViewCell *)obj ;
                
                break;
            }
        }
    }
    if (_totalArray>0) {
        
        MyReceiveObj *myReceiveObj = [_totalArray objectAtIndex:indexPath.section];
        if (!myReceiveObj.describeString) {
            cell.titleString = myReceiveObj.projiectName;
            float myreceiveInterest = myReceiveObj.interest;
            float myreceiveCapital = myReceiveObj.capital;
            cell.interestString = [NSString stringWithFormat:@"还款金额 %.2f 元",myreceiveInterest+myreceiveCapital];
            cell.status = myReceiveObj.app_status;
        }
        else
        {
            cell.titleString = myReceiveObj.describeString;
            cell.interestString = @"      ";
            cell.status = @"";
        
        }
        
    }

    return cell;
}



@end
