//
//  CustomTableViewCell.m
//  Cai
//
//  Created by csj on 15/8/18.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)setStatus:(NSString *)status
{
    if (status) {
        _status = status;
        _statusLabel.textColor = [UIColor grayColor];
        _statusLabel.font = [UIFont systemFontOfSize:12];
        _statusLabel.text = status;

    }
    
}
- (void)setInterestString:(NSString *)interestString
{
    if (interestString) {
        _interestString = interestString;
        _interestLabel.textColor = [UIColor grayColor];
        NSMutableAttributedString *attributedStr01 =  [[NSMutableAttributedString  alloc] initWithString:interestString];
        //分段控制，最开始2个字符颜色设置成bai色
        [attributedStr01 addAttribute: NSForegroundColorAttributeName value: [UIColor orangeColor] range: NSMakeRange(4, interestString.length-5)];
        
        _interestLabel.attributedText = attributedStr01;

    }
   }

- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    _titleLabel.text = titleString;
}
@end
