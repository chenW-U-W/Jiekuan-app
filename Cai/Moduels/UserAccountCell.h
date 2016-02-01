//
//  UserAccountCell.h
//  Cai
//
//  Created by 启竹科技 on 15/4/15.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;
@interface UserAccountCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (strong, nonatomic) User *user;
@property (strong,nonatomic) NSMutableArray *userArray;
@end
