//
//  XHRefreshEmptyView.m
//  XHRefreshViewControllerExample
//
//  Created by zhuxiaohui on 2017/9/4.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import "XHRefreshEmptyView.h"
#import "UIView+XHRefreshExtension.h"

@interface XHRefreshEmptyView()

@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,copy)NSString *imgName;
@property(nonatomic,copy)NSString *title;
@property (nonatomic, copy) void(^clickBlcok)();

@end

@implementation XHRefreshEmptyView

- (instancetype)initWithFrame:(CGRect)frame imgName:(NSString *)imgName title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imgName = imgName;
        self.title = title;
        [self setupUI];
        
        //self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

-(void)setupUI{
    
    self.userInteractionEnabled = YES;
    CGFloat width = 90.0;
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.xh_width-width)/2.0, (self.xh_height-width)/2.0-20, width, width)];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    _imgView.image = [UIImage imageNamed:self.imgName];
    //_imgView.backgroundColor = [UIColor redColor];
    [self addSubview:_imgView];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _imgView.frame.origin.y+_imgView.frame.size.height, self.bounds.size.width, 45)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.textColor = [UIColor lightGrayColor];
    _titleLab.text = self.title;
    _titleLab.numberOfLines = 0;
    _titleLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:_titleLab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];
    [self addGestureRecognizer:tap];
    
}

-(void)doTap:(UIGestureRecognizer *)tap
{
    if(self.clickBlcok) self.clickBlcok();
}

+(void)showOnView:(UIView *)view imgName:(NSString *)imgName title:(NSString *)title clickBlock:(void(^)())clickBlock
{
    CGFloat width = 180.0;
    XHRefreshEmptyView *emptyView = [[XHRefreshEmptyView alloc] initWithFrame:CGRectMake((view.xh_width-width)/2.0, (view.xh_height-width)/2.0, width, width) imgName:imgName title:title];
    emptyView.clickBlcok = [clickBlock copy];
    [self removeOnView:view];//先移除旧的
    [view addSubview:emptyView];
}

+(void)removeOnView:(UIView *)view
{
    for(UIView *v  in view.subviews)
    {
        if([v isKindOfClass:[self class]])
        {
            [v removeFromSuperview];
        }
    }
}
@end
