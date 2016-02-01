//
//  ParticularCell.h
//  Cai
//
//  Created by 启竹科技 on 15/4/2.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecommendedObj;
@class QZProgressView;
@interface ParticularCell : UITableViewCell

{
     
      //UIImageView *rateImageView;//利率图片
      UIButton *button;//立即抢购button
      UIImageView *nameImageView;//托管图片
      UILabel *yujiRatelabel;
      QZProgressView *rateImageView ;
}
@property(nonatomic,strong) UILabel *debitDetailLabel; //借款详情label
@property(nonatomic,strong) UILabel *deadlineLabel;//期限label
@property(nonatomic,strong) UILabel *capitalLabel;  //起购label
@property(nonatomic,strong) UILabel *debitLabel; //借贷金额label
@property(nonatomic,strong) UILabel *rongzhiLabel;//融资label
@property(nonatomic,strong) UILabel *rateLabel;//利率label
@property(nonatomic,strong) UILabel *statementLabel;//声明label
@property(nonatomic,strong) RecommendedObj *recommendObj;
@end
