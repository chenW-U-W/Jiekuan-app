//
//  purchaseViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/4/10.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "purchaseViewController.h"
#import "messageView.h"
#import "RechargeDetaiViewController.h"
#import "UIView+Toast.h"
#import "User.h"
#import "PurchaseFromHFViewController.h"
#import "AssetObj.h"
#import "RedPocketObj.h"
#import "RedPocketButton.h"


#define distanceY 10
#define redPocketWidth 90
#define redPocketHeight 40
#define distanceX ([UIScreen mainScreen].bounds.size.width-3*redPocketWidth)/4.0   //行间距
#define distaneceOFredpocketbtn distanceX
#define heightDistanceOfbtn 15        //竖间距


@interface purchaseViewController ()
{
      
      messageView *mesView;//会员投标view
      UIButton *button;//蒙版btn
      UILabel *alertView;//提示试图
}
@property (nonatomic,assign)BOOL isShowToolViews;
@property (nonatomic,strong)RedPocketObj *redPocketObj;
@property (nonatomic,strong)NSMutableArray *redPocketArray;//红包数组
@property (nonatomic,strong)NSMutableArray *canUsedPocketArray;//可用的红包
@property (nonatomic,strong)NSMutableArray *isSelectedPocketArray;//被选中的红包数组 (保存的是红包的id)
@property (nonatomic,strong)NSMutableArray *selectedBtnArray;//被选中的红包按钮数组
@property (nonatomic,strong)NSMutableArray *selectedPObjectArray;//被选中的红包对象数组
@property (nonatomic,assign)float redPocketCount;
@end

@implementation purchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设计提示语
    alertView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    alertView.text = @"";
    alertView.font = [UIFont systemFontOfSize:14];
    alertView.textColor = [UIColor whiteColor];
    alertView.backgroundColor = NORMALCOLOR;
    alertView.tag = 1000;
    alertView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, -15);
    alertView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:alertView];
    
    
    //设计tabbar的试图
    self.title = @"购买";
    
    _earningLabel.textColor = UIColorFromRGB(0xf39700);
    
      UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
      [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
      [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
      UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
      self.navigationItem.leftBarButtonItem = leftItem;
    
    //红包数据源
    _redPocketArray = [[NSMutableArray alloc] initWithCapacity:0];
    _canUsedPocketArray = [[NSMutableArray alloc] initWithCapacity:0];
    _isSelectedPocketArray =[[NSMutableArray alloc] initWithCapacity:0];
    _selectedBtnArray = [[NSMutableArray alloc] initWithCapacity:0];
    _selectedPObjectArray = [[NSMutableArray alloc] initWithCapacity:0];
    _redPocketCount = 0.0;
    
    //首先隐藏红包视图
    _isShowToolViews  = YES;
    //_toolsView.alpha = 0;
    //_subToolsView.frame = CGRectMake(0, 242, [UIScreen mainScreen].bounds.size.width, 115);
    
    if (_borrow_max == 0) {
//        _borrow_max= UINT32_MAX;//如果是无限大则取最大int 64位的值
         self.amountTextField.placeholder = [ NSString stringWithFormat:@"100元的整数倍最低%d",_borrow_min];
    }
    else
    {
    self.amountTextField.placeholder = [ NSString stringWithFormat:@"100元的整数倍最低%d",_borrow_min];
    }
    //[self.amountTextField becomeFirstResponder ];
      self.amountTextField.delegate = self;
    
      self.amountTextField.keyboardType =  UIKeyboardTypePhonePad;
    [_amountTextField addTarget:self action:@selector(checkMoney:) forControlEvents:UIControlEventEditingChanged];
    
    [self  loadData];
    
      //接受会员投标提示的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goRecharge) name:@"recharge" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel) name:@"cancelMessageView" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

}


- (CGRect)drawRectOfLabel:(UILabel *)label
{
    NSString *debitString =label.text;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: debitString];
    //分段控制，最开始1个字符颜色设置成黑色
    [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: NSMakeRange(debitString.length-1, 1)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(debitString.length-1, 1)];
    //赋值给显示控件label01的 attributedText
    label.attributedText = attributedStr;
    
    
    //重新布局banlanceLabel（账户余额）
    CGSize size =CGSizeMake(1000,60);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName,nil];
    CGSize  actualsize =[label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine  attributes:tdic context:nil].size;
    CGFloat balanceLabeWidth = actualsize.width;
    CGRect rect = label.frame;
    
    CGRect labelRect = CGRectMake(rect.origin.x, rect.origin.y, balanceLabeWidth, rect.size.height);
    
    
    return labelRect;
}



