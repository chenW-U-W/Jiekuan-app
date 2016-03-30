//
//  MessageDetailViewController.h
//  Cai
//
//  Created by csj on 15/9/10.
//  Copyright (c) 2015年 财来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageObj.h"
typedef void(^ReturnBackBlock) (void);
@interface MessageDetailViewController : UIViewController
@property(nonatomic,strong)MessageObj *messageObj;
@property(nonatomic,strong)ReturnBackBlock returnBackB;
@end
