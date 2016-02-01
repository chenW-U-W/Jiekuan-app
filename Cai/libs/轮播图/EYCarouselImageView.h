//
//  EYCarouselImageView.h
//  简单轮播图
//
//  Created by Qianlong Xu on 15-1-7.
//  Copyright (c) 2015年 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYCarouselImageView : UIView

/**
 *  初始化
 *
 *  @param frame frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动
 *
 *  @return instance
 */

- (instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

/**
 *  暂停自动滚动轮播图
 */
- (void)pauseAutoScroll;

/**
 *  开始轮播, 时间间隔默认
 */
- (void)startAutoScroll;

/**
 *  开始自动滚动轮播图
 *
 *  @param timeInterval 轮播时间间隔
 */
- (void)startAutoScrollAfterTimeInterval:(NSTimeInterval)timeInterval;

/**
 *  数据源：获取获取总的contentView,如果少于2个，不自动滚动
 */
@property (nonatomic, copy) NSArray *(^EasyBlockGetContentArr)(void);

///
/**
 *  Block回调点击的视图；
 */
@property (nonatomic, copy) void (^EasyBlockRevokeClickedView)(UIView *clickedView);

///
/**
 *  Block回调当前显示的视图；
 */
@property (nonatomic, copy) void (^EasyBlockRevokeShowView)(UIView *clickedView,NSUInteger idx);

@end
