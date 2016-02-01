//
//  User.h
//  Cai
//
//  Created by Cameron Ling on 4/29/15.
//  Copyright (c) 2015 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, assign) NSInteger userId;//用户id
@property (nonatomic, strong) NSString  *mobile;//手机号码
@property (nonatomic, strong) NSString  *realName;//真实姓名
@property (nonatomic, strong) NSString  *password;//密码
@property (nonatomic, strong) NSString  *recommendedMobile;//推荐人手机号
@property (nonatomic, strong) NSDate    *reg_time;//注册时间
@property (nonatomic, strong) NSString  *sessionId;//sessionID


+ (instancetype)shared;

// 检查是否注册
+ (NSURLSessionDataTask *)isRegisteredWithBlock:(void (^)(Boolean data, NSError *error))block
                                     withMobile:(NSString *)mobile;
//发送验证码

+ (NSURLSessionDataTask *)getMsgCodeWithBlock:(void (^)(Boolean data, NSError *error))block
                                     withMobile:(NSString *)mobile;
// 注册
+ (NSURLSessionDataTask *)registerWithBlock:(void (^)(NSDictionary *posts, NSError *error))block
                                 withMobile:(NSString *)mobile
                               withPassword:(NSString *)password  withRecommended:(NSString *)recommended withTelcode:(NSString *)telcode;;
// 登录
+ (NSURLSessionDataTask *)loginWithBlock:(void (^)(NSArray *posts, NSError *error))block  withMobile:(NSString *)mobile  withPassword:(NSString *)password;


// cailai 身份认证
+ (NSURLSessionDataTask *)authHuifuWithBlock:(void (^)(NSDictionary *posts, NSError *error))block withPhoneNumber:(NSString *)phoneNumber;

//退出 未完全退出
+(void)logout;



//充值
+ (NSURLSessionDataTask *)rechargeWithBlock:(void (^)(NSDictionary *posts, NSError *error))block withAmount:(NSString *)amountString;


//// 汇付充值
//+ (NSURLSessionDataTask *)rechargeHuifuWithBlock:(void (^)(NSDictionary *posts, NSError *error))block withAmount:(NSString *)amountString;

//汇付提现
+ (NSURLSessionDataTask *)drawFromFHWithBlock:(void (^)(NSDictionary *posts, NSError *error))block withAmount:(NSString *)amountString;

////汇付购买
//+ (NSURLSessionDataTask *)purchaseFromFHWithBlock:(void (^)(NSDictionary* posts, NSError *error))block withAmount:(NSString *)amountString;

//购买
+ (NSURLSessionDataTask *)purchaseWithBlock:(void (^)(NSDictionary * posts, NSError *error))block withMoneyAccount:(NSString *)MoneyString withBid:(NSString *)bid withRedPocketId:(NSArray *)pocketIDArray withRedPcoketAccount:(NSString *)pocketAccount;
//绑定银行卡
+ (NSURLSessionDataTask *)bindBankCardWithBlock:(void (^)(NSDictionary * posts, NSError *error))block;

//身份认证后获取真实姓名
+ (NSURLSessionDataTask *)getRealNameWithBlock:(void (^)(NSDictionary * posts, NSError *error))block;


//向服务器发送设备类型和channelID
+(NSURLSessionDataTask *)putPropertyWithBlock:(void (^)(NSDictionary * posts, NSError *error))block withChannelID:(NSString *)channelID  withType:(NSString *)deviceType withUserId:(NSString *)userID;

//发送找回密码的验证码
+ (void)pushThevrtifidPasswordWithBlock:(void (^)(NSString * posts, NSError *error))block withPhoneNumber:(NSString *)phoneNumber;

//通过验证码设置新密码
+ (void)changeUsersPasswordWithBlock:(void (^)(NSString * posts, NSError *error))block withVertifiedCode:(NSString *)vertifiedCode withNewPassword:(NSString *)newPassword;
@end
