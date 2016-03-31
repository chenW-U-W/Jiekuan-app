//
//  AnimationView.m
//  Cai
//
//  Created by csj on 15/8/27.
//  Copyright (c) 2015年 财来. All rights reserved.
//

#import "AnimationView.h"

@implementation AnimationView

-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        _angle = 0;
        _animating = YES;
        
        self.frame = frame;
        self.layer.cornerRadius = 5.0;        
        self.backgroundColor = [UIColor grayColor];
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 27)];
        _logoImageView.center = CGPointMake(40, 40);
        _logoImageView.image = [UIImage imageNamed:@"logoAnimation"];
        [self addSubview:_logoImageView];
        
        _circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _circleImageView.center = CGPointMake(40, 40);
        _circleImageView.image = [UIImage imageNamed:@"圆Animation"];
        [self addSubview:_circleImageView];
        
        _timer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(runTime:) userInfo:nil repeats:YES];
        NSRunLoop *myrunloop = [NSRunLoop currentRunLoop];
        [myrunloop addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer setFireDate:[NSDate distantFuture]];

    }
    
        return self;
}

-(void)hideLogoView
{
    [_logoImageView removeFromSuperview];
    _logoImageView = nil;
}

- (void)runTime:(NSTimer *)timer
{
    [self animationedWithCustomViewOption:UIViewAnimationOptionCurveLinear];
}

-(void)animationedWithCustomViewOption:(UIViewAnimationOptions)options
{
    _circleImageView.transform = CGAffineTransformRotate(_circleImageView.transform, M_PI / 15);//角度
}

+(void)showCustomAnimationViewToView:(UIView *)view
{
    AnimationView *animationView =  [[self alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    animationView.center = CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0 - 20);
    [view addSubview:animationView];
    [animationView startAnimation];
    [view setUserInteractionEnabled:NO];
}
-(void)startAnimation
{
    [_timer setFireDate:[NSDate date]];
}

+(void)hideCustomAnimationViweFromView:(UIView *)view
{
    AnimationView *animationView = [self animationForView:view];
    if (animationView) {
        [animationView removeFromSuperview];
        [animationView stopAnimation];
    }
    [view setUserInteractionEnabled:YES];

}
-(void)stopAnimation
{
    [_timer setFireDate:[NSDate distantFuture]];
}

+(instancetype)animationForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (AnimationView *)subview;
        }
    }
    return nil;

}
@end
