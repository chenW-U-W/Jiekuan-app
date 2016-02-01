//
//  CustomCalendarViewController.h
//  sampleCalendar
//
//  Created by cailai on 21/07/2014.
//  Copyright  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarView.h"
#import "MessageTableViewController.h"

typedef void(^month_releatedTotalBlock) (NSMutableArray *);
@interface CustomCalendarViewController : UIViewController <CalendarDataSource, CalendarDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)MessageTableViewController *messageTVC;
@property(nonatomic,strong)month_releatedTotalBlock month_releatedBlock;

- (void)MonthChangedToMonth:(NSDate *)selectedMonth isFirstEnter:(BOOL)isFirst;
@end
