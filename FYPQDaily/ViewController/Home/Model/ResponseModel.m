//
//  ResponseModel.m
//  FYPQDaily
//
//  Created by FYP on 2017/10/29.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "ResponseModel.h"

@implementation JFCategoryModel
@end



@implementation JFPostModel

// 设置模型属性名和字典key之间的映射关系
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"subhead":@"description"};// 返回的字典，key为模型属性名，value为转化的字典的多级key
}

@end

@implementation JFFeedsModel
@end



@implementation ResponseModel
@end



@implementation JFBannersModel
@end

