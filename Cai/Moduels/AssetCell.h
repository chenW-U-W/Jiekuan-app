//
//  AssetCell.h
//  Cai
//
//  Created by 启竹科技 on 15/4/3.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AssetObj;
typedef void(^clickCellButtonBlock) (NSInteger);
@interface AssetCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *accountLabel;//账户余额


@property (strong, nonatomic) IBOutlet UILabel *totalLabel;//总资产
@property (strong, nonatomic) IBOutlet UILabel *freezeLabel;//冻结金额


@property (strong, nonatomic) IBOutlet UILabel *amountLabel;//待收总额
@property (strong, nonatomic) IBOutlet UILabel *CaptialLabel;//待收利息
@property (strong, nonatomic) AssetObj *assetObj;

@property (nonatomic,strong) clickCellButtonBlock clickCellBTNBlock;
@end
