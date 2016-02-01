//
//  InterestTableViewCell.m
//  Cai
//
//  Created by 陈思远 on 16/1/26.
//  Copyright © 2016年 财来. All rights reserved.
//

#import "InterestTableViewCell.h"

@implementation InterestTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetailObject:(DetailInterestObj *)detailObject
{
    _detailObject = detailObject;
    
}
@end
