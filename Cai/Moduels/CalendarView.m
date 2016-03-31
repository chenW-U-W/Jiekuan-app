
#import "CalendarView.h"
#import "CalendarButton.h"
#import "TimeObj.h"
#define ImageViewHight 1

@interface CalendarView()

// Gregorian calendar
@property (nonatomic, strong) NSCalendar *gregorian;

// Selected day
@property (nonatomic, strong) NSDate * selectedDate;

// Width in point of a day button
@property (nonatomic, assign) NSInteger dayWidth;

// NSCalendarUnit for day, month, year and era.
@property (nonatomic, assign) NSCalendarUnit dayInfoUnits;

// Array of label of weekdays
@property (nonatomic, strong) NSArray * weekDayNames;

// View shake
@property (nonatomic, assign) NSInteger shakes;
@property (nonatomic, assign) NSInteger shakeDirection;

// Gesture recognizers
@property (nonatomic, strong) UISwipeGestureRecognizer * swipeleft;
@property (nonatomic, strong) UISwipeGestureRecognizer * swipeRight;

// 日期btn高度
@property (nonatomic,assign) NSInteger buttonHeight;




@end
@implementation CalendarView

#pragma mark - Init methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _dayWidth                   = frame.size.width/8;
        _originX                    = (frame.size.width - 7*_dayWidth)/2;
        _gregorian                  = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        _borderWidth                = 4;
        _originY                    = _dayWidth;
        _buttonHeight               = 30;
        _calendarDate               = [NSDate date];
        _dayInfoUnits               = NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        
        _monthAndDayTextColor       = [UIColor brownColor];
        _dayBgColorWithoutData      = [UIColor whiteColor];
        _dayBgColorWithData         = [UIColor whiteColor];
        _dayBgColorSelected         = [UIColor brownColor];
        
        _dayTxtColorWithoutData     = [UIColor brownColor];;
        _dayTxtColorWithData        = [UIColor brownColor];
        _dayTxtColorSelected        = [UIColor whiteColor];
        
        _borderColor                = [UIColor brownColor];
        _allowsChangeMonthByDayTap  = NO;
        _allowsChangeMonthByButtons = NO;
        _allowsChangeMonthBySwipe   = YES;
        _hideMonthLabel             = NO;
        _keepSelDayWhenMonthChange  = NO;
        
        _nextMonthAnimation         = UIViewAnimationOptionTransitionCrossDissolve;
        _prevMonthAnimation         = UIViewAnimationOptionTransitionCrossDissolve;
        
        _defaultFont                = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
        _titleFont                  = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
        
        
        
        
        _markedDateArray            = [[NSMutableArray alloc] initWithCapacity:0];
        
        
        
        
        
        _swipeleft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showNextMonth)];
        _swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:_swipeleft];
        _swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showPreviousMonth)];
        _swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:_swipeRight];
        
        NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:[NSDate date]];
        components.hour         = 0;
        components.minute       = 0;
        components.second       = 0;
        
        _selectedDate = [_gregorian dateFromComponents:components];
        
        _weekDayNames = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日",];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.isShowDatePicker = YES;
    }
    return self;
}

-(id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 320, 400)];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - Custom setters


//在此方法中触发代理  1 可以设置标记日期数组  2 可以刷新日历
-(void)setAllowsChangeMonthByButtons:(BOOL)allows
{
    _allowsChangeMonthByButtons = allows;
    if (_delegate && [_delegate respondsToSelector:@selector(MonthChangedToMonth:isFirstEnter:)]) {
        [_delegate MonthChangedToMonth:[NSDate date] isFirstEnter:YES];
        [self setNeedsDisplay];
    }
    
}

-(void)setAllowsChangeMonthBySwipe:(BOOL)allows
{
    _allowsChangeMonthBySwipe   = allows;
    _swipeleft.enabled          = allows;
    _swipeRight.enabled         = allows;
}



-(void)setHideMonthLabel:(BOOL)hideMonthLabel
{
    _hideMonthLabel = hideMonthLabel;
    [self setNeedsDisplay];
}

-(void)setSelectedDate:(NSDate *)selectedDate
{
    _selectedDate = selectedDate;
    [self setNeedsDisplay];
}

-(void)setCalendarDate:(NSDate *)calendarDate
{
    _calendarDate = calendarDate;
    [self setNeedsDisplay];
}




