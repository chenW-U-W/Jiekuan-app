//
//  BindOtherBankCell.h
//  Cai
//
//  Created by 启竹科技 on 15/4/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BankcardsObj;
@interface BindOtherBankCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *bankImageView;
@property (strong, nonatomic) IBOutlet UILabel *bankTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardDetailLabel;
@property (strong, nonatomic) BankcardsObj *bankCardObj;
@end
