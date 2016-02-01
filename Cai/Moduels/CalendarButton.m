//
//  CalendarButton.m
//  sampleCalendar
//
//  Created by csj on 15/8/14.
//  Copyright (c) 2015年 Attinad. All rights reserved.
//

#import "CalendarButton.h"

@implementation CalendarButton

- (id)init
{
    self = [super init];
    if (self) {
 [self addSubview:_yangliLabel];

    }
    return self;
}

- (void)setYangliLabel:(UILabel *)ayangliLabel
{

   
    NSInteger width = [UIScreen mainScreen].bounds.size.width/8;
    _yangliLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 28)];
    _yangliLabel.font = [UIFont boldSystemFontOfSize:13];
    _yangliLabel.center = CGPointMake(20, 14);
    _yangliLabel.backgroundColor = [UIColor clearColor];
    _yangliLabel.text = ayangliLabel.text;
    _yangliLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_yangliLabel];
    
}

- (void)setYingliLabel:(UILabel *)yingliLabel
{
    NSInteger width = [UIScreen mainScreen].bounds.size.width/8;
    _yingliLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, width, 18)];
    _yingliLabel.font = [UIFont systemFontOfSize:8];
    _yingliLabel.center = CGPointMake(20, 33);
    _yingliLabel.backgroundColor = [UIColor clearColor];
    _yingliLabel.text = yingliLabel.text;
    _yingliLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_yingliLabel];
}

- (void)setAllViewColor
{

   
}

@end
