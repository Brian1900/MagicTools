//
//  BaseImageView.m
//  LuShiHelper
//
//  Created by Brian on 13-11-29.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseImageView.h"
#import "BaseDataSource.h"
#import "BaseUtil.h"

@implementation BaseImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initBaseData];
        [self initBaseView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initBaseView];
}

#pragma mark - private method
- (void)initBaseData
{
    if (!_placeHoldImage) {
        _placeHoldImage = nil;//[UIImage imageNamed:@"bg_defaultimage130.png"];
    }
    if (!_loadNothingImage) {
        _loadNothingImage = nil;//[UIImage imageNamed:@"bg_noopictrue130.png"];
    }
    if (!_loadFailedImage) {
        _loadFailedImage = nil;//[UIImage imageNamed:@"bg_failure130.png"];
    }
    
    _imageSize = CGSizeZero;
}

- (void)initBaseView
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] ;
        _indicatorView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        _indicatorView.hidesWhenStopped = YES;
        [self addSubview:_indicatorView];
    }
}

- (void)setImageURL:(NSURL *)imageURL
{
    if (_imageURL) {
        [BaseImageDownloader removeTaskWithUrlString:_imageURL.absoluteString delegate:self];
        _imageURL = nil;
    }
    _imageURL = imageURL;
    self.image = self.placeHoldImage;
    
    if (!_imageURL) {
        [self setLoadFailed];
        return;
    }
    
    [BaseImageDownloader removeTasksWithDelegate:self];
    [self startAnimate];
    [BaseImageDownloader addDownloadTaskWithURL:_imageURL delegate:self];
}

- (void)startAnimate
{
    _isAnimating = YES;
    [_indicatorView startAnimating];
}

- (void)stopAnimate
{
    _isAnimating = NO;
    [_indicatorView stopAnimating];
}

- (void)setLoadNothing
{
    if (self.loadNothingImage) {
        self.image = self.loadNothingImage;
    }
    
    [self stopAnimate];
    [self animateShowingImage];
}

- (void)setLoadFailed
{
    if (self.loadFailedImage) {
        self.image = self.loadFailedImage;
    }
    
    [self stopAnimate];
    [self animateShowingImage];
}

- (void)animateShowingImage
{
    //animation 非阻塞
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setFromValue:[NSNumber numberWithFloat:0.0]];
    [animation setToValue:[NSNumber numberWithFloat:1.0]];
    [animation setDuration:0.5];
    
    [self.layer addAnimation:animation forKey:@"fade_in"];
}

#pragma mark - public method
- (id)initWithPlaceHoldImage:(UIImage *)placeHoldImage loadNothingImage:(UIImage *)loadNothingImage loadFailedImage:(UIImage *)loadFailedImage urlString:(NSString *)urlString rect:(CGRect)rect delegate:(id<BaseImageViewDelegate>)aDelegate
{
    self = [super initWithImage:placeHoldImage];
    if (self) {
        [self initBaseData];
        [self initBaseView];
        
        self.placeHoldImage = placeHoldImage;
        self.loadNothingImage = loadNothingImage;
        self.loadFailedImage = loadFailedImage;
        self.delegate = aDelegate;
        self.imageUrlString = urlString;
        
        [self setFrame:rect];
        
        //        CGFloat scale = [[UIScreen mainScreen] scale];
        //        if (scale != 1) {
        //            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width/scale, self.bounds.size.height/scale)];
        //        }
    }
    return self;
}

- (void)cancelDownloadAction
{
    [BaseImageDownloader removeTasksWithDelegate:self];
}

+ (void)setConcurrentDownloadThreadCount:(NSInteger)count
{
    [BaseImageDownloader setMaxConcurrentDownloadThreadCount:count];
}

- (void)setImageSize:(CGSize)size originalFrame:(CGRect)frame
{
    _imageSize = size;
    _originalFrame = frame;
    
    [self setFrame:frame];
}

