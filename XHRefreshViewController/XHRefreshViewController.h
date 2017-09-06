//
//  XHRefreshViewController.h
//  XHRefreshViewControllerExample
//
//  Created by zhuxiaohui on 2017/9/4.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XHRefreshExtension.h"

/**
 数据请求成功回调

 @param responseArray 请求到的数组
 @param object 其它参数(没有传nil)
 */
typedef void (^ XHRefreshViewControllerRequestSuccess)(NSArray * responseArray,id object);

/**
 数据请求失败回调
 */
typedef void (^ XHRefreshViewControllerRequestFailure)();

typedef NS_ENUM(NSInteger, TableState)
{
    TableStateRefreshing,   //刷新
    TableStateIdle,         //空闲
    TableStateLoading       //加载
};

@interface XHRefreshViewController : UIViewController
@property (nonatomic, strong) UITableView *refreshTableView;
@property (nonatomic, assign,readonly) TableState tableState;//tableView状态
@property (nonatomic, strong) NSMutableArray *dataSourceArray;//数据源数组
@property (nonatomic, assign) BOOL hideHeaderRefresh;//YES:不需要下拉刷新,默认NO(请在子类init方法中设置)
@property (nonatomic, assign) BOOL hideFooterRefresh;//YES:不需要上拉加载,默认NO(请在子类init方法中设置)
@property (nonatomic, copy) XHRefreshViewControllerRequestSuccess requestSuccess;//请求成功参数回调
@property (nonatomic, copy) XHRefreshViewControllerRequestFailure requestFailure;//请求失败回调
#pragma mark - 以下方法交给子类来调用
/**
 设置请求参数

 @param url 请求地址
 @param parameters 请求参数
 @param pageKey 传给服务器页码key
 @param firstPage 第一页的页码
 @param pageCountKey 传给服务器每页数据条数key(没有传nil)
 @param pageCount 每页数据条数(没有传nil)
 */
-(void)setRequestUrl:(NSString *)url parameters:(NSDictionary *)parameters pageKey:(NSString *)pageKey firstPage:(NSNumber *)firstPage pageCountKey:(NSString *)pageCountKey pageCount:(NSNumber *)pageCount;

/**
 手动调用刷新页面(一般很少用到)
 */
-(void)refreshStart;

/**
 手动调用加载更多(一般不会用到)
 */
-(void)loadMoreStart;

#pragma mark - 以下方法交给子类来实现
#pragma mark - 必须实现
/**
 发送数据请求
 */
-(void)sendRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters;

/**
 处理数据
 */
-(void)handleArray:(NSArray *)array object:(id)object;

#pragma mark - 可选
/**
 设置tableView样式-不实现此方法默认UITableViewStylePlain
 */
-(UITableViewStyle)refreshTableViewStyle;
/**
 数据为空时占位视图(frame:相对于refreshTableView)-不实现此方法将使用默认占位视图
 */
-(UIView *)emptyView;

/**
 加载失败时占位视图(frame:相对于refreshTableView)-不实现此方法将使用默认占位视图
 */
-(UIView *)loadErrorView;
@end
