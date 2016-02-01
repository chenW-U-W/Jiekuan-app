//
//  messageView.m
//  Cai
//
//  Created by 启竹科技 on 15/4/10.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "messageView.h"

@implementation messageView

- (IBAction)rechargeFn:(id)sender {
      
      [self removeFromSuperview];
      
      //发送一个通知 通知购买界面 去充值
      
      [[NSNotificationCenter defaultCenter] postNotificationName:@"recharge" object:self];
}

- (IBAction)cancelFn:(id)sender {
      [self removeFromSuperview];
      //发送一个通知 通知购买界面取消
      
      [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelMessageView" object:self];
}

+(messageView *)instanceMessageView
{

      NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"messageView" owner:nil options:nil];
      for (id objc in array) {
            if ([objc isKindOfClass:[messageView class]]) {
                
                  return objc;
            }
            
      }

      return nil;
}
//需要加点什么 要：
-(id)initWithCoder:(NSCoder *)aDecoder
{
      self = [super initWithCoder:aDecoder];
      if(self)
      {
         
      }
      return self;
}

@end