- (void)showSuccess
{
    if (_imageSize.width == 0 && _imageSize.height == 0) {
        return ;
    }
    [UIView animateWithDuration:0.3 animations:^{
        if(_imageSize.height/_imageSize.width > _originalFrame.size.height/_originalFrame.size.width)
        {
            CGFloat width = _originalFrame.size.height/(_imageSize.height/_imageSize.width);
            
            CGRect rect = _originalFrame;
            rect.origin.x = (_originalFrame.size.width - width)/2;
            rect.size = CGSizeMake(width, _originalFrame.size.height);
            
            [self setFrame:rect];
        }else if(_imageSize.height/_imageSize.width < _originalFrame.size.height/_originalFrame.size.width){
            CGFloat height = (_imageSize.height/_imageSize.width)*_originalFrame.size.width;
            
            CGRect rect = _originalFrame;
            rect.origin.y = (_originalFrame.size.height - height)/2;
            rect.size = CGSizeMake(_originalFrame.size.width, height);
            
            [self setFrame:rect];
        }
    }];
}

- (void)setImageUrlString:(NSString *)imageUrlString
{
    if ([_imageUrlString isEqualToString:imageUrlString]) {
        if (YES == _isAnimating) {
            [self startAnimate];
        }
        if (_imageSize.width != 0 && _imageSize.height != 0) {
            [self showSuccess];
        }
        return;
    }
    if (_imageUrlString) {
        [BaseImageDownloader removeTaskWithUrlString:_imageUrlString delegate:self];
        _imageUrlString = nil;
    }
    
//    UIImage* image = [[BaseDownloaderCache sharedInstance] imageForKey:imageUrlString];
//    if (image) {
//        [self setImage:image];
//        [self animateShowingImage];
//        return;
//    }
    
    _imageUrlString = [imageUrlString copy];
    
    if (_imageUrlString) {
        if ([[_imageUrlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            [self setLoadNothing];
        }
        else
        {
            self.imageURL = [NSURL URLWithString:_imageUrlString];
        }
    }
    else
    {
        [self setLoadNothing];
    }
}

#pragma mark - BaseDownloadTaskOperationDelegate
- (void)downloadDidStartWithOperation:(BaseDownTaskOperation *)operation
{
    
}

- (void)downloadDidProgressWithOperation:(BaseDownTaskOperation *)operation receivedBytes:(NSUInteger)receivedBytes totalBytes:(long long)totalBytes info:(id)bakeInfo
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewProgressed:receivedBytes:totalBytes:)]) {
        [self.delegate imageViewProgressed:self receivedBytes:receivedBytes totalBytes:totalBytes];
    }
}
- (void)downloadDidCompleteWithOperation:(BaseDownTaskOperation *)operation data:(NSData *)data
{
    if (data.length > 0) {
        UIImage *theImage = [UIImage imageWithData:data];
        self.image = theImage;
        [self stopAnimate];
        [self animateShowingImage];
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewLoadImageSucceed:)]) {
            [self.delegate imageViewLoadImageSucceed:self];
        }
        
        [self showSuccess];
    }
    else
    {
        [self downloadDidFailWithOperation:operation error:[NSError errorWithDomain:@"NSURLErrorDomain" code:NSURLErrorCannotLoadFromNetwork userInfo:nil]];
    }
}
- (void)downloadDidFailWithOperation:(BaseDownTaskOperation *)operation error:(NSError *)error
{
    [self setLoadFailed];
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewLoadImageFailed:error:)]) {
        [self.delegate imageViewLoadImageFailed:self error:[NSError errorWithDomain:@"CTImageViewDownload Failed" code:-401 userInfo:nil]];
    }
}
- (void)downloadDidCancelWithOperation:(BaseDownTaskOperation *)operation
{
    [self stopAnimate];
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewLoadImageCanceled:)]) {
        [self.delegate imageViewLoadImageCanceled:self];
    }
}

@end
