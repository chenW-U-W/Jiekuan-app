//
//  CustomCalendarViewController.h
//  sampleCalendar
//
//  Created by cailai on 21/07/2014.
//  Copyright  All rights reserved.
//

#import "CustomCalendarViewController.h"
#import "ReturnedDateObj.h"
#import "MyReceiveObj.h"
#import "TimeObj.h"
#import "MBProgressHUD.h"
#import "AnimationView.h"
#import "UIView+Toast.h"


@interface CustomCalendarViewController ()

@property (nonatomic, strong) CalendarView * customCalendarView;
@property (nonatomic, strong) NSCalendar * gregorian;
@property (nonatomic, assign) NSInteger currentYear;
@property (nonatomic, strong) UIView *barView;   //barView
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *DoneButton;
@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *monthArray;

@property (nonatomic,assign) BOOL isSetedTotalArray;

//储存请求的总的数据源
@property (nonatomic, strong) NSMutableArray *totalArray;

//业务相关
@property(nonatomic,strong)NSMutableArray *dateMutableArray;//遍历得到的标记日期
@property(nonatomic,strong)NSString *shouldReturnMoney;//本月应回款
@end

@implementation CustomCalendarViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 340/ViewWithDevicHeight);
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"Custom Calendar";
    
    _gregorian       = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    _customCalendarView.borderWidth                 = 0;
    _customCalendarView                             = [[CalendarView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height)];
    _customCalendarView.delegate                    = self;
    _customCalendarView.datasource                  = self;
    _customCalendarView.calendarDate                = [NSDate date];
    
    _customCalendarView.monthAndDayTextColor        = [UIColor blackColor];//星期颜色
    _customCalendarView.dayBgColorWithData          = [UIColor whiteColor];//还未过去的日期
    _customCalendarView.dayBgColorWithoutData       = [UIColor whiteColor];//已经过去的日期
    _customCalendarView.dayBgColorSelected          = [UIColor redColor];// 本日
    _customCalendarView.dayTxtColorWithoutData      = [UIColor blackColor];//已过的字体颜色
    _customCalendarView.dayTxtColorWithData         = [UIColor blackColor];//未过的
    _customCalendarView.dayTxtColorSelected         = [UIColor whiteColor]; //被选中时的字体颜色
    _customCalendarView.borderColor                 = RGBCOLOR(159, 162, 172);
    _customCalendarView.borderWidth                 = 0;
    _customCalendarView.allowsChangeMonthByDayTap   = YES;
    //第一次进入
    _customCalendarView.allowsChangeMonthByButtons  = YES;
    _customCalendarView.keepSelDayWhenMonthChange   = YES;
    _customCalendarView.nextMonthAnimation          = UIViewAnimationOptionTransitionCrossDissolve;//动画效果
    _customCalendarView.prevMonthAnimation          = UIViewAnimationOptionTransitionCrossDissolve;//动画效果
    
    
