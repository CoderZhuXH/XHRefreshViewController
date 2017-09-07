//
//  XHRefreshViewController.m
//  XHRefreshViewControllerExample
//
//  Created by zhuxiaohui on 2017/9/4.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import "XHRefreshViewController.h"
#import "XHRefreshHeader.h"
#import "XHRefreshFooter.h"
#import "XHRefreshEmptyView.h"


static NSInteger  _firstPage = 1;//第一页默认页码
static NSInteger  _pageCount =  15;//每页默认个数

@interface XHRefreshViewController ()
@property (nonatomic, assign) TableState tableState;//tableView状态
@property (nonatomic, copy) NSString *pageCountKey;//每页条数key
@property (nonatomic, assign) NSInteger page;//页码
@property (nonatomic, copy) NSString *pageKey;//页码key
@property (nonatomic, copy) NSString *requestUrl;//请求url
@property (nonatomic, strong) NSMutableDictionary *requestParameters;//请求参数
@property (nonatomic, strong) UIView *tempEmptyOrErrorView;

@end

@implementation XHRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.refreshTableView];
    
    [self setupRefreshHeaderAndFooter];
    
     __weak typeof(self) weakSelf = self;
    self.requestSuccess = ^(NSArray *responseArray,id object) {
        
        [weakSelf handleResponseArray:responseArray object:object];
        
    };
    
    self.requestFailure = ^(id error) {
        
        [weakSelf handleFailure];
    };
    
}

#pragma mark - 以下方法交给子类来调用
-(void)setRequestUrl:(NSString *)url parameters:(NSDictionary *)parameters pageKey:(NSString *)pageKey firstPage:(NSNumber *)firstPage pageCountKey:(NSString *)pageCountKey pageCount:(NSNumber *)pageCount
{
    _requestUrl = url;
    [self.requestParameters removeAllObjects];
    [self.requestParameters addEntriesFromDictionary:parameters];
    _pageKey = pageKey;
    _pageCountKey = pageCountKey;
    if(firstPage) _firstPage = firstPage.integerValue;
    if(pageCount) _pageCount = pageCount.integerValue;
    self.tableState = TableStateIdle;
    [self refreshStart];
}
-(void)refreshStart{
    
    if(!_requestUrl.length) return;
    
    _page = _firstPage;
    self.tableState = TableStateRefreshing;
    [self removeEmptyOrErrorView];//移除占位视图
    [self sendRequestWithUrl:_requestUrl parameters:[self currentRequestParameters] isRefresh:YES];
}
-(void)loadMoreStart
{
    if(!_requestUrl.length) return;
    
    _page ++;
    self.tableState = TableStateLoading;
    [self removeEmptyOrErrorView];//移除占位视图
    [self sendRequestWithUrl:_requestUrl parameters:[self currentRequestParameters] isRefresh:NO];
}

#pragma mark - 以下方法交给子类来实现
-(void)sendRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters isRefresh:(BOOL)isRefresh{}
-(void)handleArray:(NSArray *)array object:(id)object isRefresh:(BOOL)isRefresh{}
-(UITableViewStyle)refreshTableViewStyle{
    
    return UITableViewStylePlain;
}
-(UIView *)emptyView
{
    CGFloat width = 180.0;
    NSString *imgName = EmptyImage_default;
    NSString *title =  EmptyTitle_default;
    UIView *superView = self.refreshTableView;
    XHRefreshEmptyView *emptyView = [[XHRefreshEmptyView alloc] initWithFrame:CGRectMake((superView.xh_width-width)/2.0, (superView.xh_height-width)/2.0, width, width) imgName:imgName title:title];
    return emptyView;
}
-(UIView *)errorView
{
    CGFloat width = 180.0;
    NSString *imgName = EmptyImage_default;
    NSString *title =  EmptyTitle_LoadError_default;
    UIView *superView = self.refreshTableView;
    XHRefreshEmptyView *errorView = [[XHRefreshEmptyView alloc] initWithFrame:CGRectMake((superView.xh_width-width)/2.0, (superView.xh_height-width)/2.0, width, width) imgName:imgName title:title];
    __weak typeof(self) weakSelf = self;
    errorView.clickBlcok = ^{
      
        [weakSelf refreshStart];
    };
    return errorView;
}
#pragma mark - 私有方法
/**
 初始化头部/尾部刷新
 */
