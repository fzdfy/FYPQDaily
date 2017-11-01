//
//  ReaderToolView.m
//  FYPQDaily
//
//  Created by FYP on 2017/11/1.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "ReaderToolView.h"

@interface ReaderToolView ()
@property (nonatomic, strong)UIButton *backButton;
@property (nonatomic, strong)UIButton *commentButton;
@property (nonatomic, strong)UIButton *likeButton;
@property (nonatomic, strong)UIButton *shareButton;
@property (nonatomic, strong)UIView *separator;
@end
@implementation ReaderToolView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        _separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        _separator.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_separator];

        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"toolbarBack"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
        
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setImage:[UIImage imageNamed:@"toolbarComment"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(clickCommentButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commentButton];
        
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setImage:[UIImage imageNamed:@"toolbarLike"] forState:UIControlStateNormal];
        [_likeButton addTarget:self action:@selector(clickLikeButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeButton];
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"toolbarShare"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(clickShareButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _backButton.frame = CGRectMake(4, 0, 70, self.frame.size.height);
    CGFloat x = self.frame.size.width - 20*3 - 10*4;
    _commentButton.frame = CGRectMake(x, 0, 20, self.frame.size.height);
    _likeButton.frame = CGRectMake(x-30, 0, 20, self.frame.size.height);
    _shareButton.frame = CGRectMake(x-30*2, 0, 20, self.frame.size.height);
}

- (void)clickBackButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(back)]) {
        [self.delegate back];
    }
}

@end