//    _barView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+1, [UIScreen mainScreen].bounds.size.width, BARVIEWHEIGHT)];
//    _barView.backgroundColor = [UIColor colorWithRed:0.922 green:0.922 blue:0.925 alpha:1];
//    [[UIApplication sharedApplication].keyWindow addSubview:_barView];
//    
//    
//    
//    _DoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _DoneButton.frame = CGRectMake(0, 0, 50, BARVIEWHEIGHT);
//    _DoneButton.backgroundColor = [UIColor clearColor];
//    [_DoneButton setTitle:@"完成" forState:UIControlStateNormal];
//    _DoneButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [_DoneButton setTitleColor:[UIColor colorWithRed:1.000 green:0.451 blue:0.000 alpha:1] forState:UIControlStateNormal];
//    [_DoneButton addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
//    [_barView addSubview:_DoneButton];
//    
//    
//    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+1+_barView.frame.size.height, [UIScreen mainScreen].bounds.size.width, DATEPICKERHEIGHT)];
//    _pickerView.backgroundColor = [UIColor whiteColor];
//    _pickerView.delegate = self;
//    _pickerView.dataSource = self;
//    
//    
//    
    NSDateComponents *compents = [_gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
    [_pickerView selectRow:2 inComponent:0 animated:NO];
    [_pickerView selectRow:compents.month-1 inComponent:1 animated:NO];
    [[UIApplication sharedApplication].keyWindow addSubview:_pickerView];
    
    
    //数据源
    _dateMutableArray = [[NSMutableArray alloc] initWithCapacity:0];

    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_customCalendarView];
        _customCalendarView.center = CGPointMake(self.view.center.x, _customCalendarView.center.y);
        __block CustomCalendarViewController *weakSelf = self;
         _customCalendarView.tapBlock = ^(NSString *year,NSString *month){
        //弹出datepicker 和  toolbar
             _barView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+1, [UIScreen mainScreen].bounds.size.width, BARVIEWHEIGHT)];
            _barView.backgroundColor = [UIColor colorWithRed:0.922 green:0.922 blue:0.925 alpha:1];
             [[UIApplication sharedApplication].keyWindow addSubview:_barView];
             
            
             
             _DoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
             _DoneButton.frame = CGRectMake(0, 0, 50, BARVIEWHEIGHT);
             _DoneButton.backgroundColor = [UIColor clearColor];
             [_DoneButton setTitle:@"完成" forState:UIControlStateNormal];
             _DoneButton.titleLabel.font = [UIFont systemFontOfSize:15];
             [_DoneButton setTitleColor:[UIColor colorWithRed:1.000 green:0.451 blue:0.000 alpha:1] forState:UIControlStateNormal];
             [_DoneButton addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
             [_barView addSubview:_DoneButton];
             
             
             _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+1+_barView.frame.size.height, [UIScreen mainScreen].bounds.size.width, DATEPICKERHEIGHT)];
             _pickerView.backgroundColor = [UIColor whiteColor];
             _pickerView.delegate = weakSelf;
             _pickerView.dataSource = weakSelf;
            
             
             
             NSDateComponents *compents = [_gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
             [_pickerView selectRow:2 inComponent:0 animated:NO];
             [_pickerView selectRow:compents.month-1 inComponent:1 animated:NO];
             [[UIApplication sharedApplication].keyWindow addSubview:_pickerView];
             
             [UIView animateWithDuration:0.25 animations:^{
                 _barView.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height-DATEPICKERHEIGHT-BARVIEWHEIGHT, [UIScreen mainScreen].bounds.size.width, BARVIEWHEIGHT);
                 _pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-DATEPICKERHEIGHT, [UIScreen mainScreen].bounds.size.width, DATEPICKERHEIGHT);
             } completion:nil];
        
             return @"";
        };
    });
    
    
    
    
    
    //获取当前时间年份
    NSDateComponents * yearComponent = [_gregorian components:NSCalendarUnitYear fromDate:[NSDate date]];
    _currentYear = yearComponent.year;
    
    //创建年月的数组  获取pickerView 的数据源
    NSDateComponents *acompent = [_gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
    acompent.year= acompent.year-2;
    _yearArray = [NSMutableArray arrayWithCapacity:0];
    _monthArray = [NSMutableArray arrayWithCapacity:0];
    int month = 1;
    for (int i= 0; i<5;i++) {
        
        [_yearArray addObject:[NSString stringWithFormat:@"%ld年",(long)compents.year]];
        compents.year++;
    }
    for (int i=0; i<12; i++) {
        [_monthArray addObject:[NSString stringWithFormat:@"%d月",month]];
        month++;
    }
    
    
//      [self MonthChangedToMonth:[NSDate date]];

}


- (void)doneClicked
{
    __block CalendarView *weakCalendarView = _customCalendarView;
    [UIView animateWithDuration:0.25 animations:^{
        _barView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+1, [UIScreen mainScreen].bounds.size.width, BARVIEWHEIGHT);
        _pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+1+_barView.frame.size.height, [UIScreen mainScreen].bounds.size.width, DATEPICKERHEIGHT);
    } completion:^(BOOL finished){
        //刷新日历试图
        NSInteger yearRow = [_pickerView selectedRowInComponent:0];
        NSInteger monthRow = [_pickerView selectedRowInComponent:1];
        NSString *yearString = [[_yearArray objectAtIndex:yearRow] substringToIndex:4];
        NSArray *array = [[_monthArray objectAtIndex:monthRow] componentsSeparatedByString:@"月"];
        NSString *monthString = [array objectAtIndex:0];
         NSDateComponents * compents = [_gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
        compents.year = [yearString integerValue];
        compents.month = [monthString integerValue];
        NSDate *adate = [_gregorian dateFromComponents:compents];
        [weakCalendarView showPcikedMonth:adate];
        //设置日历的日期title触摸没反应
        weakCalendarView.isShowDatePicker = YES;
    }];

}



#pragma mark - CalendarDelegate protocol conformance

//点击日期时 调用
-(void)dayChangedToDate:(NSDate *)selectedDate
{
    _isSetedTotalArray = NO;
    NSString* selectedDateString = [TimeObj stringFromReceivedDate:selectedDate withDateFormat:@"yyyy-MM-dd"];
    
    NSLog(@"dayChangedToDate %@(GMT)",selectedDate);
    
    
        //遍历 日期 数组
        NSMutableArray *amutableArray  = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0;i<_dateMutableArray.count;i++) {
            
            if (i<_dateMutableArray.count) {
                NSString *dateString = [_dateMutableArray objectAtIndex:i];
                if ([dateString isEqualToString:selectedDateString]) {
                    
                    MyReceiveObj *myobject = [self.totalArray objectAtIndex:i];
                                                            [amutableArray addObject:myobject];
                    _isSetedTotalArray = YES;
                }
            }
            
    }
    _messageTVC.totalArray = amutableArray;
    
    if (!_isSetedTotalArray) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"本日无还款项目",@"describeString",[NSString stringWithFormat:@"%.0f",selectedDate.timeIntervalSince1970] ,@"deadline", nil];
