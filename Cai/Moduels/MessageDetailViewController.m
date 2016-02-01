//
//  MessageDetailViewController.m
//  Cai
//
//  Created by csj on 15/9/10.
//  Copyright (c) 2015年 财来. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _messageObj.title;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"40"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;

    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor whiteColor]};
//    //标题试图
//    UIView *TitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
//   // TitleView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:TitleView];
//    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
//    //titleLabel.backgroundColor = [UIColor greenColor];
//    titleLabel.text = _messageObj.title;
//    titleLabel.font = [UIFont systemFontOfSize:15];
//    [TitleView  addSubview:titleLabel];
//    
//    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 220, 5, 210, 20)];
//     dateLabel.font = [UIFont systemFontOfSize:15];
//    dateLabel.text =_messageObj.send_time;
//    dateLabel.textAlignment = NSTextAlignmentRight;
//    [TitleView addSubview:dateLabel];
//    
//    //分割线
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TitleView.frame.size.height-1, [UIScreen mainScreen].bounds.size.width, 1)];
//    imageView.image = [UIImage imageNamed:@"14"];
//    [TitleView addSubview:imageView];
    
//    //内容试图
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, TitleView.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-TitleView.frame.size.height)];
//    textView.showsVerticalScrollIndicator = NO;
//    textView.text = _messageObj.content;
//    textView.font = [UIFont systemFontOfSize:17];
//    [self.view addSubview:textView];
    
    
    //内容试图
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(30, 30, [UIScreen mainScreen].bounds.size.width-60, 150)];
    //textView.backgroundColor = [UIColor redColor];
    textView.showsVerticalScrollIndicator = NO;
    textView.text = [NSString stringWithFormat:@"   %@",_messageObj.content];
    textView.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:textView];

    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 220, textView.frame.size.height+textView.frame.origin.y+20, 210, 30)];
    //dateLabel.backgroundColor = [UIColor greenColor];
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.text =_messageObj.send_time;
    dateLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:dateLabel];
}


- (void)goBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
