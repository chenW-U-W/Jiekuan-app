//
//  AssetCell.m
//  Cai
//
//  Created by 启竹科技 on 15/4/3.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "AssetCell.h"
#import "AssetObj.h"
@implementation AssetCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

      if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
            self.backgroundColor = [UIColor greenColor];
      }
      return self;
      
}
//充值
- (IBAction)ClickCellBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.clickCellBTNBlock(btn.tag);
}


- (void)setAssetObj:(AssetObj *)assetObj
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    //1 真是日了狗了  "2100.00" 字符串转换为double为2100 ？！
    NSString *string = [NSString stringWithFormat:@"%.2lf",assetObj.money_freeze];
    double doubleNum = [string doubleValue];
    NSString *freezeString =  [formatter stringFromNumber:[NSNumber numberWithDouble:doubleNum]];//冻结金额
    NSString *newFreezeString =  [self addPointAndZeroToString:freezeString];
    _freezeLabel.text = newFreezeString;

    
    
    //2 这种方法也不能在2100后面加上.00
    NSString *account_moneyString = [NSString stringWithFormat:@"%.2lf",assetObj.account_money];
    _accountLabel.text =  [formatter stringFromNumber:[formatter numberFromString:account_moneyString]];
    NSString *accountString = [self addPointAndZeroToString:_accountLabel.text];
    _accountLabel.text = accountString;
    
    
    _totalLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:assetObj.all_money]];//总资产
    NSString *totalString = [self addPointAndZeroToString:_totalLabel.text];
    _totalLabel.text = totalString;
    
    
    _CaptialLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:assetObj.wait_capital]];//待收利息
    NSString *captialString = [self addPointAndZeroToString:_CaptialLabel.text];
    _CaptialLabel.text = captialString;
    
    
    _amountLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:assetObj.money_collect]];//待收总额
    NSString *amountString = [self addPointAndZeroToString:_amountLabel.text];
    _amountLabel.text = amountString;
    //3 终极解决方法  遍历字符串没有 . 的统统在后面加上.00
    
    
    
    
    //    _accountLabel.text = [[formatter stringFromNumber:[NSNumber numberWithFloat:assetObj.account_money]] substringFromIndex:4];
    //    _totalLabel.text = [[formatter stringFromNumber:[NSNumber numberWithFloat:assetObj.all_money]] substringFromIndex:4];
    //    _freezeLabel.text = [[formatter stringFromNumber:[NSNumber numberWithFloat:assetObj.money_freeze]] substringFromIndex:4];//冻结金额
    //    _amountLabel.text =  [[formatter stringFromNumber:[NSNumber numberWithFloat:assetObj.money_collect]] substringFromIndex:4];
    //    _CaptialLabel.text =  [[formatter stringFromNumber:[NSNumber numberWithFloat:assetObj.wait_capital]] substringFromIndex:4];//待收本金
}


-(NSString *)addPointAndZeroToString:(NSString *)string
{
    int a = 0;
    NSString *newFreezeString = @"0.00";
    for(int i =0; i < [string length]; i++)
    {        
        if ([@"." isEqualToString:[string substringWithRange:NSMakeRange(i, 1)]]) {
            newFreezeString = string;
            break;
        }
        else
        {
            a++;
            if (a == [string length]) {
                //在字符串后面加上.00
                newFreezeString = [NSString stringWithFormat:@"%@.00",string];
            }
            
        }
        
        
    }
    return newFreezeString;

}
@end
