//
//  UserAccountCell.m
//  Cai
//
//  Created by 启竹科技 on 15/4/15.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "UserAccountCell.h"
#import "User.h"
@implementation UserAccountCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(void)setUser:(User *)user
{
    
    _nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserRealName"];
    _telephoneLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserMobile"];

}

@end
