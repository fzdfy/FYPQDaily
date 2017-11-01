//
//  MenuView.m
//  FYPQDaily
//
//  Created by FYP on 2017/10/30.
//  Copyright © 2017年 FYP. All rights reserved.
//

/*
 一.界面分析：
 1.模糊背景
 2.头视图headView：4个按钮，
 3，下部视图
 4.下部视图内的菜单tableview列表
 
 二:初始化：基于自动布局
 三:交互动画
 
 */

#define KHeaderViewH 200
static NSString *ID = @"menuCell";
static NSString *NEWSID = @"newsCell";

#import "MenuView.h"
#import <Masonry.h>
#import "SuspensionView.h"

@interface MenuView ()<UITableViewDelegate,UITableViewDataSource>

//模糊背景
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;
//头视图
@property (nonatomic, strong) UIView *headerView;
//下部视图内的菜单列表
@property (nonatomic, strong) UITableView *menuTableView;
//新闻分类列表
@property (nonatomic, strong) UITableView *newsTableView;

/** 菜单cell按钮图片数组*/
@property (nonatomic, strong) NSArray *imageArray;
/** 菜单cell按钮标题数组*/
@property (nonatomic, strong) NSArray *titleArray;

/** 新闻cell按钮图片数组*/
@property (nonatomic, strong) NSArray *newsImageArray;
/** 新闻cell按钮标题数组*/
@property (nonatomic, strong) NSArray *newsTitleArray;

@end

@implementation MenuView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //模糊背景
        _blurEffectView = [[UIVisualEffectView alloc] init];
        _blurEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurEffectView.frame = frame;
        [self addSubview:_blurEffectView];
        //headerView
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, KHeaderViewH)];
        _headerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_headerView];
        //headerView内部视图
        [self addHeaderViewButtonAndLabel];
        //footerView
//        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, MAIN_SCREEN_HEIGHT, frame.size.width, MAIN_SCREEN_HEIGHT-KHeaderViewH)];
//        _footerView.backgroundColor = [UIColor clearColor];
//        [self addSubview:_footerView];
        //footerView内部视图
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KHeaderViewH, frame.size.width, MAIN_SCREEN_HEIGHT - KHeaderViewH - 80) style:UITableViewStylePlain];
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.backgroundColor = [UIColor clearColor];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        [self addSubview:_menuTableView];
    }
    return self;
}

#pragma privateMethod

- (void)addHeaderViewButtonAndLabel
{
    UILabel *sign = [[UILabel alloc] init];
    sign.text = @"好奇心日报";
    sign.textAlignment = NSTextAlignmentCenter;
    sign.textColor = [UIColor whiteColor];
    [self.headerView addSubview:sign];
    
    [sign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(200);
        make.height.offset(21);
        make.top.equalTo(self.headerView.mas_top).offset(KHeaderViewH * 0.2);
        make.centerX.equalTo(self.headerView.mas_centerX);
    }];
    NSArray *iconNameArray = @[@"setting_icon",
                               @"github_icon",
                               @"off_line_icon",
                               @"share_icon"];
    for (int i = 0; i < iconNameArray.count; i ++) {
        UIButton *headerViewButton = [[UIButton alloc] init];
        [headerViewButton addTarget:self action:@selector(headerViewButtonEvents:) forControlEvents:UIControlEventTouchDown];
        headerViewButton.tag = i;
        NSString *imageName = iconNameArray[i];
        [headerViewButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self.headerView addSubview:headerViewButton];
        //添加Masonry自动布局
        [headerViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(38);
            make.height.offset(57);
            make.top.equalTo(self.headerView.mas_top).offset(KHeaderViewH * 0.4);
            make.right.equalTo(self.headerView.mas_left).offset(((MAIN_SCREEN_WIDTH - 4 * 38) / 5 + 38) * (i + 1));
        }];
    }
}

#pragma public Method
//交互动画
// 弹出菜单界面
- (void)popupMenuViewAnimation
{
    //显示MenuView
    [self setHidden:NO];
    [self popAnimationYWithView:self.headerView fromValue:-KHeaderViewH toValue:0 speed:15.f];
    [self popAnimationYWithView:self.menuTableView fromValue:MAIN_SCREEN_HEIGHT-KHeaderViewH toValue:0 speed:15.f];
    
}

// 隐藏菜单界面
- (void)hideMenuViewAnimation
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         
//                         [self animationYWithView:self.headerView fromValue:<#(CGFloat)#> toValue:<#(CGFloat)#>];
//                         [self AnimationYWithView:self.headerView offsetY:-KHeaderViewH];
//                         [self AnimationYWithView:self.menuTableView offsetY:MAIN_SCREEN_HEIGHT];

                     } completion:^(BOOL finished) {
                         //隐藏MenuView
                         [self setHidden:YES];
                     }];
}

//弹出新闻栏
- (void)popupNewsViewAnimation
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         [self animationXWithView:self.menuTableView fromValue:0 toValue:-MAIN_SCREEN_WIDTH];
                         
                     } completion:^(BOOL finished) {
                         [self.menuTableView setHidden:YES];
                         [self.newsTableView setHidden:NO];
                         [self popAnimationXWithView:self.newsTableView fromValue:MAIN_SCREEN_WIDTH toValue:0 speed:25.f];
                         self.suspensionView.SuspensionButtonStyle = SuspensionButtonStyleBackType2;
                         [self popAnimationXWithView:self.suspensionView fromValue:MAIN_SCREEN_WIDTH toValue:0 speed:5.f];
                     }];
}

