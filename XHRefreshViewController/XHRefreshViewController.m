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

static NSInteger  pageDefault = 1;//默认页码
static NSInteger  pageCountDefault =  15;//每页默认个数

@interface XHRefreshViewController ()
@property (nonatomic, assign) TableState tableState;//tableView状态
@property (nonatomic, assign) NSInteger pageCount;//每页条数
@property (nonatomic, copy) NSString *pageCountKey;//每页条数key
@property (nonatomic, assign) NSInteger page;//页码
@property (nonatomic, copy) NSString *pageKey;//页码key
@property (nonatomic, copy) NSString *requestUrl;//请求url
@property (nonatomic, strong) NSMutableDictionary *requestParameters;//请求参数

@end

@implementation XHRefreshViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.dataArray = [[NSMutableArray alloc] init];
        self.requestParameters = [[NSMutableDictionary alloc] init];
        self.tableViewStyle = UITableViewStylePlain;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupRefreshTableView];
    
    [self setupRefreshHeaderAndFooter];
    
     __weak typeof(self) weakSelf = self;
    self.xhRequestSuccess = ^(NSArray *responseArray) {
        
        [weakSelf handleResponseArray:responseArray];
        
    };
    
    self.xhRequestFailure = ^(id error) {
        
        [weakSelf handleResponseError:error];
    };
    
}
-(void)setupRefreshTableView
{
    _refreshTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.xh_width,self.view.xh_height-64) style: self.tableViewStyle];
    _refreshTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_refreshTableView];

}
-(void)setupRefreshHeaderAndFooter
{
   __weak typeof(self) weakSelf = self;
    if(!_hideHeaderRefresh)
    {
        _refreshTableView.mj_header = [XHRefreshHeader headerWithRefreshingBlock:^{
            
            [weakSelf refreshStart];
        }];
    }
    if(!_hideFooterRefresh)
    {
        _refreshTableView.mj_footer = [XHRefreshFooter footerWithRefreshingBlock:^{
            
            [weakSelf loadMoreStart];
        }];
        
    }
}

-(void)setRequestUrl:(NSString *)url parameters:(NSDictionary *)parameters pageKey:(NSString *)pageKey page:(NSNumber *)page pageCountKey:(NSString *)pageCountKey pageCount:(NSNumber *)pageCount
{
    _requestUrl = url;
    [_requestParameters removeAllObjects];
    [_requestParameters addEntriesFromDictionary:parameters];
    _pageKey = pageKey;
    _pageCountKey = pageCountKey;
    if(page) pageDefault = page.integerValue;
    if(pageCount) pageCountDefault = pageCount.integerValue;
    self.tableState = TableStateIdle;
    [self refreshStart];
}
-(void)refreshStart{
    
    if(!_requestUrl.length) return;
    
    _page = pageDefault;
    self.tableState = TableStateRefreshing;
    [XHRefreshEmptyView removeOnView:_refreshTableView];
    [self sendRequestWithUrl:_requestUrl parameters:[self currentRequestParameters]];
}
-(void)loadMoreStart
{
    if(!_requestUrl.length) return;
    
    _page ++;
    self.tableState = TableStateLoading;
    [XHRefreshEmptyView removeOnView:_refreshTableView];
    [self sendRequestWithUrl:_requestUrl parameters:[self currentRequestParameters]];
}

-(NSDictionary *)currentRequestParameters
{
    NSMutableDictionary *dict = _requestParameters.mutableCopy;
    if(_pageKey.length) [dict setObject:@(_page) forKey:_pageKey];
    if(_pageCountKey.length) [dict setObject:@(_pageCount) forKey:_pageCountKey];
    return dict;
}
#pragma mark - 以下方法教给子类来实现
-(void)sendRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters{}
-(void)handleArray:(NSArray *)array{}


#pragma mark - 私有方法
//处理请求成功数组
-(void)handleResponseArray:(NSArray *)responseArray
{
    if(_tableState == TableStateRefreshing)//刷新
    {
        [self.dataArray removeAllObjects];
        //没有数据
        if(responseArray.count==0)
        {
            
            
            
        }
        else//有数据
        {
            [self handleArray:responseArray];
            
        }
    }
    else if (_tableState == TableStateLoading)//加载更多
    {
        if(responseArray.count<self.pageCount)//数据不满一页
        {
            
            
            
        }
        
        [self  handleArray:responseArray];
    }
    
    self.tableState = TableStateIdle;//设置为空闲状态
}
//处理失败情况
-(void)handleResponseError:(id)error{

    if(_dataArray.count==0)
    {
        [XHRefreshEmptyView showOnView:self.refreshTableView imgName:EmptyImage_default title:EmptyTitle_LoadError_default clickBlock:^{
            
            [self refreshStart];
        }];
    }
    
     self.tableState = TableStateIdle;//设置为空闲状态
}

- (void)setTableState:(TableState)state
{
    _tableState = state;
    if (state == TableStateRefreshing) {
        
        [_refreshTableView.mj_footer resetNoMoreData];//消除没有更多数据的状态
        
        if (_refreshTableView.mj_footer.isRefreshing) [_refreshTableView.mj_footer endRefreshing];
    }
    else if (state == TableStateLoading) {
        
        if (_refreshTableView.mj_header.isRefreshing) [_refreshTableView.mj_header endRefreshing];
    }
    else if (state == TableStateIdle) {
        
        if(_refreshTableView.mj_header.isRefreshing) [_refreshTableView.mj_header endRefreshing];
        
        if(_refreshTableView.mj_footer.isRefreshing) [_refreshTableView.mj_footer endRefreshing];
    }
}
-(void)removeEmptyView
{
    //[XHRefreshEmptyView rem]

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
