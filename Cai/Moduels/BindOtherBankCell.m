//
//  BindOtherBankCell.m
//  Cai
//
//  Created by 启竹科技 on 15/4/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "BindOtherBankCell.h"
#import "BankcardsObj.h"
#import "UIImageView+WebCache.h"
@implementation BindOtherBankCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBankCardObj:(BankcardsObj *)bankCardObj
{

    [_bankImageView sd_setImageWithURL:[NSURL URLWithString:bankCardObj.bank_icon]];
    _bankTitleLabel.text = bankCardObj.bank_name;   
    if (bankCardObj.bank_number.length>4) {
//        NSRange range = NSMakeRange(bankCardObj.bank_number.length-4, 4);
//        NSString *str = [bankCardObj.bank_number substringWithRange:range];
        NSString *str = bankCardObj.bank_number;
        if (bankCardObj.is_quick) {
             _cardDetailLabel.text = [str stringByAppendingString:@" 快捷卡"];
        }       

    }
    }
@end
