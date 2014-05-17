//
//  BaseDownLoader.h
//  LuShiHelper
//
//  Created by Brian on 13-12-10.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDownLoadOperation.h"
#import "BaseDownloaderCache.h"
#import "BaseDiskOperation.h"

@interface BaseDownloadOperationQueue : NSOperationQueue

@end

@interface BaseDownLoader : NSObject

/**	下载队列 */
@property (nonatomic, readonly) BaseDownloadOperationQueue *downloadQueue;
/**	读取本地数据队列 */
@property (nonatomic, readonly) BaseDiskOperationQueue *dickQueue;
/**
 获取下载器单例对象
 */
+ (BaseDownLoader *)sharedDownloader;
/**
 删除下载器单例对象
 */
+ (void)releaseDownloader;

/**
 设置下载并行线程数
 
 @param count 并行线程数
 */
+ (void)setMaxConcurrentDownloadThreadCount:(NSInteger)count;

/**
 设置读文件并行线程数
 
 @param count 并行线程数
 */
+ (void)setMaxConcurrentDiskOperaionThreadCount:(NSInteger)count;

/**
 添加下载任务
 
 @param url 下载地址URL对象
 @param delegate 下载事件代理
 */
+ (void)addDownloadTaskWithURL:(NSURL *)url delegate:(id)delegate;

/**
 删除下载任务
 
 @param url 下载地址
 @param delegate 下载事件代理
 */
+ (void)removeTaskWithUrlString:(NSString *)urlString delegate:(id)delegate;

/**
 删除所有下载任务
 */
+ (void)removeAllTasks;
/**
 通过地址删除下载任务
 
 @param urlString 下载地址
 */
+ (void)removeAllTasksWithUrlString:(NSString *)urlString;
/**
 通过代理对象删除下载任务
 
 @param delegate 下载代理
 */
+ (void)removeTasksWithDelegate:(id)delegate;

@end
