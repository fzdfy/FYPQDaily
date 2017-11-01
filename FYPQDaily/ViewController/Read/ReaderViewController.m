//
//  ReaderViewController.m
//  FYPQDaily
//
//  Created by FYP on 2017/11/1.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "ReaderViewController.h"
#import <WebKit/WebKit.h>
#import "ReaderToolView.h"

@interface ReaderViewController ()<WKNavigationDelegate, UIScrollViewDelegate, ReaderToolViewDelegate>
{
    CGFloat _contentOffset_Y;   //WKWebView滑动后Y轴偏移量
}
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) ReaderToolView *readerToolView;

/** 加载动画view*/
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIImageView *loadingImageView;

@end

@implementation ReaderViewController

- (void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    _webView.navigationDelegate = self;
    _webView.scrollView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_newsUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:7.0]];
    [self.view addSubview:_webView];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView addSubview:self.loadingImageView];
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    _readerToolView = [[ReaderToolView alloc] initWithFrame:CGRectMake(0, MAIN_SCREEN_HEIGHT+64, MAIN_SCREEN_WIDTH, 44)];
    _readerToolView.delegate = self;
//    _readerToolView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_readerToolView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark --- ReaderToolViewDelegate
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    [self destoryToolbarView];
}

#pragma mark --- WKNavigationDelegate

/// WXWebView开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.loadingImageView startAnimating];
}

/// WXWebView加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //渐隐加载动画
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.loadingView setAlpha:0];
                     } completion:^(BOOL finished) {
                         [self.loadingImageView stopAnimating];
                         [self.loadingView removeFromSuperview];
                         self.loadingView = nil;
                     }];
}

/// WXWebView加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.loadingImageView stopAnimating];
//    [MBProgressHUD promptHudWithShowHUDAddedTo:self.view message:@"加载失败，请检查网络"];
    [NSThread sleepForTimeInterval:1.3];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollDelegate
/// 滚动时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //_contentOffset_Y + 80（隐藏悬浮按钮的阀值）
    if (scrollView.contentOffset.y > _contentOffset_Y + 80) {
        [self hideSuspenstionButton];
    } else if (scrollView.contentOffset.y < _contentOffset_Y) {
        [self showSuspenstionButton];
    }
}

/// 停止滚动时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _contentOffset_Y = scrollView.contentOffset.y;
    //滑动到底部时显示悬浮按钮
    CGFloat screen_h = [UIScreen mainScreen].bounds.size.height;
    if ((_contentOffset_Y + screen_h) == scrollView.contentSize.height) {
        [self showSuspenstionButton];
    }
}

/// 显示悬浮按钮
- (void)showSuspenstionButton {
    if (_readerToolView.layer.frame.origin.y == MAIN_SCREEN_HEIGHT - 55) return;
    [UIView animateWithDuration:0.2
                     animations:^{
                         CGRect tempFrame = _readerToolView.layer.frame;
                         tempFrame.origin.y -= 55;
                         _readerToolView.layer.frame = tempFrame;
                     }];
}

/// 隐藏悬浮按钮
- (void)hideSuspenstionButton {
    if (_readerToolView.layer.frame.origin.y == MAIN_SCREEN_HEIGHT) return;
    [UIView animateWithDuration:0.2
                     animations:^{
                         CGRect tempFrame = _readerToolView.layer.frame;
                         tempFrame.origin.y += 55;
                         _readerToolView.layer.frame = tempFrame;
                     }];
}

/// 销毁toolbarView
- (void)destoryToolbarView {
    _readerToolView.hidden = YES;
    _readerToolView = nil;
}

#pragma lazy

/// 懒加载，加载动画界面
- (UIView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        _loadingView.backgroundColor = [UIColor whiteColor];
    }
    return _loadingView;
}

///懒加载，加载动画imageview
- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] init];
        NSMutableArray *imageMutableArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 93; i ++) {
            NSString *imageName = [NSString stringWithFormat:@"QDArticleLoading_0%d",i];
            UIImage *image = [UIImage imageNamed:imageName];
            [imageMutableArray addObject:image];
        }
        _loadingImageView.animationImages = imageMutableArray;
        _loadingImageView.animationDuration = 3.0;
        _loadingImageView.animationRepeatCount = MAXFLOAT;
    }
    return _loadingImageView;
}

- (void)setNewsUrl:(NSString *)newsUrl {
    _newsUrl = newsUrl;
}

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
