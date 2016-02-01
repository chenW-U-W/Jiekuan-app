//
//  CLRegisterViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/16.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLRegisterViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *telephoneNum;
@property (strong, nonatomic) IBOutlet UIButton *aggreBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)aggreFn:(id)sender;
- (IBAction)protocolFn:(id)sender;
- (IBAction)nextFn:(id)sender;

@end
