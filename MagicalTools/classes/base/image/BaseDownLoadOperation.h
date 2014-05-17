//
//  BaseDownLoadOperation.h
//  LuShiHelper
//
//  Created by Brian on 13-12-10.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseDownTaskOperation.h"
#import "BaseDownloaderCache.h"
#import "BaseDefine.h"

#define kDownloaderTimeoutInterval 5
#define kDownloaderTryCount 3

typedef enum {
    eDownloaderStateStart = 0,
    eDownloaderStateProgress,
    eDownloaderStateComplete,
    eDownloaderStateFail,
    eDownloaderStateCancel,
} eDownloaderState;

typedef enum {
    eDownloaderCallBackTypeDelegate = 0,
    eDownloaderCallBackTypeBlock,
    eDownloaderCallBackTypeNotification,
    eDownloaderCallBackTypeDefault = eDownloaderCallBackTypeDelegate,
} eDownloaderCallBackType;

@interface BaseDownLoadOperation : BaseDownTaskOperation <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    BOOL isFailed;
    BOOL isFinished;
    BOOL isCalledDelegate;
    NSInteger downloadRange;
}


/**	总共字节数 */
@property (nonatomic, assign) long long totalBytes;
/**	回调类型 */
@property (nonatomic, assign) eDownloaderCallBackType callBackType;
/** 图片保存路径 **/
@property (nonatomic, copy) NSString* path;

/**	请求 */
@property (nonatomic, readonly) NSURLRequest    *request;
/**	链接 */
@property (nonatomic, readonly) NSURLConnection *connection;
/**	链接 */
@property (atomic, readwrite, assign) NSInteger tryCount;

#pragma mark block回调
/**	开始block */
@property (nonatomic, copy) DownloadDidStartBlock     startBlock;
/**	下载更新block */
@property (nonatomic, copy) DownloadDidProgressBlock  processBlock;
/**	完成block */
@property (nonatomic, copy) DownloadDidCompleteBlock  completeBlock;
/**	失败block */
@property (nonatomic, copy) DownloadDidFailBlock      failBlock;
/**	取消block */
@property (nonatomic, copy) DownloadDidCancelBlock    canceledBlock;

@end
