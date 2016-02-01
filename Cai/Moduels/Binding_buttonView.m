//
//  Binding_buttonView.m
//  Cai
//
//  Created by csj on 15/8/26.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "Binding_buttonView.h"

@implementation Binding_buttonView



- (IBAction)myBidButtonClick:(id)sender {
    UIButton *oldClickedButton =  (UIButton *)[self viewWithTag:_oldTag];
    if (oldClickedButton.tag == 10) {
        [oldClickedButton setBackgroundImage:[UIImage imageNamed:@"产品列表btn左白"] forState:UIControlStateNormal];
    }
    if (oldClickedButton.tag == 11||oldClickedButton.tag == 12) {
        [oldClickedButton setBackgroundImage:[UIImage imageNamed:@"直角"] forState:UIControlStateNormal];
    }
    if (oldClickedButton.tag == 13) {
        [oldClickedButton setBackgroundImage:[UIImage imageNamed:@"产品列表由白"] forState:UIControlStateNormal];
    }
    
    UIButton *button = (UIButton *)sender;
    if (button.tag == 10) {
         [button setBackgroundImage:[UIImage imageNamed:@"产品列表右橙"] forState:UIControlStateNormal];
    }
    if (button.tag == 13) {
        [button setBackgroundImage:[UIImage imageNamed:@"产品列表投标btn"] forState:UIControlStateNormal];
    }
    if (button.tag == 11||button.tag == 12) {
        [button setBackgroundImage:[UIImage imageNamed:@"图层-0"] forState:UIControlStateNormal];
    }
   
    self.buttoncliclBlcok(button.tag);
    _oldTag = button.tag;
}


@end
