//
//  XHRefreshFooter.m
//  XHRefreshViewControllerExample
//
//  Created by zhuxiaohui on 2017/9/4.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import "XHRefreshFooter.h"
#import "MJRefresh.h"

@interface XHRefreshFooter()
@property(nonatomic,strong) UILabel *leftLine;
@property(nonatomic,strong) UILabel *rightLine;
@end

@implementation XHRefreshFooter
#pragma mark 在这里做一些初始化配置（比如添加子控件）
-(void)prepare
{
    [super prepare];
    [self addSubview:self.leftLine];
    [self addSubview:self.rightLine];
}
#pragma mark 在这里设置子控件的位置和尺寸
-(void)placeSubviews
{
    [super placeSubviews];
    [self setTitle:@"我可是有底线的" forState:MJRefreshStateNoMoreData];
    CGFloat textWidth = 120;
    CGFloat lineWidth = (self.mj_w-textWidth-30)/2.0;
    self.leftLine.frame = CGRectMake(15, self.mj_h/2.0, lineWidth, 0.5);
    self.rightLine.frame = CGRectMake(15+lineWidth+textWidth, self.mj_h/2.0,lineWidth , 0.5);
}
#pragma mark 监听控件的刷新状态
-(void)setState:(MJRefreshState)state
{
    [super setState:state];
    
    if(state == MJRefreshStateNoMoreData){
        self.leftLine.hidden = NO;
        self.rightLine.hidden = NO;
    }else{
        self.leftLine.hidden = YES;
        self.rightLine.hidden = YES;

    }
}
#pragma mark - lazy
-(UILabel *)leftLine
{
    if(_leftLine==nil)
    {
        _leftLine = [[UILabel alloc] init];
        _leftLine.hidden = YES;
        _leftLine.backgroundColor = self.stateLabel.textColor;
    }
    return _leftLine;
}
-(UILabel *)rightLine
{
    if(_rightLine==nil)
    {
        _rightLine = [[UILabel alloc] init];
        _rightLine.hidden = YES;
        _rightLine.backgroundColor = self.stateLabel.textColor;
    }
    return _rightLine;
}

@end
