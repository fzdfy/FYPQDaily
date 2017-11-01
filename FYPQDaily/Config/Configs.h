//
//  Configs.h
//  BaseProject-OC
//
//  Created by 凤云鹏 on 2016/12/20.
//  Copyright © 2016年 FYP. All rights reserved.
//

#ifndef Configs_h
#define Configs_h

#import "Colors.h"
#import "Strings.h"
#import "Fonts.h"

/****************************** 懒加载 ***********************************/
// 懒加载
#define FYP_LAZY(object, assignment) (object = object ?: assignment)

/****************************** Weaky/Strong self ***********************************/
/**
 *  Weaky/Strong self
 */
#ifndef    weakify
#if __has_feature(objc_arc)

#define weakify( x ) \\
_Pragma("clang diagnostic push") \\
_Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \\
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \\
_Pragma("clang diagnostic push") \\
_Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \\
_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef    strongify
#if __has_feature(objc_arc)

#define strongify( x ) \\
_Pragma("clang diagnostic push") \\
_Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
try{} @finally{} __typeof__(x) x = __weak_##x##__; \\
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \\
_Pragma("clang diagnostic push") \\
_Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
try{} @finally{} __typeof__(x) x = __block_##x##__; \\
_Pragma("clang diagnostic pop")

#endif
#endif

#endif /* Configs_h */
