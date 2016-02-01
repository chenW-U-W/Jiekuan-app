//
//  DebitTableViewController.m
//  Cai
//
//  Created by csj on 15/8/21.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "DebitTableViewController.h"
#import "CailaiAPIClient.h"
#define FIRSTCELLHEIGHT 50
#define SECONDHEIGHT 44
#define TEXTFIELDWIDTH 200
@interface DebitTableViewController ()
//借款用途
@property(nonatomic,strong)UIButton *debit_purpose_button;
@property(nonatomic,strong)UITextField *debit_name_textField;//借款人姓名
@property(nonatomic,strong)UILabel *debit_phonenum_Label;//手机号
@property(nonatomic,strong)UIButton *debit_deadLine_button;//借款期限
@property(nonatomic,strong)UITextField *debit_account_textField;//借款金额

@property(nonatomic,strong)UIPickerView *pickerView;

@property(nonatomic,strong)UIPickerView *datePciker;

@property(nonatomic,strong)UIView *barView;

@property(nonatomic,strong)UIButton *DoneButton;

@property(nonatomic,copy)NSArray *purposeArray;

@property(nonatomic,assign)NSInteger purposeInteger;
//用于判断为点击的那个button
@property(nonatomic,assign)NSInteger buttonTag;

@property(nonatomic,copy)NSArray *dateArray;

@property(nonatomic,assign)NSInteger dateSelectedInteger;
@end

@implementation DebitTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"申请借贷";
    self.view.backgroundColor = UIColorFromRGB(0xf0eff4);
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;

    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-300)/2.0, 8.5*SECONDHEIGHT, 300, 40);
    [submitBtn setTitle:@"确 认 提 交" forState:UIControlStateNormal];
    submitBtn.backgroundColor = [UIColor colorWithRed:1 green:0.45 blue:0 alpha:1];
    [submitBtn addTarget:self action:@selector(submitMessage) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tableView addSubview:submitBtn];
    
    _barView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, BARVIEWHEIGHT)];
    _barView.backgroundColor = [UIColor colorWithRed:0.922 green:0.922 blue:0.925 alpha:1];
    [[UIApplication sharedApplication].keyWindow addSubview:_barView];
    [self.view addSubview:_barView];
    
    
    _DoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _DoneButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, 0, 50, BARVIEWHEIGHT);
    _DoneButton.backgroundColor = [UIColor clearColor];
    [_DoneButton setTitle:@"完成" forState:UIControlStateNormal];
    _DoneButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_DoneButton setTitleColor:[UIColor colorWithRed:1.000 green:0.451 blue:0.000 alpha:1] forState:UIControlStateNormal];
    [_DoneButton addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:_DoneButton];
    
    //purposePicker
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+_barView.frame.size.height, [UIScreen mainScreen].bounds.size.width, PURPOSEPICKERHEIGHT)];
    _pickerView.tag = 1000;
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView selectedRowInComponent:0];
    [self.view addSubview:_pickerView];
    
    _datePciker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+_barView.frame.size.height, [UIScreen mainScreen].bounds.size.width, PURPOSEPICKERHEIGHT)];
    _datePciker.tag = 1001;
    _datePciker.backgroundColor = [UIColor whiteColor];
    _datePciker.delegate = self;
    _datePciker.dataSource = self;
    [_datePciker selectedRowInComponent:0];
    [self.view addSubview:_datePciker];
    
    
   //数据源
    _purposeArray = [[NSArray alloc] initWithObjects:@"短期周转",@"生意周转",@"生活周转",@"购物消费",@"不提现借款",@"创业借款",@"其它借款", nil];

    _dateArray = [[NSArray alloc] initWithObjects:@"3个月",@"6个月",@"9个月",@"12个月", nil];
    
    _purposeInteger = -1;
    _dateSelectedInteger = -1;
}

