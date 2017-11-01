//
//  SuspensionView.m
//  FYPQDaily
//
//  Created by FYP on 2017/10/30.
//  Copyright © 2017年 FYP. All rights reserved.
//

/*
 思路:
 1.界面：UIButtom，一个按钮。
 2.初始化:注意调整布局的时机，如果是直接基于 frame 来布局的，应该确保在初始化的时候只添加视图，而不去设置它们的frame，把设置子视图 frame 的过程全部放到 layoutSubviews 方法里。
 3.动画:
 4个过程：
 */

#import "SuspensionView.h"
#import "MenuView.h"

@interface SuspensionView()

@property (nonatomic, strong) UIButton *suspensionButton;
@end

@implementation SuspensionView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _suspensionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_suspensionButton addTarget:self action:@selector(clickSuspensionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_suspensionButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _suspensionButton.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _suspensionButton.tag = _SuspensionButtonStyle;
}

#pragma event
- (void)clickSuspensionButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (_SuspensionButtonStyle == SuspensionButtonStyleQType || _SuspensionButtonStyle == SuspensionButtonStyleCloseType) {
        [UIView animateWithDuration:0.5f animations:^{
            [self AnimationWithOffsetY:80];
        } completion:^(BOOL finish){
            [self SpringAnimationOffset:0];
            if(_SuspensionButtonStyle == SuspensionButtonStyleQType) {
                self.SuspensionButtonStyle = SuspensionButtonStyleCloseType;
                if (self.delegate && [self.delegate respondsToSelector:@selector(popupMenuView)]) {
                    [self.delegate popupMenuView];
                }
                return ;
            }
            if(_SuspensionButtonStyle == SuspensionButtonStyleCloseType) {
                self.SuspensionButtonStyle = SuspensionButtonStyleQType;
                if (self.delegate && [self.delegate respondsToSelector:@selector(closeMenuView)]) {
                    [self.delegate closeMenuView];
                }
                return ;
            }
        }];
    }
    
    if (_SuspensionButtonStyle == SuspensionButtonStyleBackType) {
        _SuspensionButtonStyle = SuspensionButtonStyleBackType;
        if (self.delegate && [self.delegate respondsToSelector:@selector(closeMenuView)]) {
            [self.delegate back];
        }
        return ;
    }
    
    if (_SuspensionButtonStyle == SuspensionButtonStyleBackType2) {
        _SuspensionButtonStyle = SuspensionButtonStyleBackType2;
        if (self.delegate && [self.delegate respondsToSelector:@selector(backToMenuView)]) {
            [self.delegate backToMenuView];
        }
        return ;
    }
    
    
    
}

#pragma mark --- Animation
//位移动画
- (void)AnimationWithOffsetY:(CGFloat)offsetY
{
    CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    ani.toValue = @(offsetY);
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.suspensionButton.layer addAnimation:ani forKey:@"translationY"];
}

//弹簧动画
- (void)SpringAnimationOffset:(CGFloat)offsetY
{
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"transform.translation.y"];
    springAnimation.stiffness          = 5000;
    springAnimation.mass               = 10.0;
    springAnimation.damping            = 200.0;
    springAnimation.initialVelocity    = 5.f;
    springAnimation.duration           = springAnimation.settlingDuration;
    springAnimation.fromValue    = @(80);
    springAnimation.toValue      = @(offsetY);
    springAnimation.removedOnCompletion = NO;
    springAnimation.fillMode = kCAFillModeForwards;
    springAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.suspensionButton.layer addAnimation:springAnimation forKey:@"springAnimationY"];
}

#pragma Getter/Setter
- (void)setSuspensionButtonStyle:(NSInteger)SuspensionButtonStyle
{
    _SuspensionButtonStyle = SuspensionButtonStyle;
    NSString *imageName = [[NSString alloc] init];
    if (_SuspensionButtonStyle == SuspensionButtonStyleQType) {
        imageName = @"c_Qdaily button_54x54_";
    }else if (_SuspensionButtonStyle == SuspensionButtonStyleCloseType) {
        imageName = @"c_close button_54x54_";
    }else if (_SuspensionButtonStyle == SuspensionButtonStyleBackType) {
        imageName = @"navigation_back_round_normal";
    }else {
        imageName = @"homeBackButton";
    }
    [_suspensionButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

@end