-(void)loadData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //加载数据
        [AssetObj getAssetWithBlock:^(id posts, NSError *error) {
            if (error) {

                DLog(@"%@",error);
                ALERTVIEW;
                
            }
            else
            {
                self.assetObj = posts;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    //账户余额
                    _banlanceLabel.text = [NSString stringWithFormat:@"%.2f  元",_assetObj.account_money];
                    CGRect rect =  [self drawRectOfLabel:_banlanceLabel];
                    if (_banlanceLabel) {
                        [_banlanceLabel removeFromSuperview];
                    }
                    _banlanceLabel.frame = rect;
                    [self.view addSubview:_banlanceLabel];
                    
                    
                    //可投金额
                    _canUsedMoney.text = [NSString stringWithFormat:@"%.2f  元",_canBidMoney];
                    CGRect rect1 =  [self drawRectOfLabel:_canUsedMoney];
                    if (_canUsedMoney) {
                        [_canUsedMoney removeFromSuperview];
                    }
                    _canUsedMoney.frame = rect1;
                    [self.view addSubview:_canUsedMoney];
                    

                });
            }
        }];
        
    });
    //请求红包
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //加载数据
        [RedPocketObj getRedPocketWithBlock:^(id posts, NSError *error) {
            if (error) {
                DLog(@"%@",error);
                ALERTVIEW;
            }
            else
            {
                
                
                self.redPocketArray = posts;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //创建红包按钮
                    //先判断红包是否过期，过期则删除 数据
                    for (int i=0;i<self.redPocketArray.count ; i++) {
                        
                        RedPocketObj *redPocketObj = [_redPocketArray objectAtIndex:i];
                        NSTimeInterval NowFrom1970 = [[NSDate date] timeIntervalSince1970];
                        //添加可用红包    0表示可用 1标识已用
                        if (redPocketObj.overtime > NowFrom1970 && redPocketObj.is_success == 0) {
                            [self.canUsedPocketArray addObject:redPocketObj];
                        }

                    }
                    
                    if (self.canUsedPocketArray.count>6) {
                        [self.canUsedPocketArray removeAllObjects];
                        for (int i = 0; i< 6; i++) {
                            [self.canUsedPocketArray addObject:[_redPocketArray objectAtIndex:i]];
                        }
                        
                    }
                    //布局红包试图                    
                    for (int i = 0; i<self.canUsedPocketArray.count; i++) {
                        RedPocketObj *redPockObj = [self.canUsedPocketArray objectAtIndex:i];
                        
                        float originX = distanceX + i%3*(redPocketWidth +distaneceOFredpocketbtn);
                        float originY = distanceY + i/3*(heightDistanceOfbtn+redPocketHeight);
                        RedPocketButton *redPocketBtn = [RedPocketButton buttonWithType:UIButtonTypeSystem];
                        redPocketBtn.isChosed = NO;
                        [redPocketBtn setBackgroundImage:[UIImage imageNamed:@"图片红包白色"] forState:UIControlStateNormal];
                        //[redPocketBtn setBackgroundColor:[UIColor greenColor]];
                        redPocketBtn.tag = 1000+i;
                        redPocketBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                        [redPocketBtn setTitle:[NSString stringWithFormat:@"%d元现金券",redPockObj.facevalue] forState:UIControlStateNormal];
                        [redPocketBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        redPocketBtn.frame = CGRectMake(originX, originY, redPocketWidth, redPocketHeight);
                        [redPocketBtn addTarget:self action:@selector(choseRedPocketBtn:) forControlEvents:UIControlEventTouchUpInside];
                        //[_toolsView addSubview:redPocketBtn];
                        [_toolsView insertSubview:redPocketBtn belowSubview:_subToolsView];
                    }
                    
                    
                    
                });
            }
        }];
        
    });

}


