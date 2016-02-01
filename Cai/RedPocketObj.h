//
//  RedPocketObj.h
//  Cai
//
//  Created by csj on 15/9/11.
//  Copyright (c) 2015年 财来. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedPocketObj : NSObject
//红包部分
@property (nonatomic,assign) int packetID;//红包id（----）
@property (nonatomic,strong) NSString *rednum;//红包序列号
@property (nonatomic,assign) int facevalue;//红包面值(----)
@property (nonatomic,assign) float addtime;//红包添加时间
@property (nonatomic,assign) float shelftime;//红包有效期
@property (nonatomic,assign) float overtime;//红包过期时间(----)
@property (nonatomic,assign) int is_used;//红包是否已使用
@property (nonatomic,assign) int owner;//红包所有者
@property (nonatomic,assign) int note;//红包来源
@property (nonatomic,assign) int borrow_id;//红包使用到具体哪个标的标号
@property (nonatomic,assign) int usetime;//红包使用时间
@property (nonatomic,assign) int is_success;//红包是否使用成功
@property (nonatomic,assign) NSString *transmat;//使用红包时投资的金额(----)

+ (NSURLSessionDataTask *)getRedPocketWithBlock:(void (^)(id posts, NSError *error))block ;
@end