//应还日期的每个月的标记
-(void)markDateLabel:(NSArray *)array withButton:(CalendarButton *)abutton withDate:(NSDate *)adate
{
    int i = 0;
    
    for (NSString *string in array) {
        i = i+1;
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        formate.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [formate dateFromString:string];
        NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:date];
        
        
        UIButton *button = (UIButton *)[self viewWithTag:[self buttonTagForDate:date]];//[self buttonTagForDate:date]
        
        NSDateComponents *calendarCompents = [_gregorian components:_dayInfoUnits fromDate:adate];
        if (components.year == calendarCompents.year && components.month == calendarCompents.month ) {
            //标记btn
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.origin.x,button.frame.origin.y , button.frame.size.width, button.frame.size.height)];
            imageView.image = [UIImage imageNamed:@"圆"];
            //imageView.backgroundColor = [UIColor greenColor];
            [self addSubview:imageView];
            
        }
        
    }
    

}


#pragma mark - Public methods

-(void)showNextMonth
{
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    components.day = 1;
    components.month ++;
    NSDate * nextMonthDate =[_gregorian dateFromComponents:components];
    
    if ([self canSwipeToDate:nextMonthDate])
    {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _calendarDate = nextMonthDate;
        components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
        
        if (!_keepSelDayWhenMonthChange)
        {
            _selectedDate = [_gregorian dateFromComponents:components];
        }
        [self performViewAnimation:_nextMonthAnimation];
    }
    else
    {
        [self performViewNoSwipeAnimation];
    }
}


-(void)showPreviousMonth
{
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    components.day = 1;
    components.month --;
    NSDate * prevMonthDate = [_gregorian dateFromComponents:components];
    
    if ([self canSwipeToDate:prevMonthDate])
    {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _calendarDate = prevMonthDate;
        components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
        
        if (!_keepSelDayWhenMonthChange)
        {
            _selectedDate = [_gregorian dateFromComponents:components];
        }
        [self performViewAnimation:_prevMonthAnimation];
    }
    else
    {
        [self performViewNoSwipeAnimation];
    }
}

//点击pcikerView上的日期
-(void)showPcikedMonth:(NSDate *)pickedDate
{
    
    if ([self canSwipeToDate:pickedDate])
    {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _calendarDate = pickedDate;
        NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
        
        if (!_keepSelDayWhenMonthChange)
        {
            _selectedDate = [_gregorian dateFromComponents:components];
        }
        [self performViewAnimation:_prevMonthAnimation];
    }
    else
    {
        [self performViewNoSwipeAnimation];
    }

}

#pragma mark - Various methods


-(NSInteger)buttonTagForDate:(NSDate *)date
{
    NSDateComponents * componentsDate       = [_gregorian components:_dayInfoUnits fromDate:date];
    NSDateComponents * componentsDateCal    = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    
    if (componentsDate.month == componentsDateCal.month && componentsDate.year == componentsDateCal.year)
    {
        // Both dates are within the same month : buttonTag = day
        return componentsDate.day;
    }
    else
    {
        //  buttonTag = deltaMonth * 40 + day
        NSInteger offsetMonth =  (componentsDate.year - componentsDateCal.year)*12 + (componentsDate.month - componentsDateCal.month);
        return componentsDate.day + offsetMonth*40;
    }
}

-(BOOL)canSwipeToDate:(NSDate *)date
{
    if (_datasource == nil)
        return YES;
    return [_datasource canSwipeToDate:date];
}

//
-(void)performViewAnimation:(UIViewAnimationOptions)animation
{
    NSDateComponents * components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    NSDate *clickedMonthDate = [_gregorian dateFromComponents:components];
    [_delegate MonthChangedToMonth:clickedMonthDate isFirstEnter:NO];
    
    [UIView transitionWithView:self
                      duration:0.5f
                       options:animation
                    animations:^ {
                        _selectedDate = [NSDate date];
                        [self setNeedsDisplay];
                    }
                    completion:nil];
}



-(void)performViewNoSwipeAnimation
{
    _shakeDirection = 1;
    _shakes = 0;
    [self shakeView:self];
}



-(void)shakeView:(UIView *)theOneYouWannaShake
{
    //theOneYouWannaShake.backgroundColor = [UIColor redColor];
    [UIView animateWithDuration:0.05 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*_shakeDirection, 0);
         
     } completion:^(BOOL finished)
     {
         if(_shakes >= 4)
         {
             theOneYouWannaShake.transform = CGAffineTransformIdentity;
             return;
         }
         _shakes++;
         _shakeDirection = _shakeDirection * -1;
         [self shakeView:theOneYouWannaShake];
     }];
}



#pragma mark - Button creation and configuration

