//
//  LoopViewCell.h
//  FYPQDaily
//
//  Created by FYP on 2017/11/1.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoopViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imageName;    // 轮播图片url字符串 （需要转换成URL）
@property (nonatomic, copy) NSString *title;        // 轮播新闻标题
@end
