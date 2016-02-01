//
//  messageView.h
//  Cai
//
//  Created by 启竹科技 on 15/4/10.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messageView : UIView
@property (strong, nonatomic) IBOutlet UILabel *bidMoney;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) NSString *bidString;
@property (strong, nonatomic) NSString *remainedString;
- (IBAction)rechargeFn:(id)sender;
- (IBAction)cancelFn:(id)sender;
+(messageView *)instanceMessageView;
@end
