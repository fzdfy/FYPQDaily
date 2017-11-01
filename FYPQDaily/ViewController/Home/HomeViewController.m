//
//  HomeViewController.m
//  FYPQDaily
//
//  Created by FYP on 2017/10/29.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "HomeViewController.h"
#import "YYFPSLabel.h"
#import <Masonry.h>
#import <MJRefresh.h>
#import "MJExtension.h"
#import "HomeNewsTableViewCell.h"
#import "HomeNewsDataManager.h"
#import "SuspensionView.h"
#import "MenuView.h"
#import "LoopView.h"
#import "ReaderViewController.h"
//#import "d"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,SuspensionViewDelegate>
{
    NSString *_last_key;        // 上拉加载请求数据时需要拼接到URL中的last_key
    NSString *_has_more;        // 是否还有未加载的文章（0：没有 1：有）
    CGFloat _contentOffset_Y;   // homeNewsTableView滑动后Y轴偏移量
    NSInteger _row;
    BOOL _isRuning;             // 定时器是否在运行
    BOOL _isBeyondBorder;       // 轮播view是否超出显示区域
}
//根view
@property (nonatomic, strong) UITableView *homeNewsTableView;

@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *refreshFooter;
@property (nonatomic, strong) HomeNewsTableViewCell *cell;

//数据
@property (nonatomic, strong) HomeNewsDataManager *manager;
@property (nonatomic, strong) ResponseModel *response;
@property (nonatomic, strong) NSArray *feedsArray;
@property (nonatomic, strong) NSArray *bannersArray;
@property (nonatomic, strong) NSArray *imageArray;
//悬浮按钮
@property (nonatomic, strong) SuspensionView *suspensionView;
@property (nonatomic, strong) MenuView *menuView;
@property (nonatomic, strong) LoopView *loopView;
//检测fps的label
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
/** 主要内容数组*/
@property (nonatomic, strong) NSMutableArray <NewsCellLayout *> *layouts;

@end

@implementation HomeViewController

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    //根view
    _homeNewsTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _homeNewsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _homeNewsTableView.delegate = self;
    _homeNewsTableView.dataSource = self;
    _homeNewsTableView.tableHeaderView = self.loopView;
    [self.view addSubview:_homeNewsTableView];
    
    //设置下拉刷新
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    self.refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.refreshHeader.stateLabel.hidden = YES;
    self.homeNewsTableView.mj_header = self.refreshHeader;
    
    _layouts = [[NSMutableArray alloc] init];
    //请求数据
    [self.manager requestHomeNewsDataWithLastKey:@"0"];
    
    //设置上拉加载
    self.refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadData]; //已在scrollViewDidScroll里提供了加载数据
    }];
    [self.refreshFooter setTitle:@"加载更多 ..." forState:MJRefreshStateRefreshing];
    [self.refreshFooter setTitle:@"没有更多内容了" forState:MJRefreshStateNoMoreData];
    self.homeNewsTableView.mj_footer = self.refreshFooter;
    
    //FPS Label
    _fpsLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(20, 44, 100, 30)];
    [_fpsLabel sizeToFit];
    [self.view addSubview:_fpsLabel];
    
    _suspensionView = [[SuspensionView alloc] initWithFrame:CGRectMake(10, MAIN_SCREEN_HEIGHT-70, 54, 54)];
    _suspensionView.SuspensionButtonStyle = SuspensionButtonStyleQType;
    _suspensionView.delegate = self;
    [self.view addSubview:_suspensionView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.manager requestHomeNewsDataWithLastKey:@"0"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (!_isBeyondBorder) {
        [self.loopView startTimer];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_isRuning && !_isBeyondBorder) {
        [self.loopView stopTimer];
        _isRuning = NO;
    }
}

#pragma private Method

/// 下拉刷新数据
- (void)refreshData {
    //下拉刷新时清空数据
    [_layouts removeAllObjects];
    [self.manager requestHomeNewsDataWithLastKey:@"0"];
}

/// 上拉加载数据
- (void)loadData {
    //判断是否还有更多数据
    if ([_has_more isEqualToString:@"1"]) {
        [self.manager requestHomeNewsDataWithLastKey:_last_key];
    }else if ([_has_more isEqualToString:@"0"]) {
        [self.refreshFooter setState:MJRefreshStateNoMoreData];
    }
}

- (void)startLoopView {
    //如果是上拉加载数据，就不再次加载轮播图
    if (_loopView.newsUrlArray.count == 0) {
        _isRuning = YES;
        NSMutableArray *imageMuatableArray = [[NSMutableArray alloc] init];
        NSMutableArray *titleMutableArray = [[NSMutableArray alloc] init];
        NSMutableArray *newsUrlMuatbleArray = [[NSMutableArray alloc] init];
        for (JFBannersModel *banner in self.bannersArray) {
            [imageMuatableArray addObject:banner.post.image];
            [titleMutableArray addObject:banner.post.title];
            [newsUrlMuatbleArray addObject:banner.post.appview];
        }
        [_loopView loopViewDataWithImageArray:[imageMuatableArray copy] titleArray:[titleMutableArray copy] ];
        _loopView.newsUrlArray = [newsUrlMuatbleArray copy];
        
//        __weak typeof(self) weakSelf = self;
//        [_loopView didSelectCollectionItemBlock:^(NSString *Url) {
//            [weakSelf pushToJFReaderViewControllerWithNewsUrl:Url];
//        }];
    }
}

