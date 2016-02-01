//
//  QZProgressView.m
//  Cai
//
//  Created by 启竹科技 on 15/4/17.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "QZProgressView.h"

@implementation QZProgressView

- (id)initWithFrame:(CGRect)frame{
      self = [super initWithFrame:frame];
      if (self) {
            self.backgroundColor = [UIColor clearColor];
            _isIntroduction = NO;
            _width = 0;
      }
      
      return self;
}

- (void)setPercent:(int)percent{
      _percent = percent;
      
}
- (void)setIsIntroduction:(BOOL)isIntroduction
{
      if (isIntroduction) {
            _isIntroduction = isIntroduction;
      }
      [self setNeedsDisplay];

}

- (void)drawRect:(CGRect)rect{
      [self addArcBackColor];//画normalcolor
      [self drawArc];//画 布局
     // [self addCenterBack];
      //[self addCenterLabel];

}
//圆环背景色
- (void)addArcBackColor{
    if ( _percent/100.0 > 1) {
        return;
    }
    //      [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1]
    
    float realEndAngle = (_percent>25)?((_percent-25.0)/25.0)*M_PI_2:_percent/25.0*M_PI_2-M_PI_2;
    float  endAngle=   realEndAngle;
    float  beginAngle=  -0.5*M_PI;
    int clockwise = 0;
    CGColorRef color = NORMALCOLOR.CGColor;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    // Draw the slices.
    CGFloat radius = viewSize.width / 2;
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius,beginAngle,endAngle, clockwise);
    
    CGContextSetFillColorWithColor(contextRef, color);
    CGContextFillPath(contextRef);

    
    }

- (void)drawArc{
              _rateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RateImageViewWidth, RateImageViewHeight)];
    
    
                [self addSubview:_rateImageView];
    
    
    
                _yujiRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_rateImageView.frame.origin.x +40/ViewWithDevicWidth, _rateImageView.frame.origin.y+40/ViewWithDevicHeight, _rateImageView.frame.size.width - 2*40/ViewWithDevicWidth, 20/ViewWithDevicHeight)];
                [self addSubview:_yujiRateLabel];
    
                _rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_rateImageView.frame.origin.x, _yujiRateLabel.frame.origin.y + 25/ViewWithDevicHeight, _rateImageView.frame.size.width, _rateImageView.frame.size.height/3.5)];
                [self addSubview:_rateLabel];
    
                _rongzhiLabel  = [[UILabel alloc] initWithFrame:CGRectMake(_rateLabel.frame.origin.x, _rateLabel.frame.origin.y+7/ViewWithDevicHeight+_rateLabel.frame.size.height, _rateLabel.frame.size.width, 20/ViewWithDevicHeight)];
                [self addSubview:_rongzhiLabel];

          _rateImageView.image = [UIImage imageNamed:@"remend_circle"];
          _rateImageView.layer.cornerRadius = RateImageViewWidth/2.0;
          _rateImageView.clipsToBounds = YES;
    
          _yujiRateLabel.text = @"收益率";
          _yujiRateLabel.font = [UIFont systemFontOfSize:12];
          _yujiRateLabel.textColor = [UIColor blackColor];
          _yujiRateLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
          _rateLabel.textAlignment = NSTextAlignmentCenter;
         // _rateLabel.backgroundColor = [UIColor redColor];
         // NSString *string = @"12.20%";
        NSString *string =[[ NSString stringWithFormat:@"%.1f",_rate] stringByAppendingString:@"%"];
          DLog(@"NSMakeRange(0, _rateLabel.text.length)----%@",NSStringFromRange(NSMakeRange(0, string.length)));
          //创建 NSMutableAttributedString
          NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString: string];
          //添加属性
          //给所有字符设置字体为Zapfino，字体高度为15像素
          [attributedStr01 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:55]  range: NSMakeRange(0, string.length-1)];
          [attributedStr01 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:15]  range: NSMakeRange(string.length-1, 1)];
          //分段控制，最开始4个字符颜色设置成bai色
          [attributedStr01 addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: NSMakeRange(0, string.length)];
          [attributedStr01 addAttribute:NSBaselineOffsetAttributeName value:@"20" range:NSMakeRange(string.length-1, 1)];
          //赋值给显示控件label01的 attributedText
          _rateLabel.attributedText = attributedStr01;
    
    
    
    
         // NSString *rongziString = @"已投资70%";
        NSString *rongziString =  [NSString stringWithFormat:@"投资进度%d%%",_percent];
          _rongzhiLabel.textAlignment = NSTextAlignmentCenter;
          NSMutableAttributedString *attributedStr02 = [[NSMutableAttributedString alloc] initWithString: rongziString];
          //添加属性
          //给所有字符设置字体为Zapfino，字体高度为15像素
          [attributedStr02 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, rongziString.length)];
          //分段控制，最开始4个字符颜色设置成bai色
          [attributedStr02 addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: NSMakeRange(0, 4)];
          [attributedStr02 addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: NSMakeRange(4, rongziString.length-4)];
          //赋值给显示控件label01的 attributedText
          _rongzhiLabel.attributedText = attributedStr02;

    
}
//中心色
//-(void)addCenterBack{
////      float width = (_isIntroduction == YES) ? 2 : 5;
////      CGColorRef color =(_isIntroduction == YES)?[UIColor whiteColor].CGColor: [UIColor colorWithRed:1 green:0.45 blue:0 alpha:1].CGColor;
////      CGContextRef contextRef = UIGraphicsGetCurrentContext();
////      CGSize viewSize = self.bounds.size;
////      CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
////      // Draw the slices.
////      CGFloat radius = viewSize.width / 2 - width;
////      CGContextBeginPath(contextRef);
////      CGContextMoveToPoint(contextRef, center.x, center.y);
////      CGContextAddArc(contextRef, center.x, center.y, radius,0,2*M_PI, 0);
////      CGContextSetFillColorWithColor(contextRef, color);
////      CGContextFillPath(contextRef);
//    
//    
//}

//添加中心字体
//- (void)addCenterLabel{
//      
//      NSString *percent = @"";
//      
//      float fontSize = 14;
//      UIColor *arcColor = [UIColor blueColor];
//      if (_percent == 1) {
//            percent = @"100%";
//            fontSize = 14;
//            arcColor = (_arcFinishColor == nil) ? [UIColor greenColor] : _arcFinishColor;
//            
//      }else if(_percent < 1 && _percent >= 0){
//            
//            fontSize = 13;
//            arcColor = (_arcUnfinishColor == nil) ? [UIColor blueColor] : _arcUnfinishColor;
//            percent = [NSString stringWithFormat:@"%ld%%",_percent];
//      }
//      
//      CGSize viewSize = self.bounds.size;
//      NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
//      paragraph.alignment = NSTextAlignmentCenter;
//      NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:fontSize],NSFontAttributeName,arcColor,NSForegroundColorAttributeName,[UIColor clearColor],NSBackgroundColorAttributeName,paragraph,NSParagraphStyleAttributeName,nil];
//      
//      [percent drawInRect:CGRectMake(5, (viewSize.height-fontSize)/2, viewSize.width-10, fontSize)withAttributes:attributes];
//}


@end
