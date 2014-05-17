//
//  BaseDownTaskOperation.h
//  LuShiHelper
//
//  Created by Brian on 13-12-10.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseDownTaskOperation;

@protocol BaseDownloadTaskOperationDelegate <NSObject>
@optional
/**
 开始下载回调
 @param operation 下载任务对象
 */
- (void)downloadDidStartWithOperation:(BaseDownTaskOperation *)operation;
/**
 下载更新回调
 @param operation 下载任务对象
 @param receivedBytes 已接收大小
 @param totalBytes 总共大小
 @param bakeInfo 备份字段
 */
- (void)downloadDidProgressWithOperation:(BaseDownTaskOperation *)operation receivedBytes:(NSUInteger)receivedBytes totalBytes:(long long)totalBytes info:(id)bakeInfo;
/**
 下载完成回调
 @param operation 下载任务对象
 @param data 数据对象
 */
- (void)downloadDidCompleteWithOperation:(BaseDownTaskOperation *)operation data:(NSData *)data;
/**
 下载失败回调
 @param operation 下载任务对象
 @param error 失败对象
 */
- (void)downloadDidFailWithOperation:(BaseDownTaskOperation *)operation error:(NSError *)error;
/**
 下载取消回调
 @param operation 下载任务对象
 */
- (void)downloadDidCancelWithOperation:(BaseDownTaskOperation *)operation;

@end

typedef void(^DownloadDidStartBlock)(BaseDownTaskOperation *operation);
typedef void(^DownloadDidProgressBlock)(BaseDownTaskOperation *operation, NSUInteger receivedBytes, long long totalBytes, id bakeInfo);
typedef void(^DownloadDidCompleteBlock)(BaseDownTaskOperation *operation, NSData *data);
typedef void(^DownloadDidFailBlock)(BaseDownTaskOperation *operation, NSError *error);
typedef void(^DownloadDidCancelBlock)(BaseDownTaskOperation *operation);

#pragma mark - Notification definition
#define kDownloaderDidStartNotification        @"Download_Start"
#define kDownloaderDidProgressNotification     @"Download_Progress"
#define kDownloaderDidCompleteNotification     @"Download_Complete"
#define kDownloaderDidFailNotification         @"Download_Fail"
#define kDownloaderDidCancelNotification       @"Download_Cancel"

@interface BaseDownTaskOperation : NSOperation
{
    @protected
    NSMutableData * _downLoadData;
    NSURL* _downloadURL;
}

/**	delegate */
@property (nonatomic, unsafe_unretained) id <BaseDownloadTaskOperationDelegate> delegate;

/**	下载url */
@property (nonatomic, strong) NSURL *downloadURL;
/**	数据对象 */
@property (nonatomic, readonly, strong) NSMutableData *downLoadData;

/**
 获取本类autorelease对象
 @return 本类autorelease对象
 */
+ (BaseDownTaskOperation*)operation;

@end
