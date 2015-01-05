//
//  AFnetworkingJS.h
//  UI家
//
//  Created by dlios on 14-9-2.
//  Copyright (c) 2014年 lanou3g.com 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFnetworkingJS : NSObject
-(void)getDataWithURL:(NSString *)urlStr resultBlock:(void(^)(id result))block;
+(void)netWorkWithURL:(NSString *)urlStr resultBlock:(void(^)(id result))block;
-(void)upJson:(NSDictionary *)dic url:(NSString *)url1 resultBlock:(void(^)(id result))block;
+(void)uploadJson:(NSDictionary *)dic url:(NSString *)url1 resultBlock:(void(^)(id result))block;
-(void)deleteJson:(NSString *)url resultBlock:(void(^)(int result))block;
+(void)removeJson:(NSString *)url resultBlock:(void(^)(int result))block;
-(void)changeJson:(NSString *)url dic:(NSDictionary *)dic resultBlock:(void(^)(int result))block;
+(void)updateJson:(NSString *)url dic:(NSDictionary *)dic resultBlock:(void(^)(int result))block;
@end
