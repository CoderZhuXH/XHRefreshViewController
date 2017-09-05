//
//  Network.h
//  XHRefreshViewControllerExample
//
//  Created by zhuxiaohui on 2017/9/5.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ Success)(id responseObject);
typedef void (^ Failure)(NSError *error);

@interface Network : NSObject

+(void)GET:(NSString *)URLString parameters:(id)parameters success:(Success)success failure:(Failure)failure;

@end
