//
//  HomeNewsTableViewCell.h
//  FYPQDaily
//
//  Created by FYP on 2017/10/29.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCellLayout.h"

@interface CellBottomView : UIView

@property (nonatomic, strong) UIImageView *commentImageView; // 评论icon
@property (nonatomic, strong) UIImageView *praiseImageView;  // 喜欢icon
@property (nonatomic, strong) UILabel *newsTypeLabel;        // 新闻类型（设计、智能、娱乐等）
@property (nonatomic, strong) UILabel *commentlabel;         // 该条新闻的评论数
@property (nonatomic, strong) UILabel *praiseLabel;          // 点赞数
@property (nonatomic, strong) UILabel *timeLabel;            // 新闻发布时间

@end

@interface CellNewsView : UIView
@property (nonatomic, strong) UIImageView *newsImageView;    // 新闻图片
@property (nonatomic, strong) UILabel *newsTitleLabel;       // 新闻标题
@property (nonatomic, strong) UILabel *subheadLabel;         // 新闻副标题

@end

@interface HomeNewsTableViewCell : UITableViewCell
@property (nonatomic, strong) CellNewsView *newsView;
@property (nonatomic, strong) CellBottomView *bottomView;
@property (nonatomic, strong) UIView *cellBackgroundView;
@property (nonatomic, strong) NewsCellLayout *layout;;
- (void)setLayout:(NewsCellLayout *)layout;
@end
