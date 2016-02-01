//
//  ProductCell.m
//  Cai
//
//  Created by 启竹科技 on 15/4/3.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "ProductCell.h"
//#import "QZProgressView.h"
@implementation ProductCell


- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)setProduct:(Product *)product
{
    _nameLabel.text = product.bname;
    _paymentMethodLabel.text = product.borrow_type;
    _annualizedReturnLabel.text = [NSString stringWithFormat:@"%.1f%%", product.interest_rate];
    _termLabel.text = [NSString stringWithFormat:@"%d个月", product.borrow_duration];
    _amountLabel.text = [NSString stringWithFormat:@"%.2f万", product.borrow_money/10000];
    self.percent = product.ratio;
//    if (_percent < 100) {
//        //_stateImage.image = [UIImage imageNamed:@"列表图标橙色"];
//        //_bidStateLabel.text = @"投标";
//    }else
//    {
//    
//        //_stateImage.image = [UIImage imageNamed:@"列表图标灰色"];
//       // _bidStateLabel.text = @"满标";
//    
//    }
   NSString *text = product.borrow_status;
    if ([text isEqualToString:@"还款中"]) {
        _stateImage.image = [UIImage imageNamed:@"payment"];
    }
    else if([text isEqualToString:@"复审中"])
    {
        _stateImage.image = [UIImage imageNamed:@"review"];
    }
    else if([text isEqualToString:@"已完成"])
    {
        _stateImage.image = [UIImage imageNamed:@"complete"];
    }
    else if([text isEqualToString:@"立即投标"])
    {
        _stateImage.image = [UIImage imageNamed:@"bid_now"];
    }

}

//设置自定义的progressView
- (void)setPercent:(int)percent
{
    
    _percent = percent;
    _progressView.progressTintColor = NORMALCOLOR;
    _progressView.progress = percent/100.0;
    _ratioLabel.text = [NSString stringWithFormat:@"%d%%",percent];
           
}



@end