- (void)goBack:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)submitMessage
{
    //正则匹配 验证借贷金额是不是数字
    
    NSString *regex = @"^\\d{1,8}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isValid = [predicate evaluateWithObject:_debit_account_textField.text];
    
    //正则匹配验证 姓名是不是汉字(2-7)位
    NSString *nameRegex = @"^([\u4e00-\u9fa5]){2,7}$";
    
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    
    BOOL isNameValid = [namePredicate evaluateWithObject:_debit_name_textField.text];
    
    
    if (_purposeInteger !=-1 && _dateSelectedInteger !=-1 && _debit_name_textField.text.length != 0 && _debit_account_textField.text.length != 0  && isValid && isNameValid && _debit_account_textField.text.length <5) {
        //发送数据
        NSString *deadLineNum = [[_dateArray objectAtIndex:_dateSelectedInteger] substringToIndex:1];
        [self postDebitWithBlock:^(int data, NSError *error) {
            if (!error) {
                if (data > 0) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"申请成功,我们会及时与您联系" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    alertView.tag = 10000;
                    [alertView show];
                }
                else
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"申请未成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];

                }
                
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"申请未成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            
        } withUserPhonenumber:_debit_phonenum_Label.text withPurposeNum:[NSString stringWithFormat:@"%ld",(long)_purposeInteger+1] withDeadLineDuration: deadLineNum withBorrow_money:_debit_account_textField.text];
        
    }
    else
    {
        if (!isValid || _debit_account_textField.text.length >= 5) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"借贷金额不符合要求" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
        if (!isNameValid) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"姓名必须为中文" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"信息不符合规范" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }

}


- (void )postDebitWithBlock:(void (^)(int data, NSError *error))block withUserPhonenumber:(NSString *)mobile  withPurposeNum:(NSString *)purPose withDeadLineDuration:(NSString *)duration withBorrow_money:(NSString*)borrow_money
{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"application.borrow.set", @"sname",
                           mobile, @"user_phone",
                           purPose,@"borrow_use",
                           duration,@"borrow_duration",
                           borrow_money,@"borrow_money",
                           nil];
     [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
         
        if (block) {
            block([[JSON valueForKey:@"data"] intValue], nil);
        }
    } failure:^(NSError *error) {
        if (block) {
            block(-1, error);
        }
    } method:@"POST"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
       return 7;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return FIRSTCELLHEIGHT;
    }
    return SECONDHEIGHT;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSLog(@"+++++++++");

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    NSString *identifier = @"DebitCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        label.text = @"仅限上海房屋抵押借贷";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor redColor];
        [cell.contentView addSubview:label];
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"请填写以下借款信息:";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"姓名";
       
        _debit_name_textField = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 200, 0, 200, SECONDHEIGHT)];
         _debit_name_textField.placeholder = @"请填写姓名";
        _debit_name_textField.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:_debit_name_textField];
        //_debit_name_textField.backgroundColor = [UIColor redColor];
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"电话";
      
        _debit_phonenum_Label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 200, 0, 200, SECONDHEIGHT)];
        _debit_phonenum_Label.text  = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserMobile"];
        [cell.contentView addSubview:_debit_phonenum_Label];
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = @"借款用途";
        
        _debit_purpose_button = [UIButton buttonWithType:UIButtonTypeSystem] ;
        _debit_purpose_button.tag = 5000;
        _debit_purpose_button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 200, 0, 200, SECONDHEIGHT);
         [_debit_purpose_button setTitle:@"请选择借款用途" forState:UIControlStateNormal];
        //_debit_purpose_button.titleLabel.textAlignment = NSTextAlignmentLeft;
        _debit_purpose_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_debit_purpose_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //_debit_purpose_button.backgroundColor = [UIColor greenColor];
        [_debit_purpose_button addTarget:self action:@selector(chosePurpose:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:_debit_purpose_button];
        
        
        UITableView *purposeTableView = [[UITableView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 200, 100, 200, 0) style:UITableViewStylePlain];
        purposeTableView.backgroundColor = [UIColor orangeColor];
        purposeTableView.tag = 4000;
        purposeTableView.delegate = self;
        purposeTableView.dataSource = self;
        [self.view addSubview:purposeTableView];
    }
    if (indexPath.row == 5) {
        cell.textLabel.text = @"借款期限";
        
        _debit_deadLine_button = [UIButton buttonWithType:UIButtonTypeSystem];
        _debit_deadLine_button.tag  = 5001;
        [_debit_deadLine_button addTarget:self action:@selector(chosePurpose:) forControlEvents:UIControlEventTouchUpInside];
        [_debit_deadLine_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_debit_deadLine_button setTitle:@"请选择借款期限" forState:UIControlStateNormal];
        _debit_deadLine_button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 200, 0, 200, SECONDHEIGHT);
        _debit_deadLine_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        _debit_deadLine_button.titleLabel.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:_debit_deadLine_button];
    }
    if (indexPath.row == 6) {
        cell.textLabel.text = @"借款金额(万)";
        _debit_account_textField = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 200, 0, 200, SECONDHEIGHT)];
        _debit_account_textField.placeholder = @"请输入借款金额";
        _debit_account_textField.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:_debit_account_textField];
    }

    return cell;
}

