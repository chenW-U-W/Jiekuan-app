//
//  ParticularCell.m
//  Cai
//
//  Created by 启竹科技 on 15/4/2.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "ParticularCell.h"
#import "RecommendedObj.h"
#import "QZProgressView.h"

@implementation ParticularCell

- (void)awakeFromNib {
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

      self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
      if (self) {
            
          self.backgroundColor = BACKGROUND_COLOR;
          
            _debitDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(NameImageViewPointX, ViewInterVal, DeviceSizeWidth-2*NameImageViewPointX, debitDetailLabelHeight)];
            [self.contentView addSubview:_debitDetailLabel];
            //_debitDetailLabel.backgroundColor = [UIColor redColor];
          
           rateImageView = [[QZProgressView alloc] initWithFrame:CGRectMake(DeviceSizeWidth/2.0-RateImageViewWidth/2.0, debitDetailLabelHeight+2*ViewInterVal , RateImageViewWidth, RateImageViewHeight)];
          
          [self.contentView addSubview:rateImageView];
          
//          rateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceSizeWidth/2.0-RateImageViewWidth/2.0, debitDetailLabelHeight+2*ViewInterVal , RateImageViewWidth, RateImageViewHeight)];
//
//             
//            [self.contentView addSubview:rateImageView];
//          
//          
//            
//            yujiRatelabel = [[UILabel alloc] initWithFrame:CGRectMake(rateImageView.frame.origin.x +40/ViewWithDevicWidth, rateImageView.frame.origin.y+40/ViewWithDevicHeight, rateImageView.frame.size.width - 2*40/ViewWithDevicWidth, 20/ViewWithDevicHeight)];
//            [self addSubview:yujiRatelabel];
//            
//            _rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(rateImageView.frame.origin.x, yujiRatelabel.frame.origin.y + 25/ViewWithDevicHeight, rateImageView.frame.size.width, rateImageView.frame.size.height/3.5)];
//            [self addSubview:_rateLabel];
//            
//            _rongzhiLabel  = [[UILabel alloc] initWithFrame:CGRectMake(_rateLabel.frame.origin.x, _rateLabel.frame.origin.y+7/ViewWithDevicHeight+_rateLabel.frame.size.height, _rateLabel.frame.size.width, 20/ViewWithDevicHeight)];
//            [self addSubview:_rongzhiLabel];
          
          
          
            _deadlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(LabelWidthInterVal, rateImageView.frame.origin.y + RateImageViewHeight + ViewInterVal, ShortLabelWidth-10/ViewWithDevicWidth, ShortLabelHeight)];
            [self addSubview:_deadlineLabel];
            
            _capitalLabel = [[UILabel alloc] initWithFrame:CGRectMake(1.0*LabelWidthInterVal+ShortLabelWidth, rateImageView.frame.origin.y + RateImageViewHeight + ViewInterVal, ShortLabelWidth-20/ViewWithDevicWidth, ShortLabelHeight)];
            [self addSubview:_capitalLabel];
            
            
            _debitLabel = [[UILabel alloc] initWithFrame:CGRectMake(1*LabelWidthInterVal-5/ViewWithDevicWidth+2*ShortLabelWidth, rateImageView.frame.origin.y + RateImageViewHeight + ViewInterVal, ShortLabelWidth-10/ViewWithDevicWidth, ShortLabelHeight)];
            [self addSubview:_debitLabel];
           
            
            button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(LabelWidthInterVal, _debitLabel.frame.origin.y + ShortLabelHeight + ViewInterVal,261/ViewWithDevicWidth  , 35/ViewWithDevicHeight);
          button.userInteractionEnabled = NO;
            [self addSubview:button];
            
            nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(NameImageViewPointX+30/ViewWithDevicWidth, button.frame.origin.y + ViewInterVal + 40/ViewWithDevicHeight,179/ViewWithDevicWidth ,NameImageViewHeight)];
            [self addSubview:nameImageView];
            
            
           
            
            
      }
      return self;
}

