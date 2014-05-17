//
//  BaseImageScrollView.m
//  LuShiHelper
//
//  Created by Brian on 13-11-8.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseImageScrollView.h"
#import "BaseDownloaderCache.h"
#import "BaseImageView.h"

@implementation BaseImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    _scrollView = nil;
//    _pageControl = nil;
    _imageUrlsArray = nil;
    _defaultImage = nil;
}

- (void)setDefaultImage:(UIImage *)defaultImage
{
    if (_defaultImage) {
        _defaultImage = nil;
    }
    _defaultImage = defaultImage;
    
    if (_defaultImageView) {
        [_defaultImageView setImage:_defaultImage];
    }
}

- (void)setImageUrlsArray:(NSArray *)imageUrlsArray
{
    if (_imageUrlsArray) {
        _imageUrlsArray = nil;
    }
    
    if (_labelArray) {
        _labelArray = nil;
    }
    
    _imageUrlsArray = imageUrlsArray;
    
//    if ([imageUrlsArray count] > 1) {
//        [_imageUrlsArray addObject:[imageUrlsArray objectAtIndex:0]];
//        [_imageUrlsArray insertObject:[imageUrlsArray objectAtIndex:[imageUrlsArray count]-1] atIndex:0];
//    }
    
    [self setUpView];
}

- (void)setLabelArray:(NSArray *)labelArray
{
    if (_labelArray) {
        _labelArray = nil;
    }
    _labelArray = labelArray;
    
    [self setUpView];
}

- (void)setNormalPageButton:(UIImage *)normalPageButton
{
    _normalPageButton = normalPageButton;
    for (UIButton* button in _pageButtonArray) {
        [button setImage:_normalPageButton forState:UIControlStateNormal];
    }
}

- (void)setSelectedPageButton:(UIImage *)selectedPageButton
{
    _selectedPageButton = selectedPageButton;
    for (UIButton* button in _pageButtonArray) {
        [button setImage:_selectedPageButton forState:UIControlStateSelected];
    }
}

- (void)awakeFromNib
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.bounces = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        if (!_defaultImageView) {
            _defaultImageView= [[BaseImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
            [_scrollView addSubview:_defaultImageView];
        }
    }
    
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray arrayWithCapacity:1];
    }
    
    if(!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-26, self.bounds.size.width, 26)];
        [_shadowView setBackgroundColor:[UIColor blackColor]];
        [_shadowView setAlpha:0.2];
        [self addSubview:_shadowView];
        [_shadowView setHidden:YES];
    }
    
    if (!_labelView) {
        _labelView = [[UILabel alloc] initWithFrame:CGRectMake(10, self.bounds.size.height-26, self.bounds.size.width - 50, 26)];
        _labelView.text = @"";
        _labelView.textColor = [UIColor whiteColor];
        _labelView.backgroundColor = [UIColor clearColor];
        [self addSubview:_labelView];
    }
    
    if (!_pageButtonArray) {
        _pageButtonArray = [NSMutableArray arrayWithCapacity:1];
    }
}

#pragma mark - privateMethod
- (void)setUpView
{
// 初始化 pagecontrol
//    if (!_pageControl) {
//        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,self.bounds.size.height - PageToScroll_Height ,self.bounds.size.width,PageToScroll_Height)]; // 初始化mypagecontrol
//        [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
//        [_pageControl setPageIndicatorTintColor:[UIColor blackColor]];
//        _pageControl.numberOfPages = [_imageUrlsArray count];
//        _pageControl.currentPage = 0;
//        currentPage = 0;
//        [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
//        [self addSubview:_pageControl];
//    }
    
    if (!_imageUrlsArray || [_imageUrlsArray count] == 0 || !_labelArray || [_labelArray count] == 0) {
        [_shadowView setHidden:YES];
        return;
    }else{
        [_shadowView setHidden:NO];
    }
    
    if (_defaultImageView) {
        [_defaultImageView removeFromSuperview];
        _defaultImageView = nil;
    }
    
    NSArray* subViews = [_scrollView subviews];
    for (UIView* view in subViews) {
        [view removeFromSuperview];
    }
    [_imageViewArray removeAllObjects];
    
    for (UIButton* button in _pageButtonArray) {
        [button removeFromSuperview];
    }
    [_pageButtonArray removeAllObjects];
    
    for (int i = 0;i<[_imageUrlsArray count];i++)
    {
        BaseImageView *imageView = [[BaseImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width * i, 0, self.bounds.size.width, self.bounds.size.height)];
        imageView.placeHoldImage = _defaultImage;
        [imageView setBackgroundColor:[UIColor clearColor]];
        
        NSInteger index = (i + [_imageUrlsArray count] - 1)%[_imageUrlsArray count];
        imageView.imageUrlString = [NSString stringWithFormat:@"%@",[_imageUrlsArray objectAtIndex:index]];
        imageView.tag = index;
        
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPush:)];
        [imageView addGestureRecognizer:tap];
        
        [_imageViewArray addObject:imageView];
        
        [_scrollView addSubview:imageView];
        
        UIButton* pageButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 10 - i * (4+5), self.bounds.size.height-9-5, 5, 5)];
        [pageButton setImage:_normalPageButton forState:UIControlStateNormal];
        [pageButton setImage:_selectedPageButton forState:UIControlStateSelected];
        pageButton.tag = [_imageUrlsArray count] - i - 1;
        [_pageButtonArray insertObject:pageButton atIndex:0];
