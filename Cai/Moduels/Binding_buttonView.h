//
//  Binding_buttonView.h
//  Cai
//
//  Created by csj on 15/8/26.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//
typedef void(^buttonClickBlock) (NSInteger);
#import <UIKit/UIKit.h>

@interface Binding_buttonView : UIView
@property(nonatomic,strong)buttonClickBlock buttoncliclBlcok;
@property (weak, nonatomic) IBOutlet UIImageView *bid_buttonImageView;
@property (nonatomic,assign) NSInteger oldTag;
- (IBAction)myBidButtonClick:(id)sender;

@end
