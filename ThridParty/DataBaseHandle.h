//
//  DataBaseHandle.h
//  UIDHome
//
//  Created by dlios on 14-9-9.
//  Copyright (c) 2014年 lanou3g.com 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DataBaseHandle : NSObject
{
    sqlite3 *dbPoint;
}
+(DataBaseHandle *)shareInstance;
-(void)openDB;
-(void)closeDB;
-(void)createTable;
-(void)insertTab:(NSString *)initLetter uname:(NSString *)uname uid:(NSString *)uid uimage:(NSString *)uimage ugender:(NSString *)ugender ucity:(NSString *)ucity udescibe:(NSString *)udescribe;
-(void)updateT:(NSString *)name str:(NSString *)str pid:(NSString *)pid ima:(NSString *)ima gender:(NSString *)gender city:(NSString *)city descri:(NSString *)descri;

-(void)deleteTab:(NSString *)idd;
-(NSMutableArray *)selectAll:(NSString *)pID;
@end
