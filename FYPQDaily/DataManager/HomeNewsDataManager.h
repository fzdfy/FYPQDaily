//
//  HomeNewsDataManager.h
//  FYPQDaily
//
//  Created by FYP on 2017/10/30.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HomeNewsDataManagerBlock) (id data);

@interface HomeNewsDataManager : NSObject

//请求数据成功后返回新闻数据回调的block
@property (nonatomic, copy) HomeNewsDataManagerBlock newsDataBlock;

+ (instancetype)sharedInstance;
/**
 请求新闻数据
 
 @param lastKey 加载新数据的key
 */
- (void)requestHomeNewsDataWithLastKey:(NSString *)lastKey;

- (void)newsDataBlock:(HomeNewsDataManagerBlock)block;
@end
