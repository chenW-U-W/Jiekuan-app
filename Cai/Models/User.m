//
//  User.m
//  Cai
//
//  Created by Cameron Ling on 4/29/15.
//  Copyright (c) 2015 启竹科技. All rights reserved.
//

#import "User.h"
#import "CailaiAPIClient.h"
#import "KeychainItemWrapper.h"
@implementation User

//单例
+ (instancetype)shared {
    static User *user = nil ;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        user = [[self alloc] init];

    });
    [self configureUser:user];
    return user;
}

+ (void)configureUser:(User *)user
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    user.userId    = [[defaults objectForKey:@"kUserId"] integerValue];
    user.mobile    = [defaults objectForKey:@"kUserMobile"];
    user.reg_time  = [defaults objectForKey:@"kUserRegTime"];
    user.realName  = [defaults objectForKey:@"kUserRealName"];
    user.sessionId = [defaults objectForKey:@"kUserSessionId"];

}

+ (void)saveUser:(NSDictionary *)attributes {
    //保留用户的id
    NSString * userid = [NSString stringWithFormat:@"%@", [attributes valueForKey:@"id"]];
    //退出时删除过每次登陆都需要保留
    [[NSUserDefaults standardUserDefaults] setObject:userid forKey:@"kUserId"];
    [[NSUserDefaults standardUserDefaults] setObject:[attributes valueForKey:@"mobile"] forKey:@"kUserMobile"];
    [[NSUserDefaults standardUserDefaults] setObject:[attributes valueForKey:@"reg_time"] forKey:@"kUserRegTime"];
    [[NSUserDefaults standardUserDefaults] setObject:[attributes valueForKey:@"real_name"] forKey:@"kUserRealName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}


//退出 删除
+ (void)cleanUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"kUserId"];
    [defaults removeObjectForKey:@"kUserMobile"];
    [defaults removeObjectForKey:@"kUserRegTime"];
    [defaults removeObjectForKey:@"kUserRealName"];
    [defaults removeObjectForKey:@"kSecValueData"];//移除手势密码
    
    //移除手势密码  伪移除  就是不显示并非重置手势密码
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isOpenGesturePassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//+(void)exitAndCreateNewUser
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    
//    
////    [defaults removeObjectForKey:@"kUserSessionId"];
////    [defaults removeObjectForKey:@"kUserDefaultsCookie"];
//    
//    
//    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isOpenGesturePassword"];
//    //重置手势
//    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
//    [keychin resetKeychainItem];
//    
//}

+ (NSURLSessionDataTask *)isRegisteredWithBlock:(void (^)(Boolean data, NSError *error))block
                                     withMobile:(NSString *)mobile {
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"user.isreg", @"sname",
                           mobile, @"mobile",
                           nil];
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        NSLog(@"是否已注册，返回成功");
        if (block) {
            block([[JSON valueForKey:@"data"] boolValue], nil);
        }
    } failure:^(NSError *error) {
        if (block) {
            block(false, error);
        }
    } method:@"POST"];
}
+ (NSURLSessionDataTask *)getMsgCodeWithBlock:(void (^)(Boolean data, NSError *error))block
                                     withMobile:(NSString *)mobile {
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"vcode.get", @"sname",
                           mobile, @"mobile",
                           nil];
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        NSLog(@"是否已注册，返回成功");
        if (block) {
            block([[JSON valueForKey:@"data"] boolValue], nil);
        }
    } failure:^(NSError *error) {
        if (block) {
            block(false, error);
        }
    } method:@"POST"];
}


+ (NSURLSessionDataTask *)registerWithBlock:(void (^)(NSDictionary *posts, NSError *error))block withMobile:(NSString *)mobile withPassword:(NSString *)password withRecommended:(NSString *)recommended withTelcode:(NSString *)telcode
{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"user.reg", @"sname",
                           mobile, @"mobile",
                           password, @"passwd",
                           recommended, @"recommended",
                           telcode,@"telcode",
                           nil];
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        NSLog(@"注册，返回成功");
        NSDictionary *responseDic = JSON;
        block(responseDic,nil);
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];
}

+ (NSURLSessionDataTask *)loginWithBlock:(void (^)(NSArray *posts, NSError *error))block
                                 withMobile:(NSString *)mobile
                               withPassword:(NSString *)password{
    [self signOut];
    
    //查看cookie过期时间
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"user.login", @"sname",
                           mobile, @"mobile",
                           password, @"passwd",
                           nil];
    NSURLSessionDataTask *task = [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        //显示cookie的有效日期：
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:CailaiAPIBaseURL]];
        NSHTTPCookie *Realcookie ;
        for (Realcookie in cookies) {
            NSDate *date = Realcookie.expiresDate;
            DLog(@"date:%@",date);
            
            break;
        }
