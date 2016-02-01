//
//  InterestCountViewController.h
//  Cai
//
//  Created by 陈思远 on 16/1/26.
//  Copyright © 2016年 财来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterestCountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *collectedInterestTextField;
@property (weak, nonatomic) IBOutlet UIView *waitRorCollectedTextfield;
@property (weak, nonatomic) IBOutlet UILabel *collectedTitle;
@property (weak, nonatomic) IBOutlet UILabel *collectedNum;
@property (weak, nonatomic) IBOutlet UILabel *waitedForTitle;
@property (weak, nonatomic) IBOutlet UILabel *waitedForNum;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *currentMontBtn;
@property (weak, nonatomic) IBOutlet UIButton *allMonthBtn;
@property (weak, nonatomic) IBOutlet UIButton *nearThreeMonthBtn;
@property (weak, nonatomic) IBOutlet UIButton *nearSixMonthBtn;
@property (weak, nonatomic) IBOutlet UIButton *nearOneYearBnt;

@property (weak, nonatomic) IBOutlet UIImageView *chosedImage;
@property (nonatomic,strong) NSMutableArray *totalArray;
- (IBAction)monthBtnClick:(id)sender;


@end