/// push到JFReaderViewController
- (void)pushToJFReaderViewControllerWithNewsUrl:(NSString *)newsUrl {
    ReaderViewController *readerVC = [[ReaderViewController alloc] init];
    readerVC.newsUrl = newsUrl;
    [self.navigationController pushViewController:readerVC animated:YES];
}

#pragma mark --- UIScrollDelegate
/// 滚动时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > _contentOffset_Y + 80) {
        [self suspensionWithAlpha:0];
    } else if (scrollView.contentOffset.y < _contentOffset_Y) {
        [self suspensionWithAlpha:1];
    }
    
    if (scrollView.contentOffset.y > 400) {         // 轮播图滑出界面时，关闭定时器
        if (_isRuning) {
            [self.loopView stopTimer];
            _isBeyondBorder = YES;
            _isRuning = NO;
        }
    }else if (scrollView.contentOffset.y < 400) {   // 轮播图进入界面时，打开定时器
        if (!_isRuning) {
            [self.loopView startTimer];
            _isRuning = YES;
            _isBeyondBorder = NO;
        }
    }
    
    //提前加载数据，以提供更流畅的用户体验
    NSIndexPath *indexPatch = [_homeNewsTableView indexPathForRowAtPoint:CGPointMake(40, scrollView.contentOffset.y)];
    if (indexPatch.row == (_layouts.count - 10)) {
        if (_row == indexPatch.row) return;//避免重复加载
        _row = indexPatch.row;
        [self loadData];
    }
}

/// 停止滚动时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _contentOffset_Y = scrollView.contentOffset.y;
    //停止后显示悬浮按钮
    [self suspensionWithAlpha:1];
}

/// 设置悬浮按钮view透明度，以此显示和隐藏悬浮按钮
- (void)suspensionWithAlpha:(CGFloat)alpha {
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.suspensionView setAlpha:alpha];
                     }];
}


#pragma SuspensionViewDelegate

- (void)popupMenuView
{
    [self.view insertSubview:self.menuView belowSubview:self.suspensionView];
    self.menuView.suspensionView = self.suspensionView;
    [self.menuView popupMenuViewAnimation];
}

- (void)closeMenuView
{
    [self.menuView hideMenuViewAnimation];
}

- (void)back
{
    
}

- (void)backToMenuView
{
    [self.menuView hideNewsViewAnimation];
}


#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _layouts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((NewsCellLayout *)_layouts[indexPath.row]).height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"newsCell";
    self.cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!_cell) {
        _cell = [[HomeNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [_cell setLayout:_layouts[indexPath.row]];
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCellLayout *layout = _layouts[indexPath.row];
    if (![layout.model.type isEqualToString:@"0"]) {
        [self pushToJFReaderViewControllerWithNewsUrl:layout.model.post.appview];
    }else {
//        [MBProgressHUD promptHudWithShowHUDAddedTo:self.view message:@"抱歉，未抓取到相关链接！"];
    }
}

#pragma lazy

- (HomeNewsDataManager*)manager{
    return FYP_LAZY(_manager, ({
        _manager = [HomeNewsDataManager sharedInstance];
//        @weakify(self);
        __weak typeof(self) weakSelf = self;
        [_manager newsDataBlock:^(id data){
            
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.response = [ResponseModel mj_objectWithKeyValues:data];
                _last_key = strongSelf.response.last_key;
                _has_more = strongSelf.response.has_more;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //使用MJExtension讲josn数据转成数组
                    strongSelf.bannersArray = [JFFeedsModel mj_objectArrayWithKeyValuesArray:data[@"banners"]];
                    //使用MJExtension讲josn数据转成数组
                    strongSelf.feedsArray = [JFFeedsModel mj_objectArrayWithKeyValuesArray:data[@"feeds"]];
                    
                    for (JFFeedsModel *model in strongSelf.feedsArray) {
                        NewsCellLayout *layout = [[NewsCellLayout alloc] initWithModel:model style:[model.type integerValue]];
                        [strongSelf.layouts addObject:layout];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //停止刷新
                        [strongSelf.refreshHeader endRefreshing];
                        [strongSelf.refreshFooter endRefreshing];
                        [strongSelf startLoopView];
                        [strongSelf.homeNewsTableView reloadData];
                    });
                });
            }
        }];
        _manager;
    }));
}

- (MenuView*)menuView
{
    return FYP_LAZY(_menuView, ({
        _menuView = [[MenuView alloc] initWithFrame:self.view.frame];
        _menuView;
    }));
}

- (LoopView *)loopView {
    if (!_loopView) {
        _loopView = [[LoopView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 300)];
    }
    return _loopView;
}
//- (NSMutableArray <NewsCellLayout*>*)layouts
//{
//    return FYP_LAZY(_layouts, ({
//        _layouts = [NSMutableArray new];
//        _layouts;
//    }));
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
