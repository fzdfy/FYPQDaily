//
//  NSTimer+Blocks.h
//  FYPQDaily
//
//  Created by FYP on 2017/11/1.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Blocks)

+ (NSTimer *)fyp_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;
@end
