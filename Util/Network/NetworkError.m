//
//  NetworkError.m
//  XHRefreshViewControllerExample
//
//  Created by zhuxiaohui on 2017/9/6.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import "NetworkError.h"

@implementation NetworkError

+(NetworkError *)errorWithServerError:(NSError *)serverError
{
    NSString *msg = [serverError.domain isEqualToString:@"NSURLErrorDomain"] ? @"服务器繁忙,请稍后重试" : serverError.domain;
    NSInteger code = serverError.code;
    
    NetworkError * error = [NetworkError new];
    error.msg = msg;
    error.code = code;
    return error;
}
+(NetworkError *)errorWithResponseCode:(NSInteger)responseCode responseMsg:(NSString *)responseMsg
{
    NetworkError * error = [NetworkError new];
    error.msg = responseMsg;
    error.code = responseCode;
    return error;
}
@end
