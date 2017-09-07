//
//  Network.m
//  XHRefreshViewControllerExample
//
//  Created by zhuxiaohui on 2017/9/5.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import "Network.h"
#import "AFNetworking.h"

#ifdef DEBUG

#define XHLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else

#define XHLog(...)

#endif

static AFHTTPSessionManager *_manager;

@implementation Network

+(void)initialize
{
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain", nil];
}

+(void)GET:(NSString *)URLString parameters:(id)parameters success:(Success)success failure:(Failure)failure
{

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSInteger status = [responseObject[@"status"] integerValue];
        if(status==200){
            
            if(success) success(responseObject);
            
        }else{
            
            NSString *message = responseObject[@"message"];
            if(failure) failure([NetworkError errorWithResponseCode:status responseMsg:message]);
        }
        
        XHLog(@"地址:\n%@\n 参数:\n%@\n 结果:\n%@",URLString,parameters,[self JSONStringWithDictionary:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if(failure) failure([NetworkError errorWithServerError:error]);
        XHLog(@"error:%@",error);
    }];
}

+(NSString *)JSONStringWithDictionary:(NSDictionary *)dict
{
    NSString * string=[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    return string;
    
}
@end
