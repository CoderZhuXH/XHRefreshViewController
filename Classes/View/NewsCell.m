//
//  NewsCell.m
//  XHRefreshViewControllerExample
//
//  Created by zhuxiaohui on 2017/9/5.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"


@interface NewsCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *cateLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(NewsModel *)model
{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    _titleLab.text = model.title;
    _cateLab.text = model.cate_name;
    _timeLab.text = model.update_time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
