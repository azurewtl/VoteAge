//
//  AFnetworkingJS.m
//  UI家
//
//  Created by dlios on 14-9-2.
//  Copyright (c) 2014年 lanou3g.com 蓝鸥科技. All rights reserved.
//

#import "AFnetworkingJS.h"
#import "AFnetworking.h"
#import "VoteAge-Swift.h"
@implementation AFnetworkingJS
-(void)getDataWithURL:(NSString *)urlStr resultBlock:(void (^)(id))block{
    NSString *urlRequest = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlRequest];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        block(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@错误", error);
    }];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [queue addOperation:operation];
}
+(void)netWorkWithURL:(NSString *)urlStr resultBlock:(void (^)(id))block{
    
    AFnetworkingJS *js = [[AFnetworkingJS alloc]init];
    [js getDataWithURL:urlStr resultBlock:block];

    
}
@end
