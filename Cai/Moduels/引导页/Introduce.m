//
//  Introduce.m
//  KPM1104
//
//  Created by 启竹科技 on 15/1/6.
//  Copyright (c) 2015年 上海App开发者. All rights reserved.
//

#import "Introduce.h"

@implementation Introduce

- (id)initWithFrame:(CGRect)frame
{
      
      self = [super initWithFrame:frame];
      if(self) {
            
          
          UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
          scrollView.delegate = self;
          scrollView.contentSize = CGSizeMake(3*self.frame.size.width, self.frame.size.height);
          scrollView.bounces=NO;
          scrollView.pagingEnabled = YES;
          scrollView.showsHorizontalScrollIndicator = NO;
          [self addSubview:scrollView];
          
          
            _mutableAttay = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i<3 ; i++) {
                  UIImageView *ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"介绍页%d.jpg",i+1]]];
                  ImageView.frame = CGRectMake(0+i*self.frame.size.width, 0, frame.size.width, frame.size.height);
                  ImageView.userInteractionEnabled = YES;
                [scrollView addSubview:ImageView];
                  [_mutableAttay addObject:ImageView];
                
                if (i == 2) {
                    //进入应用按钮
                    UIButton *GetInBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                    [GetInBtn setShowsTouchWhenHighlighted:NO];
                    [GetInBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                    GetInBtn.tag = 1;
                    CGRect rect = [UIScreen mainScreen].bounds;
                    GetInBtn.frame = CGRectMake(rect.origin.x + 90/ViewWithDevicWidth, rect.size.height - 110, rect.size.width/3, 55/ViewWithDevicHeight);
                    //[GetInBtn setBackgroundColor:[UIColor redColor]];
                    [ImageView addSubview:GetInBtn];
                }
                
                
            }
          
          
          _pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(self.center.x-50,self.frame.size.height-40 , 100, 30)];
          _pageController.numberOfPages = 3;
          [self addSubview:_pageController];
          
      }
      return self;
      
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    NSInteger pageInt = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageController.currentPage = pageInt;
    _pageController.currentPageIndicatorTintColor = [UIColor whiteColor];
    
}

- (void)click:(UIButton *)sender
{
//    [UIView animateWithDuration:1 animations:^{
//       
//    } ];
    [UIView animateWithDuration:1 animations:^{
         [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
       
    }];
    
}


@end
