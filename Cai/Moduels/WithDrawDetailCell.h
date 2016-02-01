//
//  WithDrawDetailCell.h
//  Cai
//
//  Created by 启竹科技 on 15/4/15.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TransactionObj;
@interface WithDrawDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *record_collect_money;//待收金额
@property (strong, nonatomic) IBOutlet UILabel *recordTypeLabel;//类型
@property (strong, nonatomic) IBOutlet UILabel *recordTimeLabel;//发生时间
@property (strong, nonatomic) IBOutlet UILabel *recordAccountLabel;//影响金额
@property (strong, nonatomic) TransactionObj *recordProduct;// 交易记录model
@end
