//
//  XHRefreshViewController.h
//  XHRefreshViewControllerExample
//
//  Created by zhuxiaohui on 2017/9/4.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XHRefreshExtension.h"

typedef void (^ XHRefreshViewControllerRequestSuccess)(NSArray * responseArray);
typedef void (^ XHRefreshViewControllerRequestFailure)(id error);

typedef NS_ENUM(NSInteger, TableState)
{
    TableStateRefreshing,   //刷新
    TableStateIdle,         //空闲
    TableStateLoading       //加载
};

@interface XHRefreshViewController : UIViewController
@property (nonatomic, strong) UITableView *refreshTableView;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@property (nonatomic, assign,readonly) TableState tableState;//tableView状态
@property (nonatomic, strong) NSMutableArray *dataArray;//数据源数组
@property (nonatomic, assign) BOOL hideHeaderRefresh;//YES:不需要下拉刷新,默认NO
@property (nonatomic, assign) BOOL hideFooterRefresh;//YES:不需要上拉加载,默认NO
@property (nonatomic, copy) XHRefreshViewControllerRequestSuccess xhRequestSuccess;
@property (nonatomic, copy) XHRefreshViewControllerRequestFailure xhRequestFailure;
#pragma mark - 以下方法交给子类来调用
/**
 设置请求参数

 @param url 请求地址
 @param parameters 请求参数
 @param pageKey 传给服务器页码key
 @param page 第一页的页码
 @param pageCountKey 传给服务器每页数据条数key
 @param pageCount 每页数据条数
 */
-(void)setRequestUrl:(NSString *)url parameters:(NSDictionary *)parameters pageKey:(NSString *)pageKey page:(NSNumber *)page pageCountKey:(NSString *)pageCountKey pageCount:(NSNumber *)pageCount;

#pragma mark - 以下方法交给子类来实现
#pragma mark - 必须实现
/**
 发送数据请求
 */
-(void)sendRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters;

/**
 处理数据
 */
-(void)handleArray:(NSArray *)array;

#pragma mark - 可选
/**
 无数据时占位视图(frame:相对于refreshTableView)-不实现此方法将使用默认占位视图
 */
//-(UIView *)emptyView;
@end
