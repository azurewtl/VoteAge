//
//  DataBaseHandle.m
//  UIDHome
//
//  Created by dlios on 14-9-9.
//  Copyright (c) 2014年 lanou3g.com 蓝鸥科技. All rights reserved.
//

#import "DataBaseHandle.h"
#import "VoteAge-Swift.h"

@implementation DataBaseHandle
+(DataBaseHandle *)shareInstance{
    static DataBaseHandle *dbhandle = nil;
    if(dbhandle == nil){
        dbhandle = [[DataBaseHandle alloc]init];
    }
    return dbhandle;
}
-(void)openDB{
    NSString *s = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [s stringByAppendingPathComponent:@"ConTact.db"];
//                   NSLog(@"%@", path);
                   int result = sqlite3_open([path UTF8String], &dbPoint);
//                   NSLog(@"%d", result);
    
}
-(void)closeDB{
    int result = sqlite3_close(dbPoint);
//    NSLog(@"%d", result);
}

-(void)createTable:(NSString *)list{
//    NSString *sql = @"create table Contact(userInital tex, userName tex, userID tex primary key, userImage tex, gender tex, city tex, descibed tex)";
   NSString *sql = list;
    int result = sqlite3_exec(dbPoint, [sql UTF8String], NULL, NULL, NULL);
    NSLog(@"建标%d", result);
}
-(void)insertTab:(NSString *)insertsql{
//    NSString *s = [NSString stringWithFormat:@"insert into Contact values('%@', '%@', '%@','%@', '%@', '%@', '%@')",initLetter, uname, uid, uimage, ugender, ucity, udescribe];
    NSString *s = insertsql;
    int result = sqlite3_exec(dbPoint, [s UTF8String], NULL, NULL, NULL);
    NSLog(@"插入%d", result);
}
-(void)updateT:(NSString *)sql{
//    NSString *s = [NSString stringWithFormat:@"update Contact set userName = '%@', userInital = '%@', userImage = '%@', gender = '%@', city = '%@', descibed = '%@' where userID = '%@'", name, str,  ima, gender, city, descri, pid];
    NSString *s = sql;
    int result = sqlite3_exec(dbPoint, [s UTF8String], NULL, NULL, NULL);
    NSLog(@"更新%d", result);
}

-(void)deleteTab:(NSString *)sql{
    NSString *s = sql;
    int result = sqlite3_exec(dbPoint, [s UTF8String], NULL, NULL, NULL);
    NSLog(@"删除%d", result);
}
-(NSMutableArray *)selectAll:(NSString *)sql{
    NSMutableArray *arr = [NSMutableArray array];
//    NSString *s = [NSString stringWithFormat:@"select * from Contact where userInital = '%@'", pID];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(dbPoint, [sql UTF8String], -1, &stmt, NULL);
    if(result == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            const unsigned char *namechar = sqlite3_column_text(stmt, 0);
            NSString *name = [NSString stringWithUTF8String:(const char *)namechar];
            const unsigned char *namechar1 = sqlite3_column_text(stmt, 1);
            NSString *name1 = [NSString stringWithUTF8String:(const char *)namechar1];
            const unsigned char *namechar2 = sqlite3_column_text(stmt, 2);
            NSString *name2 = [NSString stringWithUTF8String:(const char *)namechar2];
            const unsigned char *namechar3 = sqlite3_column_text(stmt, 3);
            NSString *name3 = [NSString stringWithUTF8String:(const char *)namechar3];
            const unsigned char *namechar4 = sqlite3_column_text(stmt, 4);
            NSString *name4 = [NSString stringWithUTF8String:(const char *)namechar4];
            const unsigned char *namechar5 = sqlite3_column_text(stmt, 5);
            NSString *name5 = [NSString stringWithUTF8String:(const char *)namechar5];
            const unsigned char *namechar6 = sqlite3_column_text(stmt, 6);
            NSString *name6 = [NSString stringWithUTF8String:(const char *)namechar6];
             NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:name forKey:@"initLetter"];
            [dic setObject:name1 forKey:@"userName"];
            [dic setObject:name2 forKey:@"userID"];
            [dic setObject:name3 forKey:@"userImage"];
            [dic setObject:name4 forKey:@"gender"];
            [dic setObject:name5 forKey:@"city"];
            [dic setObject:name6 forKey:@"describe"];
            [arr addObject:dic];
        }
    }
    sqlite3_finalize(stmt);
    return arr;
}
@end
