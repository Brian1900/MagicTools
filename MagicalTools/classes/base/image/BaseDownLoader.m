//
//  BaseDownLoader.m
//  LuShiHelper
//
//  Created by Brian on 13-12-10.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseDownLoader.h"
#import "BaseDefine.h"

static BaseDownLoader *__sharedDownloader = nil;

@implementation BaseDownloadOperationQueue

@end

@implementation BaseDownLoader

- (id)init
{
    self = [super init];
    if (self) {
        [self initBaseData];
    }
    return self;
}

- (void)initBaseData
{
    if (!_downloadQueue) {
        _downloadQueue = [[BaseDownloadOperationQueue alloc] init];
        [_downloadQueue setMaxConcurrentOperationCount:maxDownloadOperationCount];
    }
    if (!_dickQueue) {
        _dickQueue = [[BaseDiskOperationQueue alloc] init];
        [_dickQueue setMaxConcurrentOperationCount:maxDiskOperationCount];
    }
}

+ (BaseDownLoader *)sharedDownloader
{
    @synchronized (self)
    {
        if (!__sharedDownloader) {
            __sharedDownloader = [[self alloc] init];
        }
    }
    
    return __sharedDownloader;
}
#pragma mark 删除下载器单例对象
+ (void)releaseDownloader
{
    @synchronized (self)
    {
        if (__sharedDownloader) {
            __sharedDownloader = nil;
        }
    }
}
#pragma mark 添加下载任务
+ (void)addDownloadTaskWithURL:(NSURL *)url delegate:(id)delegate
{
    if (!url || [[url.absoluteString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return;
    }
    
    if ([[BaseDownloaderCache sharedInstance] hasCacheForKey:url.absoluteString]) {
        BaseDiskOperation *diskOperation = (BaseDiskOperation*)[BaseDiskOperation operation];
        diskOperation.downloadURL = url;
        diskOperation.delegate = delegate;
        [[self sharedDownloader].dickQueue addOperation:diskOperation];
    }
    else
    {
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:saveFlow] && ![[NSUserDefaults standardUserDefaults] boolForKey:wifiConnct]) {
//            return ;
//        }else{
            BaseDownLoadOperation *downloadOperation = (BaseDownLoadOperation*)[BaseDownLoadOperation operation];
            downloadOperation.downloadURL = url;
            downloadOperation.delegate = delegate;
            [[self sharedDownloader].downloadQueue addOperation:downloadOperation];
//        }
    }
}

#pragma mark - 删除下载任务
+ (void)removeAllTasks
{
    [[self sharedDownloader].downloadQueue cancelAllOperations];
    for (id operation in [self sharedDownloader].downloadQueue.operations) {
        if ([operation isKindOfClass:[BaseDownLoadOperation class]]) {
            BaseDownLoadOperation *theOperation = operation;
            [theOperation setDelegate:nil];
            [theOperation cancel];
        }
    }
    for (id operation in [self sharedDownloader].dickQueue.operations) {
        if ([operation isKindOfClass:[BaseDiskOperation class]]) {
            BaseDiskOperation *theOperation = operation;
            [theOperation setDelegate:nil];
            [theOperation cancel];
        }
    }
}

+ (void)removeAllTasksWithUrlString:(NSString *)urlString
{
    if (!urlString || [[urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return;
    }
    for (id operation in [self sharedDownloader].downloadQueue.operations) {
        if ([operation isKindOfClass:[BaseDownLoadOperation class]]) {
            BaseDownLoadOperation *theOperation = operation;
            if ([theOperation.downloadURL.absoluteString isEqualToString:urlString]) {
                [theOperation cancel];
            }
        }
    }
    for (id operation in [self sharedDownloader].dickQueue.operations) {
        if ([operation isKindOfClass:[BaseDiskOperation class]]) {
            BaseDiskOperation *theOperation = operation;
            if ([theOperation.downloadURL.absoluteString isEqualToString:urlString]) {
                [theOperation cancel];
            }
        }
    }
}

+ (void)removeTaskWithUrlString:(NSString *)urlString delegate:(id)delegate
{
    if (!urlString || [[urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return;
    }
    for (id operation in [self sharedDownloader].downloadQueue.operations) {
        if ([operation isKindOfClass:[BaseDownLoadOperation class]]) {
            BaseDownLoadOperation *theOperation = operation;
            if (theOperation.delegate == delegate && [theOperation.downloadURL.absoluteString isEqualToString:urlString]) {
                [theOperation cancel];
                break;
            }
        }
    }
    for (id operation in [self sharedDownloader].dickQueue.operations) {
        if ([operation isKindOfClass:[BaseDiskOperation class]]) {
            BaseDiskOperation *theOperation = operation;
            if (theOperation.delegate == delegate && [theOperation.downloadURL.absoluteString isEqualToString:urlString]) {
                [theOperation cancel];
            }
        }
    }
}
+ (void)removeTasksWithDelegate:(id)delegate
{
    NSMutableArray *tempOperationArray = [NSMutableArray array];
    for (id operation in [self sharedDownloader].downloadQueue.operations) {
        if ([operation isKindOfClass:[BaseDownLoadOperation class]]) {
            BaseDownLoadOperation *theOperation = operation;
            if (theOperation.delegate == delegate) {
                theOperation.delegate = nil;
                [tempOperationArray addObject:theOperation];
            }
        }
    }
    for (id operation in [self sharedDownloader].dickQueue.operations) {
        if ([operation isKindOfClass:[BaseDiskOperation class]]) {
            BaseDiskOperation *theOperation = operation;
            if (theOperation.delegate == delegate) {
                theOperation.delegate = nil;
                [tempOperationArray addObject:theOperation];
            }
        }
    }
    for (BaseDownLoadOperation *theOperation in tempOperationArray) {
        [theOperation cancel];
    }
}
#pragma mark 设置下载并行线程数
+ (void)setMaxConcurrentDownloadThreadCount:(NSInteger)count
{
    [[self sharedDownloader].downloadQueue setMaxConcurrentOperationCount:count];
}

#pragma mark 设置读文件并行线程数
+ (void)setMaxConcurrentDiskOperaionThreadCount:(NSInteger)count
{
    [[self sharedDownloader].dickQueue setMaxConcurrentOperationCount:count];
}

@end
