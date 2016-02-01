//
//  HuifuHttpService.h
//  Cai
//
//  Created by Cameron Ling on 5/2/15.
//  Copyright (c) 2015 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuifuHttpService : NSObject


+ (NSString *)getFormDataString:(NSDictionary*)dictionary;

@end
