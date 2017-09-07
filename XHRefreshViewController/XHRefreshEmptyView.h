//
//  XHRefreshEmptyView.h
//  XHRefreshViewControllerExample
//
//  Created by zhuxiaohui on 2017/9/4.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EmptyImage_default @"empty_img"
#define EmptyTitle_default @"暂无数据"
#define EmptyTitle_LoadError_default @"加载失败,请点击重试!"


@interface XHRefreshEmptyView : UIView

@property (nonatomic, copy) void(^clickBlcok)();

- (instancetype)initWithFrame:(CGRect)frame imgName:(NSString *)imgName title:(NSString *)title;

+(void)showOnView:(UIView *)view imgName:(NSString *)imgName title:(NSString *)title clickBlock:(void(^)())clickBlock;
+(void)removeOnView:(UIView *)view;

@end

