//
//  BaseImageView.h
//  LuShiHelper
//
//  Created by Brian on 13-11-29.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseImageDownloader.h"

@class BaseImageView;

/**
 CTImageView代理
 */
@protocol BaseImageViewDelegate <NSObject>
@optional
/**
 下载成功回调
 @param imageView CTImageView对象
 */
- (void)imageViewLoadImageSucceed:(BaseImageView *)imageView;
/**
 下载进度更新回调
 @param imageView CTImageView对象
 @param receivedBytes 接收字节数
 @param totalBytes 总共字节数
 */
- (void)imageViewProgressed:(BaseImageView *)imageView receivedBytes:(NSUInteger)receivedBytes totalBytes:(long long)totalBytes;
/**
 下载失败回调
 @param imageView CTImageView对象
 @param error 错误对象
 */
- (void)imageViewLoadImageFailed:(BaseImageView *)imageView error:(NSError *)error;

/**
 下载取消回调
 @param imageView CTImageView对象
 */
- (void)imageViewLoadImageCanceled:(BaseImageView *)imageView;
@end

@interface BaseImageView : UIImageView
{
    UIActivityIndicatorView *_indicatorView;
    NSURL *_imageURL;
    BOOL _isAnimating;
    CGSize _imageSize;
    CGRect _originalFrame;
}

/** 代理指针*/
@property (nonatomic, unsafe_unretained) id<BaseImageViewDelegate> delegate;
/** 图片下载地址*/
@property (nonatomic, copy) NSString *imageUrlString;
/** 加载等待图片
 展示原则：下载过程中显示的图片
 */
@property (nonatomic, strong) UIImage *placeHoldImage;
/** 加载空网址图片
 展示原则：当传入网址是空，或者空格，则显示暂无图片
 */
@property (nonatomic, strong) UIImage *loadNothingImage;
/** 加载失败图片
 展示原则：当传入网址非空有值，但是下载失败或超时，则显示加载失败图片
 */
@property (nonatomic, strong) UIImage *loadFailedImage;

/**
 取消当前对象下载任务
 */
- (void)cancelDownloadAction;

/**
 设置下载并行线程数
 
 @param count 并行线程数
 */
+ (void)setConcurrentDownloadThreadCount:(NSInteger)count;

- (void)setImageSize:(CGSize)size originalFrame:(CGRect)frame;

/**
 初始化方法
 
 @param placeHoldImage      加载等待图片
 @param loadNothingImage    暂无图片
 @param loadFailedImage     加载失败图片
 @param urlString           下载地址
 @param delegate            下载代理对象
 @return CTImageView对象
 */
- (id)initWithPlaceHoldImage:(UIImage *)placeHoldImage loadNothingImage:(UIImage *)loadNothingImage loadFailedImage:(UIImage *)loadFailedImage urlString:(NSString *)urlString rect:(CGRect)rect delegate:(id<BaseImageViewDelegate>)aDelegate;

@end
