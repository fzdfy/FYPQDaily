//
//  LoopViewCell.m
//  FYPQDaily
//
//  Created by FYP on 2017/11/1.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "LoopViewCell.h"
#import <UIImageView+WebCache.h>

@interface LoopViewCell()

@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titlelabel;
@end
@implementation LoopViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0f];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.numberOfLines = 3;
        [self addSubview:titleLabel];
        
        self.iconView = iconView;
        self.titlelabel = titleLabel;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.iconView.frame = self.bounds;
    self.titlelabel.frame = CGRectMake(20, self.bounds.size.height - 110, self.bounds.size.width - 40, 110);
    self.titlelabel.shadowColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    self.titlelabel.shadowOffset = CGSizeMake(0.3, 0.3);
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    NSURL *imageUrl = [NSURL URLWithString:imageName];
    [self.iconView sd_setImageWithURL:imageUrl placeholderImage:nil];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titlelabel.text = title;
}
@end
