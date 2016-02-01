//
//  BidRecommendedCell.h
//  Cai
//
//  Created by 启竹科技 on 15/5/20.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BidRecommendedObj;
#import "BidRecommendedObj.h"
@interface BidRecommendedCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *chanelLabel;//投标来源
@property (strong, nonatomic) IBOutlet UILabel *investerLabel;//投标人
@property (strong, nonatomic) IBOutlet UILabel *investTimeLabel;//投标时间
@property (strong, nonatomic) IBOutlet UILabel *investAccountLabel;//投标金额
@property (strong, nonatomic) IBOutlet UILabel *investTypeLabel;//投标类型
@property (strong, nonatomic) IBOutlet UILabel *yaerRateLabel;
@property (nonatomic,strong) BidRecommendedObj *bidRecommendObj;
@end