-(void)choseRedPocketBtn:(RedPocketButton *)btn
{
    RedPocketObj *redPocketOBJ = [_canUsedPocketArray objectAtIndex:btn.tag-1000];

    if (btn.isChosed == NO) {
        btn.isChosed =YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"图片红包"] forState:UIControlStateNormal];
        //[btn setBackgroundColor:[UIColor redColor]];
        //向被选中的红包一维数组中添加红包id
                [_isSelectedPocketArray addObject:[NSString stringWithFormat:@"%d",redPocketOBJ.packetID]];
        _redPocketCount =_redPocketCount + redPocketOBJ.facevalue;
        [_selectedBtnArray addObject:btn];
        [_selectedPObjectArray addObject:redPocketOBJ];
    }
    else
    {
        btn.isChosed = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"图片红包白色"] forState:UIControlStateNormal];
        //[btn setBackgroundColor:[UIColor greenColor]];
        [_isSelectedPocketArray removeObject:[NSString stringWithFormat:@"%d",redPocketOBJ.packetID]];
        _redPocketCount =_redPocketCount - redPocketOBJ.facevalue;
        [_selectedBtnArray removeObject:btn];
        [_selectedPObjectArray removeObject:redPocketOBJ];
    }
    DLog(@"%@",_isSelectedPocketArray);
    double redPocketAmout =  [_amountTextField.text doubleValue];
    if (_redPocketCount > redPocketAmout/10.00) {
        _alertLabel.text = @"所选现金券大于可使用现金券金额";
    }
    else
    {
     _alertLabel.text = @"";
    }
}


-(void)checkMoney:(UITextField *)textField
{
    //改变预计到期收益
    if (textField.text.length>0) {
        int amount = [_amountTextField.text floatValue];
        if (amount && amount>=0) {
            _earningLabel.text = [NSString stringWithFormat:@"%.2f  元", _interest_rate/100.0*_borrow_duration/12*amount];
            _earningLabel.textColor = UIColorFromRGB(0xf39700);
           
        }

    }
    if (textField.text.length == 0) {
        _earningLabel.text = @"0.00  元";
        _earningLabel.textColor = UIColorFromRGB(0xf39700);
    }    
    NSString *debitString =_earningLabel.text;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: debitString];
    //分段控制，最开始1个字符颜色设置成黑色
    [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: NSMakeRange(debitString.length-1, 1)];
    _earningLabel.attributedText = attributedStr;
   
    //改变投资道具警示试图_alertLabel
    NSInteger amount = [textField.text integerValue];
    if (amount>=_borrow_min) {
        _alertLabel.text = @"";
    }
    
}


//弹出选择红包视图
- (IBAction)choseTools:(id)sender
{
    
    if (_isShowToolViews == YES) {
       _toolsView.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:0.25 animations:^{
            //_markBtn.transform = CGAffineTransformIdentity;
            _markBtn.transform = CGAffineTransformMakeRotation(M_PI);
            _toolsView.alpha = 1;
            _subToolsView.frame = CGRectMake(0,117, [UIScreen mainScreen].bounds.size.width, 222);
            
        } completion:^(BOOL finished) {
            _isShowToolViews = NO;
            
        }];

    }
    else
    {
     // _toolsView.backgroundColor = [UIColor colorWithRed:0.918 green:0.906 blue:0.945 alpha:1];
        [UIView animateWithDuration:0.25 animations:^{
            _markBtn.transform = CGAffineTransformIdentity;
            //_markBtn.transform = CGAffineTransformMakeRotation(-M_PI);
            //_toolsView.alpha = 0;
            _subToolsView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 222);
            
        } completion:^(BOOL finished) {
            _isShowToolViews = YES;
            
        }];

    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (BOOL)textFieldShouldReturn
{

      return YES;
}

- (void)goBack:(id)sender
{

      [self.navigationController popViewControllerAnimated:YES];
}


-(void)startAlertViewAnimationWithString:(NSString *)string withButton:(UIButton *)sender
{
    alertView.text = string;
    [UIView animateWithDuration:0.5 animations:^{
        alertView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, 15);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                alertView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, -15);
            } completion:^(BOOL finished) {
                sender.userInteractionEnabled = YES;
            }];
            
        });
        
    }];
    

}

