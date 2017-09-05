//
//  NewsViewController.m
//  XHRefreshViewControllerExample
//
//  Created by zhuxiaohui on 2017/9/5.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import "NewsViewController.h"
#import "Network.h"
#import "NewsCell.h"
#import "MJExtension.h"

static NSString *const id_NewsCell = @"NewsCell";

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"XHRefreshViewControllerExample";
    
    //设置代理
    self.refreshTableView.delegate = self;
    self.refreshTableView.dataSource = self;
    self.refreshTableView.tableFooterView = [UIView viewMIN];
    
    //注册cell
    [self.refreshTableView registerNib:[UINib nibWithNibName:id_NewsCell bundle:nil] forCellReuseIdentifier:id_NewsCell];
    
    //设置数据请求参数
    [self setRequestUrl:@"http://www.qinto.com/wap/index.php?ctl=article_cate&act=api_app_getarticle_cate" parameters:nil pageKey:@"p" page:@(1) pageCountKey:@"num" pageCount:@(15)];
    
}

#pragma mark - 实现父类方法
/**
  发送数据请求
 */
-(void)sendRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters
{
    [Network GET:url parameters:parameters success:^(NSDictionary * responseObject) {
        
        NSArray *array = responseObject[@"data"];//获取返回数组
        self.responseArray = array;//赋值给responseArray
        
    } failure:^(NSError *error) {

        self.responseArray = nil;
    }];
}

/**
 处理数据
 */
-(void)handleArray:(NSArray *)array
{
    //转模型数组
    NSArray *modelArray = [NewsModel mj_objectArrayWithKeyValuesArray:array];
    //将模型数组中的模型直接添加到数据源数据,不用管是刷新,还是加载更多,内部已处理好
    [self.dataArray addObjectsFromArray:modelArray];
    //刷新视图
    [self.refreshTableView reloadData];
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
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
    NewsModel *model = self.dataArray[indexPath.row];
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