//        //登录成功后保存cookie
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
//        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"kUserDefaultsCookie"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        id jsonDic = [JSON objectForKey:@"data"];
        [self saveUser:jsonDic];//这样做会有延迟...！

        if (block) {
            block(nil, nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    } method:@"POST"];
    
      

    
        return task;
}

+ (NSURLSessionDataTask *)authHuifuWithBlock:(void (^)(NSDictionary *posts, NSError *error))block  withPhoneNumber:(NSString *)phoneNumber{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"authentication.get", @"sname",
                           phoneNumber, @"mobile",
                           nil];
//    return [CailaiAPIClient requestWithParams:param setCookie:@"session_id=c63d1522eca3ccbc85dcc9e77498b0bd8" success:^(id JSON) {
    
    return [CailaiAPIClient requestWithParams:param setCookie:@"session_id=1234" success:^(id JSON) {
        
        NSLog(@"认证接口（cailai），返回成功");
        if (block) {
            block([JSON valueForKey:@"data"], nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];
}


+ (void)signOut {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
}

+(void)logout
{
    //清除userdefault
    [self cleanUser];
    //TODO 清除cookie
    // ...
    
}

+ (NSURLSessionDataTask *)rechargeWithBlock:(void (^)(NSDictionary *posts, NSError *error))block withAmount:(NSString *)amountString
{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"recharge.get", @"sname",
                           amountString, @"amount",
                           nil];    
        return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        DLog(@"充值成功");
            NSDictionary *responseDic = [JSON objectForKey:@"data"];
            if (block) {
                block(responseDic,nil);
            }
            
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];

}

+ (NSURLSessionDataTask *)drawFromFHWithBlock:(void (^)(NSDictionary *posts, NSError *error))block withAmount:(NSString *)amountString
{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"withdrawals.get", @"sname",
                           amountString, @"amount",
                           nil];
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        DLog(@"提现成功");
        NSDictionary *responseDic = [JSON objectForKey:@"data"];
        if (block) {
            block(responseDic,nil);
        }
        
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];
    
}

+ (NSURLSessionDataTask *)purchaseWithBlock:(void (^)(NSDictionary * posts, NSError *error))block withMoneyAccount:(NSString *)MoneyString withBid:(NSString *)bid withRedPocketId:(NSArray *)pocketIDArray withRedPcoketAccount:(NSString *)pocketAccount
{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"invest.money", @"sname",
                           MoneyString, @"money",
                           bid,@"bid",
                           pocketAccount,@"redvalue"
                           ,pocketIDArray,@"redid",
                           nil];
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        NSDictionary *dic = [JSON objectForKey:@"data"];
        
        if (block) {
            block(dic,nil);//104 也算正确的了 这样的话我们根据dic的大小来判断  只有一组key value的是104
        }
        
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];

}


+ (NSURLSessionDataTask *)bindBankCardWithBlock:(void (^)(NSDictionary * posts, NSError *error))block
{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"bind.bank", @"sname",
                           nil];
    
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        
        if (block) {
            block([JSON valueForKey:@"data"], nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];

}

+ (NSURLSessionDataTask *)getRealNameWithBlock:(void (^)(NSDictionary * posts, NSError *error))block
{

    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"realname.get", @"sname",
                           nil];
    
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        
        if (block) {
            block([JSON valueForKey:@"data"], nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];

}

+ (NSURLSessionDataTask *)putPropertyWithBlock:(void (^)(NSDictionary * posts, NSError *error))block withChannelID:(NSString *)channelID  withType:(NSString *)deviceType withUserId:(NSString *)userID
{

    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"user.pushdata.set", @"sname",channelID,@"channelId",deviceType,@"deviceType",
                                userID,@"userId",
                           nil];
    
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        
        
    } failure:^(NSError *error) {
        
    } method:@"POST"];


}

+ (void )pushThevrtifidPasswordWithBlock:(void (^)(NSString * posts, NSError *error))block withPhoneNumber:(NSString *)phoneNumber;

{
    
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"user.findpwd", @"sname",phoneNumber,@"phone",
                           nil];
    
    [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        if (block) {
            block([JSON valueForKey:@"stat"],nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil,error);
        }

    } method:@"POST"];
    
    
}

+ (void )changeUsersPasswordWithBlock:(void (^)(NSString * posts, NSError *error))block withVertifiedCode:(NSString *)vertifiedCode withNewPassword:(NSString *)newPassword;

{
    
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"user.validatefind", @"sname",vertifiedCode,@"code",newPassword,@"pwd",
                           nil];
    
    [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        if (block) {
            block([JSON valueForKey:@"stat"],nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
             block(nil,error);
        }
       
        
    } method:@"POST"];
    
    
}

@end
