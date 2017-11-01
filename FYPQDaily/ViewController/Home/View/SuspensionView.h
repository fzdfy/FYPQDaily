//
//  SuspensionView.h
//  FYPQDaily
//
//  Created by FYP on 2017/10/30.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <UIKit/UIKit.h>


/// 悬浮按钮种类（tag）枚举
typedef NS_ENUM(NSInteger, SuspensionButtonStyle) {
    SuspensionButtonStyleQType = 1,   //  Qlogo样式 （弹出JFMenuView）
    SuspensionButtonStyleCloseType,   //  关闭样式（关闭JFMenuView）
    SuspensionButtonStyleBackType,    //  返回样式（返回到JFHomeViewController根View）
    SuspensionButtonStyleBackType2    //  返回样式2（返回到JFMenuView）
};

@protocol SuspensionViewDelegate <NSObject>
@optional
- (void)popupMenuView;
- (void)closeMenuView;
- (void)back;
- (void)backToMenuView;
@end

@interface SuspensionView : UIView

@property (nonatomic, assign) NSInteger SuspensionButtonStyle;    // 悬浮按钮样式
@property (nonatomic, weak) id<SuspensionViewDelegate> delegate;
@end
