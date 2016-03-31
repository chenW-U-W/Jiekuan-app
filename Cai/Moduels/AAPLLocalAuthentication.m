/*
Copyright (C) 2014 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:

 Implements LocalAuthenticaion framework demo
 
*/


#import "AAPLLocalAuthentication.h"

@import LocalAuthentication;


@interface AAPLLocalAuthentication ()

@end

@implementation AAPLLocalAuthentication

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // prepare the actions whch ca be tested in this class
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
}

-(void)viewDidLayoutSubviews
{
    
}


#pragma mark - Tests

- (void)canEvaluatePolicy
{
    LAContext *context = [[LAContext alloc] init];
    __block  NSString *msg;
    NSError *error;
    BOOL success;
    
    // test if we can evaluate the policy, this test will tell us if Touch ID is available and enrolled
    success = [context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (success) {
        msg =[NSString stringWithFormat:NSLocalizedString(@"指纹可用", nil)];
        if (self.aapLocalAuSucessedCallBackB) {
            self.aapLocalAuSucessedCallBackB(msg);
        }
        
    } else {
        msg =[NSString stringWithFormat:NSLocalizedString(@"指纹不可用", nil)];
        if (self.aapLocalAuFailedCallBackB) {
            self.aapLocalAuFailedCallBackB(msg);
        }
        
    }
   
    
}

- (void)evaluatePolicy
{
    LAContext *context = [[LAContext alloc] init];
    __block  NSString *msg;
    context.localizedFallbackTitle = @"";
    // show the authentication UI with our reason string
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"通过Home键验证已有手机指纹", nil) reply:
     ^(BOOL success, NSError *authenticationError) {
         if (success) {
             msg =[NSString stringWithFormat:NSLocalizedString(@"手机指纹可用", nil)];
             if (self.evaluateSucessedCallBackB) {
                 self.evaluateSucessedCallBackB(msg);
             }
             
         } else {//取消 错误
             NSLog(@"%@",authenticationError.domain);
             msg = [NSString stringWithFormat:NSLocalizedString(@"手机指纹验证错误", nil), authenticationError.localizedDescription];
             if (self.evaluateFailedCallBackB) {
                 self.evaluateFailedCallBackB(msg,authenticationError.code);
             }
             
         }
        
     }];
    
}

@end
