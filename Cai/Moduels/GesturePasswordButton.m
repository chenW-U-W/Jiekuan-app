//
//  GesturePasswordButton.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "GesturePasswordButton.h"

#define bounds self.bounds

@implementation GesturePasswordButton
@synthesize selected;
@synthesize success;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        success=YES;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (selected) {
        if (success) {
            CGContextSetRGBStrokeColor(context, 0.941, 0.553, 0.020,1);//线条颜色
            CGContextSetRGBFillColor(context,0.941, 0.553, 0.020,1);
        }
        else {
            CGContextSetRGBStrokeColor(context, 208/255.f, 36/255.f, 36/255.f,1);//线条颜色
            CGContextSetRGBFillColor(context,208/255.f, 36/255.f, 36/255.f,1);//d02424  红色
        }
        CGRect frame = CGRectMake(bounds.size.width/2-bounds.size.width/8+1, bounds.size.height/2-bounds.size.height/8, bounds.size.width/4, bounds.size.height/4);
        
        CGContextAddEllipseInRect(context,frame);
        CGContextFillPath(context);
    }
    else{
        CGContextSetRGBStrokeColor(context, 0.529,0.529,0.529,1);//线条颜色
    }
    
    
    //添加圆圈中的小点
    CGContextSetLineWidth(context,2);
    CGRect frame = CGRectMake(2, 2, bounds.size.width-3, bounds.size.height-3);
    CGContextAddEllipseInRect(context,frame);
    CGContextStrokePath(context);
    if (success) {
        CGContextSetRGBFillColor(context,0.941, 0.553, 0.020,0.3);
    }
    else {
        CGContextSetRGBFillColor(context,208/255.f, 36/255.f, 36/255.f,0.8);
    }
    CGContextAddEllipseInRect(context,frame);
    if (selected) {
        CGContextFillPath(context);
    }
    
}


@end
