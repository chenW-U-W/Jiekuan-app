//
//  QZProgressView.h
//  Cai
//
//  Created by 启竹科技 on 15/4/17.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZProgressView : UIView
//中心颜色
@property (strong, nonatomic)UIColor *centerColor;
//圆环背景色
@property (strong, nonatomic)UIColor *arcBackColor;
//圆环色
@property (strong, nonatomic)UIColor *arcFinishColor;
@property (strong, nonatomic)UIColor *arcUnfinishColor;


//数值0-100
@property (assign, nonatomic)int percent;


//圆环宽度
@property (assign, nonatomic)float width;
@property (nonatomic,assign) BOOL isIntroduction;

@property (nonatomic,assign) float rate;

@property (nonatomic,strong) UIImageView *rateImageView;//图片
@property (nonatomic,strong) UILabel *yujiRateLabel;
@property (nonatomic,strong) UILabel *rateLabel;
@property (nonatomic,strong) UILabel *rongzhiLabel;

@end
