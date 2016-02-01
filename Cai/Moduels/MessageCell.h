//
//  MessageCell.h
//  Cai
//
//  Created by csj on 15/9/10.
//  Copyright (c) 2015年 财来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageObj.h"
@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property(nonatomic,strong)MessageObj *messageOBJ;
@end
