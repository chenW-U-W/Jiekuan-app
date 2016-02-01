//
//  ProductCell.h
//  Cai
//
//  Created by 启竹科技 on 15/4/3.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
@class QZProgressView;
@interface ProductCell : UITableViewCell
{
   QZProgressView *QZPView;

}

@property (nonatomic, strong) Product *product;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;//名称
@property (strong, nonatomic) IBOutlet UILabel *paymentMethodLabel;//付息方式
@property (strong, nonatomic) IBOutlet UILabel *annualizedReturnLabel;//收益率
@property (strong, nonatomic) IBOutlet UILabel *termLabel;//期限
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;//规模
@property (nonatomic, assign) int percent;
@property (strong, nonatomic) IBOutlet UIImageView *stateImage;//投标状态
@property (strong, nonatomic) IBOutlet UILabel *bidStateLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *ratioLabel;


@end
