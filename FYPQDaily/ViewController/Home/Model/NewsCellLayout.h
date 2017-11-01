//
//  NewsCellLayout.h
//  FYPQDaily
//
//  Created by FYP on 2017/10/29.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ResponseModel.h"
/// 风格
typedef NS_ENUM(NSUInteger, NewsCellLayoutStyle) {
    NewsCellLayoutStyleAbove = 0,         // cellType = 0,图片在上，文字在下
    NewsCellLayoutStyleRight = 1,         // cellType = 1,图片在右，文字在左
    NewsCellLayoutStyleDetails = 2,       // cellType = 2,图片在上，文字在下，下方有“评论”和“喜欢”数值
};

@interface NewsCellLayout : NSObject

@property (nonatomic, assign) NewsCellLayoutStyle style;   // cell风格
@property (nonatomic, assign, readonly) CGFloat height;      // cell高度
@property (nonatomic, strong) JFFeedsModel *model;           // 数据

- (instancetype)initWithModel:(JFFeedsModel *)model style:(NewsCellLayoutStyle)style;

@end
