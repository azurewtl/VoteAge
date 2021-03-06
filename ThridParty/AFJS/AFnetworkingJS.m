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
//    NSURL *url = [NSURL URLWithString:urlRequest];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *html = operation.responseString;
//        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
//        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        block(result);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSDictionary *dic = @{@"message": @"网络出故障啦!"};
//        block(dic);
//    }];
//            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//            [queue addOperation:operation];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"] forHTTPHeaderField:@"Authorization"];
    [manager GET:urlRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [NSNotificationCenter.defaultCenter postNotificationName:@"webout" object:nil userInfo:@{@"webout":@"1"}];
        NSDictionary *dic = @{@"message": @"网络出故障啦!"};
        block(dic);
    }];
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
//    [manager.requestSerializer setAuthorizationHeaderFieldWithToken:@"Bearer FxIw9HMBZ7hexur3ime1vLd427Ujax"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"] forHTTPHeaderField:@"Authorization"];
    //如果报接受类型不一致请替换一致text/html或别的
    NSLog(@"%@", [manager.requestSerializer HTTPRequestHeaders]);
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
        [NSNotificationCenter.defaultCenter postNotificationName:@"webout" object:nil userInfo:@{@"webout":@"1"}];
        NSDictionary *dic = @{@"message": @"网络出故障啦!"};
        block(dic);
    }];
}
+ (void)uploadJson:(NSDictionary *)dic url:(NSString *)url1 resultBlock:(void (^)(id))block{
    AFnetworkingJS *afjs = [[AFnetworkingJS alloc] init];
    [afjs upJson:dic url:url1 resultBlock:block];
}
- (void)deleteJson:(NSString *)url resultBlock:(void (^)(id))block{
    AFHTTPRequestOperationManager *manager =  [AFHTTPRequestOperationManager manager];
       [manager DELETE:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}
+ (void)removeJson:(NSString *)url resultBlock:(void (^)(id))block{
    AFnetworkingJS *js = [[AFnetworkingJS alloc]init];
    [js deleteJson:url resultBlock:block];
}
- (void)changeJson:(NSString *)url dic:(NSDictionary *)dic resultBlock:(void (^)(id))block{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = dic;
    NSString *url1 = url;
    [manager PATCH:url1 parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [NSNotificationCenter.defaultCenter postNotificationName:@"webout" object:nil userInfo:@{@"webout":@"1"}];
        NSDictionary *dic = @{@"message": @"网络出故障啦!"};
        block(dic);
    }];
}
+ (void)updateJson:(NSString *)url dic:(NSDictionary *)dic resultBlock:(void (^)(id))block{
    AFnetworkingJS *js = [[AFnetworkingJS alloc]init];
    [js changeJson:url dic:dic resultBlock:block];
}




@end
