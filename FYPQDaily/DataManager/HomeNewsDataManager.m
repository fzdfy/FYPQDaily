//
//  HomeNewsDataManager.m
//  FYPQDaily
//
//  Created by FYP on 2017/10/30.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "HomeNewsDataManager.h"
#import <AFNetworking.h>

#define kTimeOutInterval 10

@implementation HomeNewsDataManager

//单例模式
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

#pragma private Method
- (AFHTTPSessionManager*)manager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    return manager;
}

#pragma mark - GET方式请求新闻数据
- (void)requestHomeNewsDataWithLastKey:(NSString *)lastKey
{
    AFHTTPSessionManager *manager = [self manager];
    //拼接URL
    NSString *urlString = [NSString stringWithFormat:@"http://app3.qdaily.com/app3/homes/index/%@.json?",lastKey];

//    @weakify(self);
    __weak typeof(self) weakSelf = self;
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        //JSON数据转字典
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        @strongify(self);
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.newsDataBlock) {
            strongSelf.newsDataBlock([dataDictionary valueForKey:@"response"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        
    }];
}

- (void)newsDataBlock:(HomeNewsDataManagerBlock)block
{
    _newsDataBlock = block;
}
@end
