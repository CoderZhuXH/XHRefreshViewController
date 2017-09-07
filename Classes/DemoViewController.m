//
//  DemoViewController.m
//  XHRefreshViewControllerExample
//
//  Created by zhuxiaohui on 2017/9/5.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import "DemoViewController.h"
#import "Network.h"
#import "NewsCell.h"
#import "MJExtension.h"

static NSString *const id_NewsCell = @"NewsCell";

@interface DemoViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"XHRefreshViewControllerExample";
    
    //设置代理
    self.refreshTableView.delegate = self;
    self.refreshTableView.dataSource = self;
    self.refreshTableView.tableFooterView = [UIView viewMIN];
    
    //注册cell
    [self.refreshTableView registerNib:[UINib nibWithNibName:id_NewsCell bundle:nil] forCellReuseIdentifier:id_NewsCell];
    
    
    //设置请求参数
    //
    //@param url 请求地址
    //@param parameters 请求参数
    //@param pageKey 传给服务器页码key
    //@param firstPage 第一页的页码
    //@param pageCountKey 传给服务器每页数据条数key(没有传nil)
    //@param pageCount 每页数据条数(没有传nil)
    [self setRequestUrl:@"http://www.qinto.com/wap/index.php?ctl=article_cate&act=api_app_getarticle_cate" parameters:nil pageKey:@"p" firstPage:@(1) pageCountKey:@"num" pageCount:@(15)];//77页开始没数据
    
}

#pragma mark - 实现父类方法
/**
 在此方法内做数据请求
 */
-(void)sendRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters isRefresh:(BOOL)isRefresh{
    
    [Network GET:url parameters:parameters success:^(NSDictionary * responseObject) {
        
        NSArray *array = responseObject[@"data"];//获取返回数组
        self.requestSuccess(array,nil);//回调请求到的数组

    } failure:^(NetworkError *error) {
        
        self.requestFailure();//没获取到数据,回调失败
        
    }];
}

/**
 处理数据
 */
-(void)handleArray:(NSArray *)array object:(id)object isRefresh:(BOOL)isRefresh{
    
    if(isRefresh) [self.dataSourceArray removeAllObjects];//如果是刷新的话,清空数据源数组
    //转模型数组
    NSArray *modelArray = [NewsModel mj_objectArrayWithKeyValuesArray:array];
    //添加到数据源数组
    [self.dataSourceArray addObjectsFromArray:modelArray];
    //刷新视图
    [self.refreshTableView reloadData];
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:id_NewsCell];
    if(!cell)
    {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id_NewsCell];
    }
    NewsModel *model = self.dataSourceArray[indexPath.row];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
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