//隐藏新闻栏
- (void)hideNewsViewAnimation
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         [self animationXWithView:self.newsTableView fromValue:0 toValue:MAIN_SCREEN_WIDTH];
                         
                     } completion:^(BOOL finished) {
                         [self.menuTableView setHidden:NO];
                         [self.newsTableView setHidden:YES];
                         [self popAnimationXWithView:self.menuTableView fromValue:-MAIN_SCREEN_WIDTH toValue:0 speed:25.f];
                         self.suspensionView.SuspensionButtonStyle = SuspensionButtonStyleCloseType;
                         [self popAnimationXWithView:self.suspensionView fromValue:-MAIN_SCREEN_WIDTH toValue:0 speed:5.f];
                     }];
}

#pragma mark --- Animation
//动画
- (void)animationYWithView:(UIView *)view fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    ani.fromValue = @(fromValue);
    ani.toValue = @(toValue);
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:ani forKey:@"translationY"];
}

- (void)animationXWithView:(UIView *)view fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    ani.fromValue = @(fromValue);
    ani.toValue = @(toValue);
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:ani forKey:@"translationX"];
}

//弹簧动画
- (void)popAnimationYWithView:(UIView *)view fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue speed:(CGFloat)speed
{
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"transform.translation.y"];
    springAnimation.stiffness          = 5000;
    springAnimation.mass               = 10.0;
    springAnimation.damping            = 200.0;
    springAnimation.initialVelocity    = speed;
    springAnimation.duration           = springAnimation.settlingDuration;
    springAnimation.fromValue = @(fromValue);
    springAnimation.toValue      = @(toValue);
    springAnimation.removedOnCompletion = NO;
    springAnimation.fillMode = kCAFillModeForwards;
    springAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [view.layer addAnimation:springAnimation forKey:@"springAnimationY"];
}

//弹簧动画
- (void)popAnimationXWithView:(UIView *)view fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue speed:(CGFloat)speed
{
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"transform.translation.x"];
    springAnimation.stiffness          = 5000;
    springAnimation.mass               = 10.0;
    springAnimation.damping            = 200.0;
    springAnimation.initialVelocity    = speed;
    springAnimation.duration           = springAnimation.settlingDuration;
    springAnimation.fromValue = @(fromValue);
    springAnimation.toValue      = @(toValue);
    springAnimation.removedOnCompletion = NO;
    springAnimation.fillMode = kCAFillModeForwards;
    springAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [view.layer addAnimation:springAnimation forKey:@"springAnimationX"];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.menuTableView) {
        return self.imageArray.count;
    }
    if (tableView == self.newsTableView) {
        return self.newsImageArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.menuTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
            cell.textLabel.text = self.titleArray[indexPath.row];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 1) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        return cell;
    }
    
    if (tableView == self.newsTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NEWSID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NEWSID];
            cell.imageView.image = [UIImage imageNamed:_newsImageArray[indexPath.row]];
            cell.textLabel.text = self.newsTitleArray[indexPath.row];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    return nil;
}

#pragma mark --- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"新闻分类"]) {
        [self popupNewsViewAnimation];
        
    }else {
//        [MBProgressHUD promptHudWithShowHUDAddedTo:self message:@"待完善，您的支持是我最大的动力！"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.menuTableView) {
        return (MAIN_SCREEN_HEIGHT - KHeaderViewH - 80) / self.imageArray.count;
    }
    
    if (tableView == self.newsTableView) {
        return (MAIN_SCREEN_HEIGHT - KHeaderViewH - 80) / self.newsImageArray.count;
    }
    return 0;
}

#pragma lazy

- (UITableView*)newsTableView
{
    return FYP_LAZY(_newsTableView, ({
        _newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KHeaderViewH,self.frame.size.width, MAIN_SCREEN_HEIGHT - KHeaderViewH - 80) style:UITableViewStylePlain];
        _newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _newsTableView.backgroundColor = [UIColor clearColor];
        _newsTableView.delegate = self;
        _newsTableView.dataSource = self;
        [self addSubview:_newsTableView];
        _newsTableView;
    }));
}

//一级菜单数据
- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = @[@"menu_about",
                        @"menu_category",
                        @"menu_column",
                        @"menu_lab",
                        @"menu_noti",
                        @"menu_user",
                        @"menu_home"];
    }
    return _imageArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"关于我们",
                        @"新闻分类",
                        @"栏目中心",
                        @"好奇心研究所",
                        @"我的消息",
                        @"个人中心",
                        @"首页"];
    }
    return _titleArray;
}

//二级新闻数据
- (NSArray *)newsImageArray {
    if (!_newsImageArray) {
        _newsImageArray = @[@"menu_column",
                            @"menu_about",
                            @"menu_category",
                            @"menu_noti",
                            @"menu_lab",
                            @"menu_user",
                            @"menu_home"];
    }
    return _newsImageArray;
}

- (NSArray *)newsTitleArray {
    if (!_newsTitleArray) {
        _newsTitleArray = @[@"皇家马德里",
                            @"阿森纳",
                            @"曼联",
                            @"巴萨罗那",
                            @"多特蒙德",
                            @"马德里竞技",
                            @"曼城"];
    }
    return _newsTitleArray;
}
@end
