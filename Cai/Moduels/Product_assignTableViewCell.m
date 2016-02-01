//
//  Product_assignTableViewCell.m
//  Cai
//
//  Created by csj on 15/8/25.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "Product_assignTableViewCell.h"

@implementation Product_assignTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setProduct_assign:(Product_assign *)product_assign
{
    _backGroundView.layer.cornerRadius = 5;
    _nameLabel.text = product_assign.assign_borrow_name;
    _paymentMethodLabel.text = product_assign.assign_repayment_type;
    _annualizedReturnLabel.text = product_assign.assign_interest_rate;
    _termLabel.text =[NSString stringWithFormat:@"%@/%@",product_assign.assign_period,product_assign.assign_total_period];
    _amountLabel.text = product_assign.assign_transfer_price;
    //_bidStateLabel.text = product_assign.assign_status;
    NSString *text = product_assign.assign_status;
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



@end
