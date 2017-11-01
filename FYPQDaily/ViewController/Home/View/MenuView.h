//
//  MenuView.h
//  FYPQDaily
//
//  Created by FYP on 2017/10/30.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SuspensionView;
@interface MenuView : UIView

@property (nonatomic, weak)SuspensionView *suspensionView;

//交互动画
- (void)popupMenuViewAnimation;                 // 弹出菜单界面
- (void)hideMenuViewAnimation;                  // 隐藏菜单界面
- (void)hideNewsViewAnimation;                  //隐藏新闻分类栏


@end
