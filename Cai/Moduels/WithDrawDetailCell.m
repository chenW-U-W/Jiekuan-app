//
//  WithDrawDetailCell.m
//  Cai
//
//  Created by 启竹科技 on 15/4/15.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "WithDrawDetailCell.h"
#import "TransactionObj.h"
@implementation WithDrawDetailCell

- (void)awakeFromNib {
      
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
}

- (void)setRecordProduct:(TransactionObj *)recordProduct
{
    _recordAccountLabel.text = [NSString stringWithFormat:@"%.2f",recordProduct.affect_money ];
    _recordTypeLabel.text = recordProduct.type;
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString  = [dateFormater stringFromDate:recordProduct.date];    
    
    _recordTimeLabel.text = recordProduct.dateString;
    _record_collect_money.text = [NSString stringWithFormat:@"待收%.2f",recordProduct.collect_money];
    _recordAccountLabel.textColor = [UIColor blackColor];
    if (recordProduct.affect_money>0) {
        _recordAccountLabel.textColor = UIColorFromRGB(0xf39700);
        _recordAccountLabel.text = [NSString stringWithFormat:@"+%.2f",recordProduct.affect_money ];
    }
}
@end
