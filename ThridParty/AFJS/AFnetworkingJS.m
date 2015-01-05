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
        NSString *result = @"0";
        block(result);
    }];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [queue addOperation:operation];
    
}
+(void)netWorkWithURL:(NSString *)urlStr resultBlock:(void (^)(id))block{
    
    AFnetworkingJS *js = [[AFnetworkingJS alloc]init];
    [js getDataWithURL:urlStr resultBlock:block];

    
}
- (void)upJson:(NSDictionary *)dic url:(NSString *)url1 resultBlock:(void (^)(id))block{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    //传入的参数
    NSDictionary *parameters = dic;
    //你的接口地址
    NSString *url= url1;
   
    //发送请求

    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//        NSLog(@"%@",[responseObject valueForKey:@"message"]);
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        block(@"0");
    }];
}
+ (void)uploadJson:(NSDictionary *)dic url:(NSString *)url1 resultBlock:(void (^)(id))block{
    AFnetworkingJS *afjs = [[AFnetworkingJS alloc] init];
    [afjs upJson:dic url:url1 resultBlock:block];
}
- (void)deleteJson:(NSString *)url resultBlock:(void (^)(int))block{
    AFHTTPRequestOperationManager *manager =  [AFHTTPRequestOperationManager manager];
    [manager DELETE:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(0);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(1);
    }];
}
+ (void)removeJson:(NSString *)url resultBlock:(void (^)(int))block{
    AFnetworkingJS *js = [[AFnetworkingJS alloc]init];
    [js deleteJson:url resultBlock:block];
}
- (void)changeJson:(NSString *)url dic:(NSDictionary *)dic resultBlock:(void (^)(int))block{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = dic;
    NSString *url1 = url;
    [manager PUT:url1 parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(0);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(1);
    }];
}
+ (void)updateJson:(NSString *)url dic:(NSDictionary *)dic resultBlock:(void (^)(int))block{
    AFnetworkingJS *js = [[AFnetworkingJS alloc]init];
    [js changeJson:url dic:dic resultBlock:block];
}




@end
