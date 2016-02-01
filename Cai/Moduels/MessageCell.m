//
//  MessageCell.m
//  Cai
//
//  Created by csj on 15/9/10.
//  Copyright (c) 2015年 财来. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)setMessageOBJ:(MessageObj *)messageOBJ
{
    //不能用self.  循环引用
    _messageOBJ = messageOBJ;
    self.titleLabel.text = messageOBJ.title;
    self.contentLabel.text = messageOBJ.content;
    self.dateTimeLabel.text = messageOBJ.send_time;
}

@end
