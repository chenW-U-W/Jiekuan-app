/*
Copyright (C) 2014 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:

 Implements LocalAuthenticaion framework demo
 
*/


typedef void (^AAPLLocalAuthenticationSucessedCallBacBlock)(NSString *);
typedef void (^AAPLLocalAuthenticationFailedCallBacBlock)(NSString *);

typedef void (^AAPLLocalEvaluateSucessedCallBacBlock)(NSString *);
typedef void (^AAPLLocalEvaluateFailedCallBacBlock)(NSString *,NSInteger);

@interface AAPLLocalAuthentication : UIViewController
@property (nonatomic,strong) AAPLLocalAuthenticationSucessedCallBacBlock aapLocalAuSucessedCallBackB;
@property (nonatomic,strong) AAPLLocalAuthenticationFailedCallBacBlock aapLocalAuFailedCallBackB;

@property (nonatomic,strong) AAPLLocalEvaluateSucessedCallBacBlock evaluateSucessedCallBackB;
@property (nonatomic,strong) AAPLLocalEvaluateFailedCallBacBlock evaluateFailedCallBackB;

- (void)canEvaluatePolicy;
- (void)evaluatePolicy;

@end
