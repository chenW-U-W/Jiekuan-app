//
//  Product.m
//  Cai
//
//  Created by Cameron Ling on 4/10/15.
//  Copyright (c) 2015 启竹科技. All rights reserved.
//

#import "Product.h"
#import "CailaiAPIClient.h"



@implementation Product

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _pid = [[attributes valueForKey:@"bid"] intValue];
    _bname = [attributes valueForKey:@"bname"];
    _interest_rate = [[attributes valueForKey:@"interest_rate"] floatValue];
    _ratio = [[attributes valueForKey:@"ratio"] intValue];
    _borrow_money = [[attributes valueForKey:@"borrow_money"] floatValue];
    _borrow_duration = [[attributes valueForKey:@"borrow_duration"] intValue];
    _borrow_min = [[attributes valueForKey:@"borrow_min"] floatValue];
    _borrow_type = [attributes valueForKey:@"borrow_type"];
    _add_datetime = [attributes valueForKey:@"add_datetime"];
    _borrow_status = [attributes valueForKey:@"borrow_status"];
    
    return self;
}



#pragma mark -
+ (NSURLSessionDataTask *)getProductsWithBlock:(void (^)(id posts, NSError *error,NSString *listType))block  withPageSize:(NSString *)pageSize  withPageNum:(NSString *)pageNum withSname:(NSString *)portString{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           portString, @"sname",
                           pageSize, @"page_size",
                           pageNum, @"page_num",
                           nil];
    
    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
         NSArray *responseArray = [JSON objectForKey:@"data"];
        if ([portString isEqualToString:@"borrow.list"]) {
            for (NSDictionary *responseDic in responseArray) {
                Product *productObj = [[Product alloc] initWithAttributes:responseDic];
                [mutableArray addObject:productObj];
                
            }
        }
        if (block) {
            
            block( [NSArray arrayWithArray:(NSArray *)mutableArray] ,nil,portString);
                    
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(@"请求失败", error,nil);
        }
    } method:@"POST"];
}

//+ (NSURLSessionDataTask *)getProductsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
//    
//    return [[CailaiAPIClient sharedClient] GET:CailaiAPIProductList parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
//        NSArray *postsFromResponse = [JSON valueForKeyPath:@"data"];
//        NSMutableArray *mutableProducts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
//        for (NSArray *products in postsFromResponse) {
//            for (NSDictionary *attributes in products) {
//                Product *product = [[Product alloc] initWithAttributes:attributes];
//                [mutableProducts addObject:product];
//            }
//        }
//        
//        if (block) {
//            block([NSArray arrayWithArray:mutableProducts], nil);
//        }
//    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
//        if (block) {
//            block([NSArray array], error);
//        }
//    }];
//}
@end
