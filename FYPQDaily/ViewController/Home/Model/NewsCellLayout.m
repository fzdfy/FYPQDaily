//
//  NewsCellLayout.m
//  FYPQDaily
//
//  Created by FYP on 2017/10/29.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "NewsCellLayout.h"

@implementation NewsCellLayout

- (instancetype)initWithModel:(JFFeedsModel *)model style:(NewsCellLayoutStyle)style {
    if (self = [super init]) {
        _model = model;
        _style = style;
    }
    return self;
}

- (CGFloat)height {
    switch (_style) {
            case NewsCellLayoutStyleAbove:
            return 330;
            break;
            case NewsCellLayoutStyleRight:
            return 130;
            break;
        default:
            return 360;
            break;
    }
}

@end