//        [NSDictionary dictionaryWithObjectsAndKeys:@"本日无还款项目",@"describeString",selectedDate.timeIntervalSince1970 ,@"deadline", nil];
        DLog(@"%@",dic);
        MyReceiveObj *myreceiveOBJ = [[MyReceiveObj alloc] initWithAttribut:dic];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithObject:myreceiveOBJ];
        
        _messageTVC.totalArray = mutableArray;
        
        
    }
    
}


//月份切换触发的： 本月（其实用blcok更好，这样的话_customCalendarView.markedDateArray 就可以在calendar中设置）
- (void)MonthChangedToMonth:(NSDate *)selectedMonth isFirstEnter:(BOOL)isFirst
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AnimationView showCustomAnimationViewToView:self.view];
    
    NSDateComponents *dateCompent = [_gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:selectedMonth];
    NSString *search_year = [NSString stringWithFormat:@"%ld",(long)dateCompent.year];
     NSString *search_month = [NSString stringWithFormat:@"%02ld",(long)dateCompent.month];
    
    //重新请求数据源后datearray并未赋值而是不断添加因此需先清除_dateMutableArray
    [_dateMutableArray removeAllObjects];
    
    __block CalendarView *weakCustomCalendarView = _customCalendarView;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        //请求数据 得到数组
        [ReturnedDateObj ReturnedDateObjWithBlock:^(id response, NSError *error) {
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [AnimationView hideCustomAnimationViweFromView:self.view];
            if (!error) {
                //储存多个标的应回款信息  即myReceiveOBJ
                
                NSMutableArray *myReceivArray = (NSMutableArray *)response;
                //1 通过seter方法刷新monthReleatedView
                self.month_releatedBlock(myReceivArray);
                
                //2 通过seter方法刷新messageTVC的表
                if (myReceivArray.count >0) {
                    _messageTVC.totalArray = myReceivArray;
                }
               
                else
                {
                    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"本月无还款项目",@"describeString", nil];
                    //        [NSDictionary dictionaryWithObjectsAndKeys:@"本日无还款项目",@"describeString",selectedDate.timeIntervalSince1970 ,@"deadline", nil];
                    DLog(@"%@",dic);
                    MyReceiveObj *myreceiveOBJ = [[MyReceiveObj alloc] initWithAttribut:dic];
                    NSMutableArray *mutableArray = [NSMutableArray arrayWithObject:myreceiveOBJ];
                    
                    _messageTVC.totalArray = mutableArray;

                
                }
                self.totalArray = myReceivArray;
                
                DLog(@"-------aa-------%ld",(unsigned long)myReceivArray.count);
                for (MyReceiveObj *myreceiveOBJ in myReceivArray) {
                    //header的日期
                    NSString *dateTimeString =[TimeObj  stringFromReceivedDate:myreceiveOBJ.deadline withDateFormat:@"yyyy-MM-dd"];
                    [_dateMutableArray addObject:dateTimeString];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //遍历数组得到本月回款数组 标记多个btn
                    weakCustomCalendarView.markedDateArray = _dateMutableArray;
                    [weakCustomCalendarView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    if (isFirst) {
                        [weakCustomCalendarView setNeedsDisplay];
                    }
                    // [weakCustomCalendarView setNeedsDisplay];
                    else{
                        [UIView transitionWithView:weakCustomCalendarView
                                          duration:0.5f
                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                        animations:^ { [weakCustomCalendarView setNeedsDisplay];
                                        }
                                        completion:nil];
                    }
                    //_customCalendarView.markedDateArray = _dateMutableArray;
                    
                    // [weakCustomCalendarView setNeedsDisplay];
                });
            }
            else
            {
                [[UIApplication sharedApplication].keyWindow makeToast:@"数据传输失败请返回" duration:2.0 position:@"center"];
            }
            
        } withSearchYear:search_year monthString:search_month];
        

    });
    
   
    
    
    
    
}

#pragma mark - CalendarDataSource protocol conformance

-(BOOL)isDataForDate:(NSDate *)date
{
    if ([date compare:[NSDate date]] == NSOrderedAscending)
        return YES;
    return NO;
}

-(BOOL)canSwipeToDate:(NSDate *)date
{
    NSDateComponents * yearComponent = [_gregorian components:NSYearCalendarUnit fromDate:date];
    return (yearComponent.year == _currentYear || yearComponent.year == _currentYear+2 || yearComponent.year-2);
}

#pragma mark --UIPickerViewDatasource--
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{

    return 2;

}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 5;
    }
    return 12;

    
}


#pragma mark --UIPickerViewDelegate----
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{

    return 25;

}




- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
       if (component == 0) {
        NSString *yearString = [_yearArray objectAtIndex:row];
        return yearString;
    }
        NSString *monthString = [_monthArray objectAtIndex:row];
    
    return monthString;
    
    
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

}


#pragma mark - Action methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