- (void)setRecommendObj:(RecommendedObj *)recommendObj
{
    
   
    
    _recommendObj = recommendObj;
    
    rateImageView.isIntroduction = NO;
    rateImageView.percent = _recommendObj.ratio;
    rateImageView.rate = _recommendObj.interest_rate;
    
      //_debitDetailLabel.text = @"杨女士上海住宅抵押借款110第四标20万";
    NSString *str = _recommendObj.bname;
    _debitDetailLabel.text = str;
      _debitDetailLabel.numberOfLines = 0;
      _debitDetailLabel.lineBreakMode = NSLineBreakByCharWrapping;
      _debitDetailLabel.textAlignment = NSTextAlignmentCenter;
      _debitDetailLabel.font = [UIFont systemFontOfSize:14];
      
//      rateImageView.image = [UIImage imageNamed:@"remend_circle"];
//      rateImageView.layer.cornerRadius = RateImageViewWidth/2.0;
//      rateImageView.clipsToBounds = YES;
//      
//      yujiRatelabel.text = @"收益率";
//      yujiRatelabel.font = [UIFont systemFontOfSize:12];
//      yujiRatelabel.textColor = [UIColor blackColor];
//      yujiRatelabel.textAlignment = NSTextAlignmentCenter;
//      
//      
//
//      _rateLabel.textAlignment = NSTextAlignmentCenter;
//     // _rateLabel.backgroundColor = [UIColor redColor];
//     // NSString *string = @"12.20%";
//    NSString *string =[[ NSString stringWithFormat:@"%.1f", _recommendObj.interest_rate ] stringByAppendingString:@"%"];
//      DLog(@"NSMakeRange(0, _rateLabel.text.length)----%@",NSStringFromRange(NSMakeRange(0, string.length)));
//      //创建 NSMutableAttributedString
//      NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString: string];      
//      //添加属性
//      //给所有字符设置字体为Zapfino，字体高度为15像素
//      [attributedStr01 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:55]  range: NSMakeRange(0, string.length-1)];
//      [attributedStr01 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:14]  range: NSMakeRange(string.length-1, 1)];
//      //分段控制，最开始4个字符颜色设置成bai色
//      [attributedStr01 addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: NSMakeRange(0, string.length)];
//      [attributedStr01 addAttribute:NSBaselineOffsetAttributeName value:@"20" range:NSMakeRange(string.length-1, 1)];
//      //赋值给显示控件label01的 attributedText
//      _rateLabel.attributedText = attributedStr01;
//      
//      
//      
//      
//     // NSString *rongziString = @"已投资70%";
//    NSString *rongziString =  [NSString stringWithFormat:@"投资进度%d%%", _recommendObj.ratio ];
//      _rongzhiLabel.textAlignment = NSTextAlignmentCenter;
//      NSMutableAttributedString *attributedStr02 = [[NSMutableAttributedString alloc] initWithString: rongziString];
//      //添加属性
//      //给所有字符设置字体为Zapfino，字体高度为15像素
//      [attributedStr02 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, rongziString.length)];
//      //分段控制，最开始4个字符颜色设置成bai色
//      [attributedStr02 addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: NSMakeRange(0, 4)];
//      [attributedStr02 addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: NSMakeRange(4, rongziString.length-4)];
//      //赋值给显示控件label01的 attributedText
//      _rongzhiLabel.attributedText = attributedStr02;
    
      
      
      
     // NSString *deadlineLabelString = @"6个月期限";
    NSString *deadlineLabelString = [NSString stringWithFormat:@"%d个月期限", (int)_recommendObj.borrow_duration];
      _deadlineLabel.textAlignment = NSTextAlignmentLeft;
      NSMutableAttributedString *attributedStr03 = [[NSMutableAttributedString alloc] initWithString: deadlineLabelString];
      //添加属性
      //给所有字符设置字体为Zapfino，字体高度为15像素
      [attributedStr03 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, deadlineLabelString.length)];
      //分段控制，最开始4个字符颜色设置成bai色
      if (deadlineLabelString.length >5) {//双位数
            [attributedStr03 addAttribute: NSForegroundColorAttributeName value: UIColorFromRGB(0xffa000) range: NSMakeRange(0, 2)];
            [attributedStr03 addAttribute: NSForegroundColorAttributeName value: UIColorFromRGB(0x000000) range: NSMakeRange(2, deadlineLabelString.length-2)];
      }
      else
      {
      [attributedStr03 addAttribute: NSForegroundColorAttributeName value: UIColorFromRGB(0xffa000) range: NSMakeRange(0, 1)];
            [attributedStr03 addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: NSMakeRange(1, deadlineLabelString.length-1)];
      }
      
      //赋值给显示控件label01的 attributedText
      _deadlineLabel.attributedText = attributedStr03;

      
      
      
      //NSString *capitalString = @"100元起购";
    NSString *capitalString = [NSString stringWithFormat:@"%d元起购",(int)_recommendObj.borrow_min];
      _capitalLabel.textAlignment = NSTextAlignmentLeft;
      //_capitalLabel.backgroundColor = [UIColor redColor];
      NSMutableAttributedString *attributedStr04 = [[NSMutableAttributedString alloc] initWithString: capitalString];

      [attributedStr04 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, capitalString.length)];
      //分段控制，最开始3个字符颜色设置成bai色
      [attributedStr04 addAttribute: NSForegroundColorAttributeName value: UIColorFromRGB(0x000000) range: NSMakeRange(capitalString.length-3, 3)];
      [attributedStr04 addAttribute: NSForegroundColorAttributeName value: UIColorFromRGB(0xffa000) range: NSMakeRange(0, capitalString.length-3)];
      //赋值给显示控件label01的 attributedText
      _capitalLabel.attributedText = attributedStr04;

      
      

     // NSString *debitString = @"借款20万";
     NSString *debitString =[ NSString stringWithFormat:@"借款%.2f万",_recommendObj.borrow_money /10000 ];
      _debitLabel.textAlignment = NSTextAlignmentLeft;
      NSMutableAttributedString *attributedStr05 = [[NSMutableAttributedString alloc] initWithString: debitString];
      [attributedStr05 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, debitString.length)];
      //分段控制，最开始3个字符颜色设置成白色
      [attributedStr05 addAttribute: NSForegroundColorAttributeName value: UIColorFromRGB(0xffa000) range: NSMakeRange(2, debitString.length-3)];
      //赋值给显示控件label01的 attributedText
      _debitLabel.attributedText = attributedStr05;

      
      [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
      [button setTitle:@"立即抢购" forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      button.titleLabel.textAlignment = NSTextAlignmentCenter;
      button.titleLabel.font = [UIFont systemFontOfSize:13];
      [button setBackgroundImage:[UIImage imageNamed:@"圆角矩形按钮"] forState:UIControlStateNormal];
      
      nameImageView.image = [UIImage imageNamed:@"4-1"];
      nameImageView.layer.cornerRadius = 5;
      nameImageView.clipsToBounds  = YES;
    
    [self setNeedsDisplay];
    
    
}

- (void)drawRect:(CGRect)rect
{
    
//    int percent = _recommendObj.ratio;
//    //1  区分产品列表和产品详情   2 区分区间的取值
//    
//    float realEndAngle = (percent>25)?((percent-25.0)/25.0)*M_PI_2:percent/25.0*M_PI_2-M_PI_2;
//    float  endAngle = realEndAngle;
//    float  beginAngle=  -0.5*M_PI;
//    int clockwise = 0;
//    CGColorRef color = NORMALCOLOR.CGColor;
//    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//    CGSize viewSize = self.bounds.size;
//    CGPoint center = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
//    CGFloat radius = rateImageView.frame.size.width / 2.0;
//    CGContextBeginPath(contextRef);
//    CGContextMoveToPoint(contextRef, center.x, center.y);
//    CGContextAddArc(contextRef, center.x, center.y, radius,beginAngle,endAngle, clockwise);
//    CGContextSetFillColorWithColor(contextRef, color);
//    CGContextFillPath(contextRef);

}

-(void)buttonClick
{

      DLog(@"btnclick");
      //发送一个通知 通知精选推荐界面  去购买界面
      [[NSNotificationCenter defaultCenter] postNotificationName:@"purchase" object:self];
    
      
      
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
