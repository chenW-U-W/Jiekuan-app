//
//  GesturePasswordView.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "GesturePasswordView.h"
#import "GesturePasswordButton.h"
#import "TentacleView.h"

@implementation GesturePasswordView {
    NSMutableArray * buttonArray;
    
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
    
}
@synthesize imgView;
@synthesize forgetButton;
@synthesize changeButton;

@synthesize tentacleView;
@synthesize state;
@synthesize gesturePasswordDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height/2-120/ViewWithDevicHeight, [UIScreen mainScreen].bounds.size.width, 330)];
        
        //view.backgroundColor = [UIColor redColor];
        for (int i=0; i<9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            // Button Frame
            NSInteger btnSize = 65;
            NSInteger margin = 33;
             float distance = (DeviceSizeWidth-3*btnSize-2*margin)/2.0;
            GesturePasswordButton * gesturePasswordButton = [[GesturePasswordButton alloc]initWithFrame:CGRectMake(distance+col*btnSize+col*margin, distance+row*btnSize+row*margin, btnSize, btnSize)];
            [gesturePasswordButton setTag:i];
            [view addSubview:gesturePasswordButton];
            [buttonArray addObject:gesturePasswordButton];
        }
        frame.origin.y=0;
        [self addSubview:view];
        
          
        tentacleView = [[TentacleView alloc]initWithFrame:view.frame];
        [tentacleView setButtonArray:buttonArray];
        [tentacleView setTouchBeginDelegate:self];
        [self addSubview:tentacleView];
        
        state = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.origin.x,view.frame.origin.y- 60, [UIScreen mainScreen].bounds.size.width, 30)];
        [state setTextAlignment:NSTextAlignmentCenter];
        [state setFont:[UIFont systemFontOfSize:14.f]];
        [self addSubview:state];
        
        
          _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,view.frame.origin.y- 150,DeviceSizeWidth,30)] ;
          _messageLabel.text = @"请输入财来网的解锁密码";
         _messageLabel.textColor = [UIColor colorWithRed:0.529 green:0.529 blue:0.529 alpha:1];
          //_messageLabel.backgroundColor = [UIColor greenColor];
          _messageLabel.textAlignment = NSTextAlignmentCenter;
          [self addSubview:_messageLabel];

          
          
        
        forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2-60, frame.size.height-80, 120, 30)];
        [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [forgetButton setTitleColor:[UIColor colorWithRed:0.529 green:0.529 blue:0.529 alpha:1] forState:UIControlStateNormal];
        [forgetButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
        [forgetButton addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchDown];
        [self addSubview:forgetButton];
        
//        changeButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2+30, frame.size.height/2+220, 120, 30)];
//        [changeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//        [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [changeButton setTitle:@"修改手势密码" forState:UIControlStateNormal];
//        [changeButton addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchDown];
//        [self addSubview:changeButton];
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//改变当前视图层的颜色 渐变效果  CGColorSpace.h 可以获得CMYK（色值表）
- (void)drawRect:(CGRect)rect
{
    /*
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//    CGFloat colors[] =
//    {
//        134 / 255.0, 157 / 255.0, 147 / 255.0, 1.00,
//        3 / 255.0,  3 / 255.0, 37 / 255.0, 1.00,
//    };
      CGFloat colors[] =
      
      {
            
//            204.0 / 255.0, 224.0 / 255.0, 244.0 / 255.0, 1.00,
//            
//            29.0 / 255.0, 156.0 / 255.0, 215.0 / 255.0, 1.00,
//            
//            0.0 / 255.0,  50.0 / 255.0, 126.0 / 255.0, 1.00,
          134 / 255.0, 157 / 255.0, 147 / 255.0, 1.00,
          3 / 255.0,  3 / 255.0, 37 / 255.0, 1.00,
          
      };
    CGGradientRef gradient = CGGradientCreateWithColorComponents
    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient,CGPointMake
                                (0.0,0.0) ,CGPointMake(0.0,self.frame.size.height),
                                kCGGradientDrawsBeforeStartLocation);
     */
    
    
}

- (void)gestureTouchBegin {
    [self.state setText:@""];
}

-(void)forget{
    [gesturePasswordDelegate forget];//gesturePassWordController  调用forget
}

-(void)change{
    [gesturePasswordDelegate change];
}


@end