-(void)chosePurpose:(UIButton *)sender
{
    
    _buttonTag = sender.tag;
    
    //选择用途
    if (_buttonTag == 5000) {
        if (_datePciker.frame.origin.y >=[UIScreen mainScreen].bounds.size.height) {
            [UIView animateWithDuration:0.3 animations:^{
                _barView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-BARVIEWHEIGHT-PURPOSEPICKERHEIGHT, [UIScreen mainScreen].bounds.size.width, BARVIEWHEIGHT);
                
                _pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-PURPOSEPICKERHEIGHT, [UIScreen mainScreen].bounds.size.width, PURPOSEPICKERHEIGHT);
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            //还在界面上
            [UIView animateWithDuration:0.0 animations:^{
                _barView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, BARVIEWHEIGHT);
                
                _datePciker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+_barView.frame.size.height, [UIScreen mainScreen].bounds.size.width, PURPOSEPICKERHEIGHT);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    _barView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-BARVIEWHEIGHT-PURPOSEPICKERHEIGHT, [UIScreen mainScreen].bounds.size.width, BARVIEWHEIGHT);
                    
                    _pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-PURPOSEPICKERHEIGHT, [UIScreen mainScreen].bounds.size.width, PURPOSEPICKERHEIGHT);
                }];
            }];
        }

             
      }
    if (_buttonTag == 5001)
    {
        
    //_pickerView 未在界面上显示
    if (_pickerView.frame.origin.y >=[UIScreen mainScreen].bounds.size.height) {
        [UIView animateWithDuration:0.3 animations:^{
            _barView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-BARVIEWHEIGHT-PURPOSEPICKERHEIGHT, [UIScreen mainScreen].bounds.size.width, BARVIEWHEIGHT);
            
            _datePciker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-PURPOSEPICKERHEIGHT, [UIScreen mainScreen].bounds.size.width, PURPOSEPICKERHEIGHT);
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
    //还在界面上
        [UIView animateWithDuration:0.0 animations:^{
            _barView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, BARVIEWHEIGHT);
            
            _pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+_barView.frame.size.height, [UIScreen mainScreen].bounds.size.width, PURPOSEPICKERHEIGHT);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                _barView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-BARVIEWHEIGHT-PURPOSEPICKERHEIGHT, [UIScreen mainScreen].bounds.size.width, BARVIEWHEIGHT);
                
                _datePciker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-PURPOSEPICKERHEIGHT, [UIScreen mainScreen].bounds.size.width, PURPOSEPICKERHEIGHT);
            }];
        }];
    }
    }
    
}


- (void)doneClicked
{
    [UIView animateWithDuration:0.3 animations:^{
        _barView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, BARVIEWHEIGHT);
        
        if (_buttonTag == 5000) {
            _pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+_barView.frame.size.height, [UIScreen mainScreen].bounds.size.width, PURPOSEPICKERHEIGHT);
            
        }
        else
        {
            _datePciker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+_barView.frame.size.height, [UIScreen mainScreen].bounds.size.width, PURPOSEPICKERHEIGHT);
            
        }
        
    } completion:^(BOOL finished) {
       
        if (_buttonTag == 5000) {
             NSInteger selectedRow = [_pickerView selectedRowInComponent:0];
            [_debit_purpose_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _purposeInteger = selectedRow;
            [_debit_purpose_button setTitle:[_purposeArray objectAtIndex:_purposeInteger] forState:UIControlStateNormal];
           
        }
        if (_buttonTag == 5001) {
             NSInteger selectedRow = [_datePciker selectedRowInComponent:0];
            [_debit_deadLine_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _dateSelectedInteger = selectedRow;
            [_debit_deadLine_button setTitle:[_dateArray objectAtIndex:_dateSelectedInteger] forState:UIControlStateNormal];
            
        }
        
        
    }];
    
}
#pragma mark --------alertViewDelegate--------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==10000) {
        [self.navigationController popViewControllerAnimated:YES];
    }


}




#pragma mark   -----datasource----

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1000) {
        return _purposeArray.count;
    }
    return _dateArray.count;
    
}

#pragma mark   -----delegate---


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 1000) {
     return [_purposeArray objectAtIndex:row];
    }
    return [_dateArray objectAtIndex:row];
}
@end