-(void)setupRefreshHeaderAndFooter
{
    __weak typeof(self) weakSelf = self;
    if(!_hideHeaderRefresh)
    {
        self.refreshTableView.mj_header = [XHRefreshHeader headerWithRefreshingBlock:^{
            
            [weakSelf refreshStart];
        }];
    }
    if(!_hideFooterRefresh)
    {
        self.refreshTableView.mj_footer = [XHRefreshFooter footerWithRefreshingBlock:^{
            
            [weakSelf loadMoreStart];
        }];
        
    }
}

-(NSDictionary *)currentRequestParameters
{
    NSMutableDictionary *dict = self.requestParameters.mutableCopy;
    if(_pageKey.length) [dict setObject:@(_page) forKey:_pageKey];
    if(_pageCountKey.length) [dict setObject:@(_pageCount) forKey:_pageCountKey];
    return dict;
}
//处理请求成功数组
-(void)handleResponseArray:(NSArray *)responseArray object:(id)object
{
    if(_tableState == TableStateRefreshing)//刷新
    {
        //没有数据
        if(responseArray.count==0)
        {
            [self addEmptyView];//添加占位空视图
        }
        else//有数据
        {
            if(responseArray.count<_pageCount)//数据不满一页
            {
                //已经加载完全部
                self.refreshTableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
        }
        
        [self handleArray:responseArray object:object isRefresh:YES];//处理数据
    }
    else if (_tableState == TableStateLoading)//加载更多
    {
        if(responseArray.count<_pageCount)//数据不满一页
        {
            //已经加载完全部
            self.refreshTableView.mj_footer.state = MJRefreshStateNoMoreData;
            
            if(responseArray.count==0) return;
        }
        
        [self handleArray:responseArray object:object isRefresh:NO];//处理数据
    }
    
    self.tableState = TableStateIdle;//设置为空闲状态
}
//处理失败情况
-(void)handleFailure{

    if(self.dataSourceArray.count==0)
    {
        [self addLoadErrorView];//添加空占位视图
    }
     self.tableState = TableStateIdle;//设置为空闲状态
}

- (void)setTableState:(TableState)state
{
    _tableState = state;
    if (state == TableStateRefreshing) {
        
        [self.refreshTableView.mj_footer resetNoMoreData];//消除没有更多数据的状态
       
       if (self.refreshTableView.mj_footer.isRefreshing) [self.refreshTableView.mj_footer endRefreshing];
    }
    else if (state == TableStateLoading) {
        
        if (self.refreshTableView.mj_header.isRefreshing) [self.refreshTableView.mj_header endRefreshing];
    }
    else if (state == TableStateIdle) {
        
        if(self.refreshTableView.mj_header.isRefreshing) [self.refreshTableView.mj_header endRefreshing];
        if(self.refreshTableView.mj_footer.isRefreshing) [self.refreshTableView.mj_footer endRefreshing];
    }
}
#pragma mark - lazy
-(NSMutableArray *)dataSourceArray
{
    if(_dataSourceArray==nil)
    {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;

}
-(NSMutableDictionary *)requestParameters
{
    if(_requestParameters==nil)
    {
        _requestParameters = [[NSMutableDictionary alloc] init];
    }
    
    return _requestParameters;
}
-(UITableView *)refreshTableView
{
    if(_refreshTableView==nil)
    {
        _refreshTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.xh_width,self.view.xh_height-64) style:[self refreshTableViewStyle]];
        _refreshTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _refreshTableView;
}
-(void)removeEmptyOrErrorView
{
    if(self.tempEmptyOrErrorView)
    {
        [self.tempEmptyOrErrorView removeFromSuperview];
        self.tempEmptyOrErrorView = nil;
    }
    self.refreshTableView.bounces = YES;
}
-(void)addEmptyView
{
    [self removeEmptyOrErrorView];//移除旧的
    self.tempEmptyOrErrorView = [self emptyView];
    [self.refreshTableView addSubview:self.tempEmptyOrErrorView];
    self.refreshTableView.bounces = NO;
}
-(void)addLoadErrorView
{
    [self removeEmptyOrErrorView];//移除旧的
    self.tempEmptyOrErrorView = [self errorView];
    [self.refreshTableView addSubview:self.tempEmptyOrErrorView];
    self.refreshTableView.bounces = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
