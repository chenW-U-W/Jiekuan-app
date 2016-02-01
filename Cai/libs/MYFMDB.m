//
//  FMDBViewController.m
//  Cai
//
//  Created by 启竹科技 on 15/7/27.
//  Copyright (c) 2015年 启竹科技. All rights reserved.
//

#import "MyFMDB.h"
#import "User.h"

#define DBNAME    @"userinfo.sqlite"
#define ID        @"id"
#define USERID    @"userid"
#define PHONENUM  @"phonenum"
#define KEYWORD   @"keyWord+num"
#define TABNAME   @"userPhoneAndKeyWord"

@interface MYFMDB ()

@end

@implementation MYFMDB


//获取数据库存放的沙盒路径
- (NSString *)databaseFilePath
{
    
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    NSLog(@"%@",filePath);
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"db.sqlite"];
    return dbFilePath;
    
}
- (void)creatDateBase
{
    db = [FMDatabase databaseWithPath:[self databaseFilePath]];
}

//创建表
- (void)createTable{
    //sql 语句
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!db) {
        [self creatDateBase];
    }
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER, '%@' TEXT, '%@' TEXT)",TABNAME,ID,USERID,PHONENUM,KEYWORD];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            DLog(@"error when creating db table");
        } else {
            DLog(@"success to creating db table");
        }
        [db close];
        
    }
}


-(void) insertDataWithUser:(User *)user withPassWord:(NSString *)password{
    if (!db) {
        [self creatDateBase];
    }
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%ld', '%@', '%@')",
                               TABNAME,USERID,PHONENUM,KEYWORD,(long)user.userId, user.mobile, password];
        BOOL res = [db executeUpdate:insertSql1];
        
        if (!res) {
            DLog(@"error when insert db table");
        } else {
            DLog(@"success to insert db table");
        }
        [db close];
        
    }
    
}

-(void) updateData:(User *)user{
    if (!db) {
        [self creatDateBase];
    }
    if ([db open]) {
        NSString *updateSql = [NSString stringWithFormat:
                               @"UPDATE '%@' SET '%@' = '%@' WHERE '%@' = '%@'",
                               TABNAME,   KEYWORD,  @"654321" ,USERID,  @"1234"];
        BOOL res = [db executeUpdate:updateSql];
        if (!res) {
            NSLog(@"error when update db table");
        } else {
            NSLog(@"success to update db table");
        }
        [db close];
        
    }
    
}




-(BOOL) selectData:(NSString *)mobile{
    if (!db) {
        [self creatDateBase];
    }
    
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@ where %@ = %@",TABNAME,PHONENUM,mobile];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            int Id = [rs intForColumn:ID];
            NSInteger  userid = [rs intForColumn:USERID];
            NSString * phonenum = [rs stringForColumn:PHONENUM];
            NSString * keyword = [rs stringForColumn:KEYWORD];
            NSLog(@"id = %d, name = %ld, age = %@  address = %@", Id, (long)userid, phonenum, keyword);
            if ([mobile isEqualToString:phonenum]) {
                return YES;
            }
        }
        [db close];
       
    }
     return NO;
}

//表是否存在
- (BOOL) isTableOK
{
    if (!db) {
        [self creatDateBase];
    }
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", TABNAME];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)selectKeyWordFromTableWithData:(NSString *)mobile
{
    if (!db) {
        [self creatDateBase];
    }
    
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@ where %@ = %@",TABNAME,PHONENUM,mobile];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            int Id = [rs intForColumn:ID];
            NSInteger  userid = [rs intForColumn:USERID];
            NSString * phonenum = [rs stringForColumn:PHONENUM];
            NSString * keyword = [rs stringForColumn:KEYWORD];
           
            if ([mobile isEqualToString:phonenum]) {
                 NSLog(@"id = %d, name = %ld, age = %@  address = %@", Id, (long)userid, phonenum, keyword);
                return keyword;
            }
        }
        [db close];
        
    }
    return @"";
}


@end
