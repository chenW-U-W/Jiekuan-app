//
//  AnimationView.h
//  Cai
//
//  Created by csj on 15/8/27.
//  Copyright (c) 2015年 财来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationView : UIView
@property(nonatomic,strong)UIImageView *logoImageView;
@property(nonatomic,strong)UIImageView *circleImageView;
@property(nonatomic,assign)float angle;
@property(nonatomic,assign)BOOL animating;
@property(nonatomic,strong) NSTimer *timer;
-(void)animationedWithCustomViewOption:(UIViewAnimationOptions)options;
-(void)hideLogoView;

+(void)showCustomAnimationViewToView:(UIView *)view;

+(void)hideCustomAnimationViweFromView:(UIView *)view;
@end
