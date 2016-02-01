//
//  EYCarouselImageView.m
//  简单轮播图
//
//  Created by Qianlong Xu on 15-1-7.
//  Copyright (c) 2015年 Demo. All rights reserved.
//

#import "EYCarouselImageView.h"
#import "NSTimer+Util.h"

@interface EYCarouselImageView ()<UIScrollViewDelegate>
{
    CGFloat scrollViewStartContentOffsetX;
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentIdx;
@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, retain) NSMutableArray *contentViewArr;
@property (nonatomic, retain) NSArray *originContentViewArr;
@property (nonatomic, retain) NSTimer *animationTimer;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, retain) UITapGestureRecognizer *recognizer;

@end

@implementation EYCarouselImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3*CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollView:)];
        [self.scrollView addGestureRecognizer:self.recognizer];
        
        [self addSubview:self.scrollView];
        self.currentIdx = 0;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (self) {
        self.animationDuration = animationDuration;
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationDuration target:self selector:@selector(animationTimerDidFired:) userInfo:nil repeats:YES];
//        先暂停；
        [self pauseAutoScroll];
    }
    return self;
}

//获取自视图数组；
- (void)setEasyBlockGetContentArr:(NSArray *(^)(void))EasyBlockGetContentArr
{
    if (EasyBlockGetContentArr) {
        NSArray *viewArr = EasyBlockGetContentArr();
        NSParameterAssert([viewArr isKindOfClass:[NSArray class]]);
        
        if ((self.totalCount = viewArr.count)> 0)
        {
            self.scrollView.scrollEnabled = self.totalCount > 1;
            self.originContentViewArr = [NSArray arrayWithArray:viewArr];
            [self configSubViews];
            [self startAutoScroll];
        }
    }
}

- (void)animationTimerDidFired:(NSTimer *)sender
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

#pragma mark -
#pragma mark - PriviteMethod

- (BOOL)isValidArrayIndex:(NSInteger)index {
    if (index >= 0 && index <= self.totalCount - 1) {
        return YES;
    } else {
        return NO;
    }
}


- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex {
    if(currentPageIndex == -1) {
        return self.totalCount - 1;
    } else if (currentPageIndex == self.totalCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger prevPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentIdx - 1];
    NSInteger nestPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentIdx + 1];
    
    if (!self.contentViewArr) {
        self.contentViewArr = [NSMutableArray array];
    }else{
        [self.contentViewArr removeAllObjects];
    }
    
    id set = (self.totalCount == 1)?[NSSet setWithObjects:@(prevPageIndex),@(self.currentIdx),@(nestPageIndex), nil]:@[@(prevPageIndex),@(self.currentIdx),@(nestPageIndex)];
    for (NSNumber *tempNumber in set) {
        NSInteger tempIndex = [tempNumber integerValue];
        if ([self isValidArrayIndex:tempIndex]) {
            [self.contentViewArr addObject:self.originContentViewArr[tempIndex]];
        }
    }
}

- (void)configSubViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViewArr) {
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
        contentView.frame = rightRect;
        contentView.autoresizingMask = 0xFF;
        contentView.clipsToBounds = YES;
        [self.scrollView addSubview:contentView];
    }
    
    if (self.totalCount > 1) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
}

- (void)tapScrollView:(UITapGestureRecognizer *)sender
{
    if (self.EasyBlockRevokeClickedView) {
        [self pauseAutoScroll];
        self.EasyBlockRevokeClickedView(self.originContentViewArr[self.currentIdx]);
        [self startAutoScroll];
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

//记录位置，停下计时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollViewStartContentOffsetX = scrollView.contentOffset.x;
    [self pauseAutoScroll];
}

//重新启动计时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startAutoScrollAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if (self.totalCount == 2) {
        if (scrollViewStartContentOffsetX < contentOffsetX) {
            UIView *tempView = (UIView *)[self.contentViewArr lastObject];
            tempView.frame = (CGRect){{2 * CGRectGetWidth(scrollView.frame),0},tempView.frame.size};
        } else if (scrollViewStartContentOffsetX > contentOffsetX) {
            UIView *tempView = (UIView *)[self.contentViewArr firstObject];
            tempView.frame = (CGRect){{0,0},tempView.frame.size};
        }
    }
    
    //DLog(@"---scrollViewDidScroll---%g",contentOffsetX);
    
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        
        NSInteger currentIdx = [self getValidNextPageIndexWithPageIndex:self.currentIdx + 1];
        if (currentIdx != self.currentIdx) {
//                    NSLog(@"next，当前页:%ld",currentIdx);
            self.currentIdx = currentIdx;
            if (self.EasyBlockRevokeShowView) {
                self.EasyBlockRevokeShowView(self.originContentViewArr[currentIdx],currentIdx);
            }
            [self configSubViews];
        }
    }else if(contentOffsetX <= 0) {
        NSInteger currentIdx = [self getValidNextPageIndexWithPageIndex:self.currentIdx - 1];
        if (currentIdx != self.currentIdx) {
//                    NSLog(@"previous，当前页:%ld",currentIdx);
            if (self.EasyBlockRevokeShowView) {
                self.EasyBlockRevokeShowView(self.originContentViewArr[currentIdx],currentIdx);
            }
            self.currentIdx = currentIdx;
            [self configSubViews];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
      if (scrollView.contentOffset.x - scrollView.frame.size.width > 0.01) {
            [scrollView setContentOffset:(CGPoint){scrollView.frame.size.width,scrollView.contentOffset.y}];
            DLog(@"scrollViewDidEndScrollingAnimation------");
      }
}


#pragma mark -
#pragma mark - PublicMethod

- (void)pauseAutoScroll
{
    [self.animationTimer pauseTimer];
}

- (void)startAutoScroll
{
    if (self.totalCount > 1) {
        [self startAutoScrollAfterTimeInterval:self.animationDuration];
    }
}

- (void)startAutoScrollAfterTimeInterval:(NSTimeInterval)timeInterval
{
    if (self.totalCount > 1) {
        [self.animationTimer resumeTimerAfterTimeInterval:timeInterval];
    }
}

@end
