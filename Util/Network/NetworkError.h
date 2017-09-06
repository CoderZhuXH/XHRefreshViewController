//
//  NetworkError.h
//  XHRefreshViewControllerExample
//
//  Created by zhuxiaohui on 2017/9/6.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkError : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *msg;

+(NetworkError *)errorWithServerError:(NSError *)serverError;
+(NetworkError *)errorWithResponseCode:(NSInteger)responseCode responseMsg:(NSString *)responseMsg;

@end
