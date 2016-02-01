//
//  ProductIntrCell.m
//  Cai
//
//  Created by 启竹科技 on 15/4/8.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "ProductIntrCell.h"
#import "QZProgressView.h"
#import "ProductDetail.h"
@implementation ProductIntrCell

- (void)awakeFromNib {
      
     }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}



- (void)setProductDetail:(ProductDetail *)productDetail{
    
    _productDetail = productDetail;
    _interestLabel.text = productDetail.repayment_type;    
       NSString *s = _interestLabel.text;
   NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
//    CGSize labelsize = [s boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
//    [_interestLabel setFrame:CGRectMake(_interestLabel.frame.origin.x ,_interestLabel.frame.origin.y, labelsize.width, labelsize.height)];
    //_interestLabel.center = CGPointMake(self.view.frame.center.x, <#CGFloat y#>)
    
    
    _rateLabel.text = [NSString stringWithFormat:@"%.1f", productDetail.interest_rate];
    //_rateLabel.textColor = UIColorFromRGB(0xf39700);
    _deadLineLabel.text = [NSString stringWithFormat:@"%d", productDetail.borrow_duration];
    _totalNeedAmount.text = [NSString stringWithFormat:@"%.2f",productDetail.borrow_money/10000];
     _canUsedAmount.text =[NSString stringWithFormat:@"%.0f",productDetail.can_invest_money];
    //_canUsedAmount.textColor = UIColorFromRGB(0xf39700);
    _MortgageRates.text = [NSString stringWithFormat:@"%.0f",productDetail.MortgageRates];
    
    UIImage *image = [UIImage imageNamed:@"17"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    _edgeImageView.image = image;
//    [_edgeImageView setFrame:CGRectMake(_interestLabel.frame.origin.x-3 ,_interestLabel.frame.origin.y-2, labelsize.width+6, labelsize.height+4)];
    
    

//      if (QZPView) {
//            [QZPView removeFromSuperview];
//      }
//      QZPView = [[QZProgressView alloc] initWithFrame:CGRectMake(216/ViewWithDevicWidth, 24/ViewWithDevicHeight, 94, 94)];
//      QZPView.percent = _productDetail.ratio;
//      QZPView.arcBackColor =[UIColor grayColor];
//      [self addSubview:QZPView];
//      UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 58, 29)];
//      lab.text =  [[NSString stringWithFormat:@"%d",QZPView.percent] stringByAppendingString:@"%"];
//      lab.textColor = [UIColor whiteColor];
//      lab.textAlignment = NSTextAlignmentCenter;
//      lab.font = [UIFont systemFontOfSize:22];
//      [QZPView addSubview:lab];
//      
//      UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(17, lab.frame.origin.y+29+10, 61, 18)];
//      iamgeView.image = [UIImage imageNamed:@"17"];
//      [QZPView addSubview:iamgeView];
//    
//      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(17, lab.frame.origin.y+29+10, 61, 18)];
//      label.text = @"投标进度";
//      label.textAlignment = NSTextAlignmentCenter;
//      label.textColor = [UIColor whiteColor];
//      label.font = [UIFont systemFontOfSize:13];
//      [QZPView addSubview:label];
    
}

@end
