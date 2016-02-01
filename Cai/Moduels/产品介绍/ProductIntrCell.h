//
//  ProductIntrCell.h
//  Cai
//
//  Created by 启竹科技 on 15/4/8.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QZProgressView;
@class ProductDetail;
@interface ProductIntrCell : UITableViewCell

{

      QZProgressView *QZPView;
}
@property (strong, nonatomic) IBOutlet UILabel *canUsedAmount;//可投金额

@property (strong, nonatomic) IBOutlet UILabel *interestLabel;//方式

@property (strong, nonatomic) IBOutlet UILabel *rateLabel;//年利率
@property (strong, nonatomic) IBOutlet UILabel *deadLineLabel;//期限
@property (strong, nonatomic) IBOutlet UILabel *totalNeedAmount;//总金额

@property (strong, nonatomic) IBOutlet UILabel *MortgageRates;
@property (strong, nonatomic) IBOutlet UIImageView *edgeImageView;

@property (nonatomic, strong) ProductDetail *productDetail;

@end
