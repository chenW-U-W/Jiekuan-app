//
//  purchaseViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/4/10.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AssetObj;
@interface purchaseViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UIButton *tenderBtn;
@property (strong, nonatomic) IBOutlet UILabel *earningLabel;//到期收益
@property (strong, nonatomic) IBOutlet UILabel *banlanceLabel;//账户余额
@property (strong, nonatomic) IBOutlet UILabel *canUsedMoney;//可投金额
@property (strong, nonatomic) NSString *bid;
@property (nonatomic,assign) int borrow_duration;//借款期限
@property (nonatomic,assign) float interest_rate;//年利率
@property (nonatomic,assign) double canBidMoney;//可投金额
@property (nonatomic,assign) int borrow_min;
@property (nonatomic,assign) NSInteger  borrow_max;
@property (nonatomic,strong) AssetObj *assetObj;
@property (weak, nonatomic) IBOutlet UIView *toolsView;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UIView *subToolsView;
@property (weak, nonatomic) IBOutlet UIButton *markBtn;
- (IBAction)choseTools:(id)sender;
- (IBAction)tenderButton:(id)sender;
@end
