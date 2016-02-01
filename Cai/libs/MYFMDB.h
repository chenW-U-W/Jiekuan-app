//
//  FMDBViewController.h
//  Cai
//
//  Created by 启竹科技 on 15/7/27.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
@class User;
@interface MYFMDB : NSObject
{
    FMDatabase *db;
    NSString *database_path;
    
}
- (void)creatDateBase;

- (void)createTable;

- (void) insertDataWithUser:(User *)user withPassWord:(NSString *)password;

- (void) updateData:(User *)user;

- (BOOL) selectData:(NSString *)mobile;

- (NSString *)selectKeyWordFromTableWithData:(NSString *)mobile;

- (BOOL) isTableOK;

@end
