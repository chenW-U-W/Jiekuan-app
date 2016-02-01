//
//  CalendarButton.h
//  sampleCalendar
//
//  Created by csj on 15/8/14.
//  Copyright (c) 2015年 Attinad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarButton : UIButton
@property(nonatomic,strong) UILabel *yingliLabel;
@property(nonatomic,strong) UILabel *yangliLabel;

- (void)setAllViewColor;
@end