-(CalendarButton *)dayButtonWithFrame:(CGRect)frame
{
    
    CalendarButton *button          = [[CalendarButton alloc] init];
    //button.buttonType               = UIButtonTypeSystem;
   // button.titleLabel.font          = _defaultFont;
    button.frame                    = frame;
    button.layer.borderColor        = _borderColor.CGColor;
    [button     addTarget:self action:@selector(tappedDate:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}



-(void)configureDayButton:(CalendarButton *)button withDate:(NSDate*)date
{
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:date];
    
    NSString *yingliDate = [self LunarForSolarYear:components.year Month:components.month Day:components.day];
    NSString *yangliDate = [NSString stringWithFormat:@"%ld",(long)components.day];
   
    
    UILabel *yingliLabel = [[UILabel alloc] init];
    yingliLabel.text = yingliDate;
    UILabel *yangliLabel = [[UILabel alloc] init];
    yangliLabel.text = yangliDate;
    button.yangliLabel = yangliLabel;
    button.yingliLabel = yingliLabel;
    

    button.tag = [self buttonTagForDate:date];
    //选中按钮时的颜色
    NSString *selecedDateString = [TimeObj stringFromReceivedDate:_selectedDate withDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [TimeObj stringFromReceivedDate:date withDateFormat:@"yyyy-MM-dd"];
    
    if([selecedDateString compare:dateString] == NSOrderedSame)
    {
        // Selected button
        button.layer.borderWidth = 0;
        [button setTitleColor:_dayTxtColorSelected forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:1 green:0.45 blue:0 alpha:1]];
        button.layer.cornerRadius = _dayWidth/2.0;
    }
    else
    {
        //未被选中但是在本月内的颜色(之前被选中的)
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];

    }

   
}



#pragma mark - Action methods

-(void)tappedDate:(CalendarButton *)sender
{
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    
    //--------------------------------------------------------------------
    NSDateComponents * componentsDateSel = [_gregorian components:_dayInfoUnits fromDate:_selectedDate];
    if(componentsDateSel.day != sender.tag || componentsDateSel.month != components.month || componentsDateSel.year != components.year)
    {
        // 老的被选中的日期
        NSDate * oldSelectedDate = [_selectedDate copy];
        
        // 新被选中的日期
        componentsDateSel.day       = sender.tag;
        componentsDateSel.month     = components.month;
        componentsDateSel.year      = components.year;
        _selectedDate               = [_gregorian dateFromComponents:componentsDateSel];
        
        // 重新配置日期btn
        [self configureDayButton:sender      withDate:_selectedDate];
        
        // 获取老的日期btn
        CalendarButton *previousSelected =(CalendarButton *) [self viewWithTag:[self buttonTagForDate:oldSelectedDate]];
        // 重新配置之前被选中的btn
        if (previousSelected)
            [self configureDayButton:previousSelected   withDate:oldSelectedDate];
        
        // 代理通知
        [_delegate dayChangedToDate:_selectedDate];
    }
}


//-----------根据需求改变-----------
- (void)yearAndMothTap
{
    NSDate *date = [NSDate date];
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:date];
    NSString *yearString = [NSString stringWithFormat:@"%ld",components.year];
    NSString *monthString = [NSString stringWithFormat:@"%ld",components.month];
    if (_isShowDatePicker) {
        if (_tapBlock) {
            self.tapBlock(yearString,monthString);
        }
        _isShowDatePicker = NO;

    }
    
}



#pragma mark - Drawing methods

