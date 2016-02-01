

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]


#import <UIKit/UIKit.h>
@class CalendarButton;
typedef NSString *(^YearAndMontTapBlock)(NSString *year,NSString *month);//点击年月日期
typedef NSMutableArray *(^MarkedMonthBlock)(NSDate *) ;
@protocol CalendarDelegate;
@protocol CalendarDataSource;


@interface CalendarView : UIView

-(void)showNextMonth;
-(void)showPreviousMonth;

-(void)showPcikedMonth:(NSDate *)pickedDate;//点击picker显示日历
- (void)markDateLabel:(NSArray *)array withButton:(CalendarButton *)button withDate:(NSDate *)date;//标记日历上的应还日期

-(void)drawNewRecWithMarkedArray:(NSMutableArray*)mutableArray;

@property (nonatomic,strong) NSDate *calendarDate;
@property (nonatomic,weak) id<CalendarDelegate> delegate;
@property (nonatomic,weak) id<CalendarDataSource> datasource;


//是否弹出datepicker
@property (nonatomic, assign) BOOL isShowDatePicker;

// Font
@property (nonatomic, strong) UIFont * defaultFont;
@property (nonatomic, strong) UIFont * titleFont;

// Text color for month and weekday labels
@property (nonatomic, strong) UIColor * monthAndDayTextColor;

// Border
@property (nonatomic, strong) UIColor * borderColor;
@property (nonatomic, assign) NSInteger borderWidth;

// Button color
@property (nonatomic, strong) UIColor * dayBgColorWithoutData;
@property (nonatomic, strong) UIColor * dayBgColorWithData;
@property (nonatomic, strong) UIColor * dayBgColorSelected;
@property (nonatomic, strong) UIColor * dayTxtColorWithoutData;
@property (nonatomic, strong) UIColor * dayTxtColorWithData;
@property (nonatomic, strong) UIColor * dayTxtColorSelected;//白色

// Allows or disallows the user to change month when tapping a day button from another month
@property (nonatomic, assign) BOOL allowsChangeMonthByDayTap;
@property (nonatomic, assign) BOOL allowsChangeMonthBySwipe;
@property (nonatomic, assign) BOOL allowsChangeMonthByButtons;

//是否是第一次进入日历（第一次进入相当于选择了一个日期）
@property (nonatomic, assign) BOOL isFirstEntered;

// origin of the calendar Array
@property (nonatomic, assign) NSInteger originX;
@property (nonatomic, assign) NSInteger originY;

// "Change month" animations
@property (nonatomic, assign) UIViewAnimationOptions nextMonthAnimation;
@property (nonatomic, assign) UIViewAnimationOptions prevMonthAnimation;

// Miscellaneous
@property (nonatomic, assign) BOOL keepSelDayWhenMonthChange;
@property (nonatomic, assign) BOOL hideMonthLabel;

@property (nonatomic, strong) NSMutableArray *markedDateArray;


//block
@property (nonatomic, strong) YearAndMontTapBlock tapBlock;
@property (nonatomic, strong) MarkedMonthBlock markMothBlcok;


@end



@protocol CalendarDelegate <NSObject>

-(void)dayChangedToDate:(NSDate *)selectedDate;//点击日期按钮触发代理方法
-(void)MonthChangedToMonth:(NSDate *)selectedMonth isFirstEnter:(BOOL)isFirst;//月份变化时触发
@optional
-(void)setHeightNeeded:(NSInteger)heightNeeded;
-(void)setMonthLabel:(NSString *)monthLabel;//添加上日期label后就触发代理方法 （改变日期标题)
-(void)setEnabledForPrevMonthButton:(BOOL)enablePrev nextMonthButton:(BOOL)enableNext;


//如果只是通知vc改变就可以直接用代理，如果vc执行代理后还需回调通知v那么block比较合适
//-(void)presentDatePicker;

@end



@protocol CalendarDataSource <NSObject>

-(BOOL)isDataForDate:(NSDate *)date;
-(BOOL)canSwipeToDate:(NSDate *)date;

@end// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com