//
//  BidRecommendedCell.m
//  Cai
//
//  Created by 启竹科技 on 15/5/20.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "BidRecommendedCell.h"
#import "BidRecommendedObj.h"
@implementation BidRecommendedCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBidRecommendObj:(BidRecommendedObj *)bidRecommendObj
{

    _bidRecommendObj = bidRecommendObj;
    //_chanelLabel.text = bidRecommendObj.invest_channel;
    _investerLabel.text = bidRecommendObj.invest_name;
    _investerLabel.textColor = UIColorFromRGB(0xf39700);
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];//这句话管用  要不然时间少一天
    [dateFormater setLocale:[NSLocale currentLocale]];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormater setTimeZone:localTimeZone];
    NSString *dateString  = [dateFormater stringFromDate: bidRecommendObj.invest_time];
    _investTimeLabel.text =dateString;
    _investAccountLabel.text = [NSString stringWithFormat:@"投资金额:%.0f元",bidRecommendObj.invest_money];
   
   // _investTypeLabel.text = bidRecommendObj.invest_type;
}
@end
