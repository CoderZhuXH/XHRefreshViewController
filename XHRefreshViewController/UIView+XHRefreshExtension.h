//
//  UIView+XHRefreshExtension.h
//  XHRefreshViewControllerExample
//
//  Created by zhuxiaohui on 2017/9/4.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XHRefreshExtension)
@property (nonatomic, assign) CGSize  xh_size;
@property (nonatomic, assign) CGFloat xh_width;
@property (nonatomic, assign) CGFloat xh_height;
@property (nonatomic, assign) CGFloat xh_x;
@property (nonatomic, assign) CGFloat xh_y;
@property (nonatomic, assign) CGFloat xh_centerX;
@property (nonatomic, assign) CGFloat xh_centerY;
@property (nonatomic, assign) CGFloat xh_right;
@property (nonatomic, assign) CGFloat xh_bottom;
+(UIView *)viewMIN;
@end
