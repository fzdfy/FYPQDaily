//
//  ReaderToolView.h
//  FYPQDaily
//
//  Created by FYP on 2017/11/1.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReaderToolViewDelegate <NSObject>
- (void)back;
@end
@interface ReaderToolView : UIView

@property (nonatomic, weak)id<ReaderToolViewDelegate> delegate;
@end
