//
//  CustomTableViewCell.h
//  Cai
//
//  Created by csj on 15/8/18.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic,strong)NSString *titleString;
@property (nonatomic,strong)NSString *interestString;
@property (nonatomic,strong)NSString *status;
@end
