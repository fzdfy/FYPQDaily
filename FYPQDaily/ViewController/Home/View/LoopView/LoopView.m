//
//  LoopView.m
//  FYPQDaily
//
//  Created by FYP on 2017/11/1.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "LoopView.h"
#import "LoopViewLayout.h"
#import "LoopViewCell.h"
#import "NSTimer+Blocks.h"

static NSString *ID = @"loopViewCell";

@interface LoopView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LoopView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[LoopViewLayout alloc]init]];
        [_collectionView registerClass:[LoopViewCell class] forCellWithReuseIdentifier:ID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (void)loopViewDataWithImageArray:(NSArray *)imageArray
                        titleArray:(NSArray *)titleArray
{
    self.imageArray = imageArray;
    self.titleArray = titleArray;
    //添加分页器
    [self addSubview:self.pageControl];
    //回到主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.imageMutableArray.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        [self.collectionView reloadData];
        //添加定时器
        [self addTimer];
    });
}
#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count * 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LoopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.imageName = self.imageArray[indexPath.item % self.imageArray.count];
    cell.title = self.titleArray[indexPath.item % self.titleArray.count];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.didSelectCollectionItemBlock) {
//        self.didSelectCollectionItemBlock(_newsUrlMutableArray[indexPath.row % _newsUrlMutableArray.count]);
//    }
}

//- (void)didSelectCollectionItemBlock:(JFLoopViewBlock)block {
//    self.didSelectCollectionItemBlock = block;
//}

#pragma mark ---- UICollectionViewDelegate

/// 开始拖地时调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

/// 当滚动减速时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX / scrollView.bounds.size.width;
    if (page == 0) {
        page = self.imageArray.count;
        self.collectionView.contentOffset = CGPointMake(page * scrollView.frame.size.width, 0);
    }else if (page == [self.collectionView numberOfItemsInSection:0] - 1) {
        page = self.imageArray.count - 1;
        self.collectionView.contentOffset = CGPointMake(page * scrollView.frame.size.width, 0);
    }
    
    //设置UIPageControl当前页
    NSInteger currentPage = page % self.imageArray.count;
    self.pageControl.currentPage = currentPage;
    //添加定时器
    [self addTimer];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //移除定时器
    [self removeTimer];
}

/// 添加定时器
- (void)addTimer {
    if (self.timer) return;
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer fyp_scheduledTimerWithTimeInterval:4 block:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf nextImage];
        }
    }
                                                    repeats:YES];
}

/// 移除定时器
- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

/// 切换到下一张图片
- (void)nextImage {
    CGFloat offsetX = self.collectionView.contentOffset.x;
    NSInteger page = offsetX / self.collectionView.bounds.size.width;
    [self.collectionView setContentOffset:CGPointMake((page + 1) * self.collectionView.bounds.size.width, 0) animated:YES];
}

- (void)startTimer {
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)stopTimer {
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)dealloc {
    [self removeTimer];
}

#pragma lazy
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 270, self.frame.size.width, 30)];
        _pageControl.numberOfPages = self.imageArray.count;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    }
    return _pageControl;
}

- (void)setNewsUrlArray:(NSArray *)newsUrlArray
{
    _newsUrlArray = newsUrlArray;
}
@end