//        [pageButton addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
        if (i == [_imageUrlsArray count] - 1) {
            currentPageButton = pageButton;
            [currentPageButton setSelected:YES];
        }
        
        if (i == 0) {
            _labelView.text = [_labelArray objectAtIndex:i];
        }
    }
    
    for (UIButton* button in _pageButtonArray) {
        [self addSubview:button];
    }
    
    [_scrollView setContentSize:CGSizeMake(self.bounds.size.width * ([_imageUrlsArray count] + 2), self.bounds.size.height)];
    [_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
    
    
    
//    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}

- (void)imageViewPush:(UITapGestureRecognizer*)tap
{
    if ([_delegate respondsToSelector:@selector(didSelectImageViewIndex:)]) {
        [_delegate didSelectImageViewIndex:tap.view.tag];
    }
}

//- (void)changePage:(UIButton*)button
//{
//    CGFloat pagewidth = _scrollView.frame.size.width;
//    
//    int page = button.tag;
//    
//    if (page < currentPage) {
//        [button setSelected:YES];
//        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//    }else{
//        [button setSelected:YES];
//        [_scrollView setContentOffset:CGPointMake(pagewidth * 2, 0) animated:YES];
//    }
//}

//- (void)changePage:(UIPageControl*)pageControl
//{
//    CGFloat pagewidth = _scrollView.frame.size.width;
//    
//    int page = pageControl.currentPage;
//    
//    if (page < currentPage) {
//        pageControl.currentPage = currentPage;
//        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//    }else{
//        pageControl.currentPage = currentPage;
//        [_scrollView setContentOffset:CGPointMake(pagewidth * 2, 0) animated:YES];
//    }
//}

- (void)moveLeft
{
    NSInteger page = currentPageButton.tag + 1;//_pageControl.currentPage + 1;
    
    [currentPageButton setSelected:NO];
    
    if (page >= [_imageUrlsArray count]) {
//        _pageControl.currentPage = 0;
        currentPageButton = [_pageButtonArray objectAtIndex:0];
    }else if(page < 0){
        currentPageButton = [_pageButtonArray objectAtIndex:[_imageUrlsArray count] - 1];
//        _pageControl.currentPage = [_imageUrlsArray count] - 1;
    }else{
        currentPageButton = [_pageButtonArray objectAtIndex:page];
//        _pageControl.currentPage = page;
    }
    
    _labelView.text = [_labelArray objectAtIndex:currentPageButton.tag];
    
    [currentPageButton setSelected:YES];
    
    id object = [_imageViewArray objectAtIndex:0];
    [_imageViewArray removeObject:object];
    [_imageViewArray addObject:object];
    
    for (int i=0; i<[_imageViewArray count]; i++) {
        BaseImageView *imageView = [_imageViewArray objectAtIndex:i];
        [imageView setFrame:CGRectMake(self.bounds.size.width * i, 0, self.bounds.size.width, self.bounds.size.height)];
    }
    
//    currentPageButton = [_pageButtonArray objectAtIndex:page];
}

- (void)moveRight
{
    NSInteger page = currentPageButton.tag - 1;//_pageControl.currentPage
    
    [currentPageButton setSelected:NO];
    
    if(page < 0){
//        _pageControl.currentPage = [_imageUrlsArray count] - 1;
        currentPageButton = [_pageButtonArray objectAtIndex:[_imageUrlsArray count] - 1];
    }else if (page > [_imageUrlsArray count]) {
//        _pageControl.currentPage = 0;
        currentPageButton = [_pageButtonArray objectAtIndex:0];
    }else{
//        _pageControl.currentPage = page;
        currentPageButton = [_pageButtonArray objectAtIndex:page];
    }
    
    _labelView.text = [_labelArray objectAtIndex:currentPageButton.tag];
    
    [currentPageButton setSelected:YES];
    
    id object = [_imageViewArray objectAtIndex:[_imageViewArray count] - 1];
    [_imageViewArray removeObject:object];
    [_imageViewArray insertObject:object atIndex:0];
    
    for (int i=0; i<[_imageViewArray count]; i++) {
        BaseImageView *imageView = [_imageViewArray objectAtIndex:i];
        [imageView setFrame:CGRectMake(self.bounds.size.width * i, 0, self.bounds.size.width, self.bounds.size.height)];
    }
    
//    currentPageButton = [_pageButtonArray objectAtIndex:page];
}

- (void)nextPage
{
    CGFloat pagewidth = _scrollView.frame.size.width;
    
    [_scrollView setContentOffset:CGPointMake(pagewidth * 2, 0) animated:YES];
}

- (void)setAutoNext:(BOOL)autoNext
{
    if (!timer) {
        timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(nextPage) userInfo:Nil repeats:YES];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
//    if (autoNext) {
//        if ([timer isValid]) {
//            [timer fire];
//        }
//    }else{
//        if (![timer isValid]) {
//            [timer invalidate];
//        }
//    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_imageViewArray count] == 0) {
        return;
    }
    
    float targetX = scrollView.contentOffset.x;
    CGFloat pagewidth = _scrollView.frame.size.width;
    
    if (targetX >= pagewidth * 2) {
        targetX = pagewidth;
        [self moveLeft];
        [_scrollView setContentOffset:CGPointMake(pagewidth, 0) animated:NO];
    }
    else if(targetX <= 0)
    {
        targetX = 0;
        [self moveRight];
        [_scrollView setContentOffset:CGPointMake(pagewidth, 0) animated:NO];
    }
}

@end
