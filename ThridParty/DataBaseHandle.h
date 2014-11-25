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
-(void)createTable:(NSString *)list;
-(void)insertTab:(NSString *)insertsql;
-(void)updateT:(NSString *)sql;

-(void)deleteTab:(NSString *)sql;
-(NSMutableArray *)selectAll:(NSString *)sql;
@end
