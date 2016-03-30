//
//  DrawViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/27.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnBackBlock)();
@interface DrawViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UIButton *drawBtn;
@property (strong, nonatomic) ReturnBackBlock returnBackB;
@end
