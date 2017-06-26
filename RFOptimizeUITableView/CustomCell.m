//
//  CustomCell.m
//  RFOptimizeUITableView
//
//  Created by rocky on 2017/6/26.
//  Copyright © 2017年 rocky. All rights reserved.
//

#import "CustomCell.h"
#import "UIImageView+WebCache.h"

#define KImageUrl @"https://air.jtrips.com/webApp/images/bg_home_1221.jpg"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeigt [UIScreen mainScreen].bounds.size.height

@interface CustomCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@end


@implementation CustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        self.titleLabel = titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:titleLabel];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + 45, KScreenWidth, 100)];
        self.imgView = icon;
        [self.contentView addSubview:icon];
    }
    return self;
}
- (void)setModel:(CustomModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:KImageUrl] placeholderImage:nil];
}

- (void)loadData{
    if (self.model) {
        self.titleLabel.text = self.model.title;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:KImageUrl] placeholderImage:nil];
    }
}
- (void)clear{
    self.titleLabel.text = @"";
    self.imgView.image = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