- (IBAction)tenderButton:(UIButton *)sender
{
     sender.userInteractionEnabled = NO;
    //发送网络请求  检查账户余额
    NSInteger amount = [self.amountTextField.text integerValue];
    
    
    //购买金额+红包金额
    float money =  [_amountTextField.text floatValue];
    float selectCount = 0;
    for ( RedPocketObj *redObjc in _selectedPObjectArray) {
        selectCount += redObjc.facevalue;
    }
    float totalMoney = money + selectCount;
    
    
    //可投金额-购买金额-红包
    float remainedMoney = _canBidMoney - money - selectCount;
    
    
    
    double redPocketAmout =  [_amountTextField.text doubleValue];
    //1----
    if (_redPocketCount > redPocketAmout/10.00) {
        NSString *aString = @"所选红包金额大于可使用金额";
        //弹出aletview
        
        [self startAlertViewAnimationWithString:aString withButton:sender];
        
        return;
    }
    //2-----
    if (amount<_borrow_min) {
        NSString *string = [ NSString stringWithFormat:@"最小投资金额为%d",_borrow_min];
        
        [self startAlertViewAnimationWithString:string withButton:sender];
        return;
    }
    if (amount%100 != 0) {
        NSString *string = @"投标的金额需为100元的整数倍";
        
        [self startAlertViewAnimationWithString:string withButton:sender];
        return;
    }
    //3-----
    if (totalMoney>_canBidMoney) {
        NSString *string = @"购买金额与您所选红包金额超过可投金额";
        [self startAlertViewAnimationWithString:string withButton:sender];
        return;
    }
    //4-----
    if (remainedMoney < _borrow_min && remainedMoney>0) {
        NSString *string = @"投标过后的金额少于最小投资金额";
        [self startAlertViewAnimationWithString:string withButton:sender];
        return;
    }
          
         
    
          DLog(@"可以购买");
          [User purchaseWithBlock:^(NSDictionary* posts, NSError *error) {
               sender.userInteractionEnabled = YES;
              if (error) {
                  
                  if (error.code == 105) {
                      NSString *string =  @"借款人不能投资本人借贷的标";
                      [self startAlertViewAnimationWithString:string withButton:sender];
                      
                  }
                  else
                  {
                      
                      NSString *string =  @"无法连接服务请稍后再试";
                      [self startAlertViewAnimationWithString:string withButton:sender];
                  }
                  
                  
              }
              else {
                  
                  //投资金额大于账户余额
                  if ([posts allKeys].count == 1) {
                      //投标提示
                      button = [UIButton buttonWithType:UIButtonTypeSystem];
                      button.frame = [UIScreen mainScreen].bounds;
                      [button setBackgroundColor:[UIColor blackColor]];
                      button.alpha = 0.5;
                      [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                      [[UIApplication sharedApplication].keyWindow addSubview:button];
                      
                      mesView = [messageView instanceMessageView];
                      mesView.bidMoney.text = _amountTextField.text;                      
                      mesView.balanceLabel.text =[NSString stringWithFormat:@"%@", [posts objectForKey:@"account_money"]];
                      mesView.center = self.view.center;
                      [[UIApplication sharedApplication].keyWindow  addSubview:mesView];
                      
                      
                  }else
                  {
                      //1 红包使用后消失
                      [_selectedBtnArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
                      //2 进入汇付html界面
                      PurchaseFromHFViewController *purchaseFromHFVC = [[PurchaseFromHFViewController alloc] init];
                      purchaseFromHFVC.hidesBottomBarWhenPushed = YES;
                      purchaseFromHFVC.amountSting = _amountTextField.text;
                      purchaseFromHFVC.dic = posts;
                      [self.navigationController pushViewController:purchaseFromHFVC animated:YES];
                  }

                  
              
              }
          } withMoneyAccount:[NSString stringWithFormat:@"%.0f",totalMoney]  withBid:_bid withRedPocketId:[_isSelectedPocketArray copy] withRedPcoketAccount:[NSString stringWithFormat:@"%f",_redPocketCount]];
    
   
    
}


- (void)buttonClick:(UIButton *)btn
{
    _tenderBtn.userInteractionEnabled = YES;
      [mesView removeFromSuperview];
      [button removeFromSuperview];
      
}
- (void)goRecharge
{
      [button removeFromSuperview];
      RechargeDetaiViewController *rechargeDetailVC = [[RechargeDetaiViewController alloc] init];
    rechargeDetailVC.amountSting =  _amountTextField.text;
      [self.navigationController pushViewController:rechargeDetailVC animated:YES];
}

- (void)cancel
{
       [button removeFromSuperview];
    _tenderBtn.userInteractionEnabled = YES;
}


#pragma mark ------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
      textField.text = @"";
    _earningLabel.text = @"0.00 元";
    _earningLabel.textColor = UIColorFromRGB(0xf39700);
    NSString *debitString =_earningLabel.text;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: debitString];
    //分段控制，最开始1个字符颜色设置成黑色
    [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: NSMakeRange(debitString.length-1, 1)];
    _earningLabel.attributedText = attributedStr;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
      [textField resignFirstResponder];
      return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

      [self.amountTextField   resignFirstResponder];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _tenderBtn.userInteractionEnabled = YES;
}
@end
