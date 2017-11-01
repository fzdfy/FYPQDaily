//
//  LoopView.h
//  FYPQDaily
//
//  Created by FYP on 2017/11/1.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoopView : UIView

@property (nonatomic, strong) NSArray *newsUrlArray;

- (void)loopViewDataWithImageArray:(NSArray *)imageArray
                        titleArray:(NSArray *)titleArray;
- (void)startTimer;
- (void)stopTimer;
@end