- (void)drawRect:(CGRect)rect
{
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    components.day = 1;//设置天为 1   -----------
    NSDate *firstDayOfMonth  = [_gregorian dateFromComponents:components];//本月第一周
    NSDateComponents *comps  = [_gregorian components:NSWeekdayCalendarUnit fromDate:firstDayOfMonth];//iOS中规定的就是周日为1，周一为2，周二为3，周三为4，周四为5，周五为6，周六为7，无法通过某个设置改变这个事实的
    
   //------------------------------不明白-----------------------------------//
    NSInteger weekdayBeginning  = [comps weekday];  // Starts at 1 on Sunday
    
    weekdayBeginning -=2;
    // [_gregorian setFirstWeekday:2]; 一把都是这样设置起始日期  ，但是现在这种方法不明觉厉啊。   weekdayBeginning- = 1 为这个月第一天从周几开始，-=2 为这个月第一天与这个月第一周的第一天相差的天数
    
    if(weekdayBeginning < 0)
        weekdayBeginning += 7;                          // Starts now at 0 on Monday
    //---------------------------------------------------------------------//
                       // Starts now at 0 on Monday
    
    
    
    
    NSRange days = [_gregorian rangeOfUnit:NSDayCalendarUnit
                                    inUnit:NSMonthCalendarUnit
                                   forDate:_calendarDate];//这个月有多少天
    NSInteger monthLength = days.length;
    NSInteger remainingDays = (monthLength + weekdayBeginning) % 7;
    
    
    // Frame drawing
    NSInteger minY = _originY + _dayWidth;//最小高度
    NSInteger maxY = _originY + _dayWidth * (NSInteger)(1+(monthLength+weekdayBeginning)/7) + ((remainingDays !=0)? _dayWidth:0);//最大高度// +1是要+最小高度，起初有个最小高度
    //计算有几行
    NSInteger lineCount = ((monthLength+weekdayBeginning)%7 ==0)?((monthLength+weekdayBeginning)/7 ):((monthLength+weekdayBeginning)/7 +1) ;
    //划线（有几行划+1行）
    
    //线条
    for (int i = 0; i<=lineCount; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"形状-18"]];
        imageView.frame = CGRectMake(_originX, 5+2*_buttonHeight+i*_dayWidth+i*ImageViewHight, 320, ImageViewHight);
        [self addSubview:imageView];
    }

    
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(setHeightNeeded:)])
        [_delegate setHeightNeeded:maxY];
    

    
    BOOL enableNext = YES;
    BOOL enablePrev = YES;
    
    // Previous and next button
    UIButton * buttonPrev  = [[UIButton alloc] initWithFrame:CGRectMake(60/ViewWithDevicWidth, 0, _dayWidth, _buttonHeight)];
    [buttonPrev setBackgroundImage:[UIImage imageNamed:@"上个月"] forState:UIControlStateNormal];
    [buttonPrev addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
    buttonPrev.titleLabel.font  = _defaultFont;
    [self addSubview:buttonPrev];
    
    
    UIButton * buttonNext          = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width -60/ViewWithDevicWidth-_dayWidth , 0, _dayWidth, _buttonHeight)];
    [buttonNext setBackgroundImage:[UIImage imageNamed:@"下个月"] forState:UIControlStateNormal];
    [buttonNext addTarget:self action:@selector(showNextMonth) forControlEvents:UIControlEventTouchUpInside];
    buttonNext.titleLabel.font          = _defaultFont;
    [self addSubview:buttonNext];
    
    
   
    NSDateComponents *componentsTmp = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    componentsTmp.day = 1;
    componentsTmp.month --;
    NSDate * prevMonthDate =[_gregorian dateFromComponents:componentsTmp];
    if (![self canSwipeToDate:prevMonthDate])
    {
        buttonPrev.alpha    = 0.5f;
        buttonPrev.enabled  = NO;
        enablePrev          = NO;
    }
    
    
    componentsTmp.month +=2;
    NSDate * nextMonthDate =[_gregorian dateFromComponents:componentsTmp];
    if (![self canSwipeToDate:nextMonthDate])
    {
        buttonNext.alpha    = 0.5f;
        buttonNext.enabled  = NO;
        enableNext          = NO;
    }
    
    
    if (!_allowsChangeMonthByButtons)
    {
        buttonNext.hidden = YES;
        buttonPrev.hidden = YES;
    }
    
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(setEnabledForPrevMonthButton:nextMonthButton:)])
    {
        [_delegate setEnabledForPrevMonthButton:enablePrev nextMonthButton:enableNext];
    }
    
    
    
    // Month label
    NSDateFormatter *format         = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy MMMM"];
    NSString *dateString            = [[format stringFromDate:_calendarDate] uppercaseString];
    
    if (!_hideMonthLabel)
    {
        UILabel *titleText              = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.origin.x+120, 0, self.bounds.size.width-240, _buttonHeight)];
        titleText.backgroundColor = [UIColor clearColor];
        titleText.textAlignment         = NSTextAlignmentCenter;
        titleText.text                  = dateString;
        titleText.font                  = _titleFont;
        titleText.textColor             = _monthAndDayTextColor;
        titleText.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yearAndMothTap)];
        [titleText addGestureRecognizer:tapgesture];
        [self addSubview:titleText];
    }
    
    
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(setMonthLabel:)])
        [_delegate setMonthLabel:dateString];
    
    // Day labels
    __block CGRect frameWeekLabel = CGRectMake(0, _buttonHeight+5, _dayWidth, _buttonHeight-10);
    [_weekDayNames  enumerateObjectsUsingBlock:^(NSString * dayOfWeekString, NSUInteger idx, BOOL *stop)
     {
         frameWeekLabel.origin.x         = _originX+(_dayWidth*idx);
         UILabel *weekNameLabel          = [[UILabel alloc] initWithFrame:frameWeekLabel];
         weekNameLabel.text              = dayOfWeekString;
         weekNameLabel.textColor         = _monthAndDayTextColor;
         weekNameLabel.font              = _defaultFont;
         weekNameLabel.backgroundColor   = [UIColor clearColor];
         weekNameLabel.textAlignment     = NSTextAlignmentCenter;
         [self addSubview:weekNameLabel];
     }];
    
    // Current month
    
    for (NSInteger i= 0; i<monthLength; i++)//必须是<= 要不然
    {
        
        components.day      = i+1;
        NSInteger offsetX   = (_dayWidth*((i+weekdayBeginning)%7));
        NSInteger offsetY   = (_dayWidth *((i+weekdayBeginning)/7));
        NSInteger offsetWithImageY = (ImageViewHight *(((i+weekdayBeginning)/7)+1));
        CalendarButton *button    = [self dayButtonWithFrame:CGRectMake(_originX+offsetX, _buttonHeight+5+_buttonHeight +offsetY +offsetWithImageY, _dayWidth, _dayWidth)];
        [self configureDayButton:button withDate:[_gregorian dateFromComponents:components]];
        [self addSubview:button];
        [self markDateLabel:_markedDateArray withButton:button withDate:_calendarDate];
        
    }
    
    
    
    
    
    
    /*
    // Previous month
    NSDateComponents *previousMonthComponents = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    previousMonthComponents.month --;
    NSDate *previousMonthDate = [_gregorian dateFromComponents:previousMonthComponents];
    NSRange previousMonthDays = [_gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:previousMonthDate];
    NSInteger maxDate = previousMonthDays.length - weekdayBeginning;
    for (int i=0; i<weekdayBeginning; i++)
    {
        //NSInteger offsetWithImageY = (ImageViewHight *(((i+weekdayBeginning)/7)+1));
        previousMonthComponents.day     = maxDate+i+1;
        NSInteger offsetX               = (_dayWidth*(i%7));
        NSInteger offsetY               = (_dayWidth *(i/7));
        CalendarButton *button                = [self dayButtonWithFrame:CGRectMake(_originX+offsetX, _originY + _dayWidth + offsetY+ImageViewHight , _dayWidth, _dayWidth)];

        [self configureDayButton:button withDate:[_gregorian dateFromComponents:previousMonthComponents]];
       // [self addSubview:button];
    }
    
    // Next month
    if(remainingDays == 0)
        return ;
    
    NSDateComponents *nextMonthComponents = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    nextMonthComponents.month ++;
    
    for (NSInteger i=remainingDays; i<7; i++)
    {
        NSInteger offsetWithImageY = (ImageViewHight *(((monthLength+weekdayBeginning)/7)+1));
        nextMonthComponents.day         = (i+1)-remainingDays;
        NSInteger offsetX               = (_dayWidth*((i) %7));
        NSInteger offsetY               = (_dayWidth *((monthLength+weekdayBeginning)/7));
        CalendarButton *button                = [self dayButtonWithFrame:CGRectMake(_originX+offsetX, _originY + _dayWidth + offsetY+offsetWithImageY, _dayWidth, _dayWidth)];

        [self configureDayButton:button withDate:[_gregorian dateFromComponents:nextMonthComponents]];
      //  [self addSubview:button];
    }
     */
}


-(NSString *)LunarForSolarYear:(int)wCurYear Month:(int)wCurMonth Day:(int)wCurDay{
    
    
    
    //农历日期名
    NSArray *cDayName =  [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                          @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                          @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    //农历月份名
    NSArray *cMonName =  [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
    
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static int nTheDate,nIsEnd,m,k,n,i,nBit;
    
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1)
    {
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
    
    
//    //生成农历月
//    NSString *szNongliMonth;
//    if (wCurMonth < 1){
//        szNongliMonth = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
//    }else{
//        szNongliMonth = (NSString *)[cMonName objectAtIndex:wCurMonth];
//    }
    
    //生成农历日
    NSString *szNongliDay = [cDayName objectAtIndex:wCurDay];
    
    //合并
   // NSString *lunarDate = [NSString stringWithFormat:@"%@-%@",szNongliMonth,szNongliDay];
    
    return szNongliDay;
}



@end
