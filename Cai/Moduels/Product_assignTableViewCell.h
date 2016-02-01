//
//  Product_assignTableViewCell.h
//  Cai
//
//  Created by csj on 15/8/25.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product_assign.h"
@interface Product_assignTableViewCell : UITableViewCell
@property (nonatomic, strong) Product_assign *product_assign;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;//名称
@property (strong, nonatomic) IBOutlet UILabel *paymentMethodLabel;//付息方式
@property (strong, nonatomic) IBOutlet UILabel *annualizedReturnLabel;//收益率
@property (strong, nonatomic) IBOutlet UILabel *termLabel;//期数
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;//转让价格
@property (strong, nonatomic) IBOutlet UIImageView *stateImage;//投标状态
@property (strong, nonatomic) IBOutlet UILabel *bidStateLabel;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@end
