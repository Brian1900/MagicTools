//
//  BaseImageDownloader.m
//  LuShiHelper
//
//  Created by Brian on 13-12-10.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseImageDownloader.h"

@implementation BaseImageDownloader

#pragma mark 添加下载任务
//+ (void)addDownloadTaskWithURL:(NSURL *)url delegate:(id)delegate isSaveSmallCache:(BOOL)isSaveSmallCache smallCacheSize:(CGSize)smallCacheSize
//{
//    if (!url || [[url.absoluteString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
//        return;
//    }
////    if ([[CTDownloaderCache sharedInstance] hasCacheForURL:url]) {
////        CTDiskOperation *diskOperation = [CTDiskOperation operation];
////        diskOperation.downloadURL = url;
////        diskOperation.delegate = delegate;
////        diskOperation.isSmallCache = isSaveSmallCache;
////        diskOperation.smallCacheSize = smallCacheSize;
////        [[self sharedDownloader].diskOperationQueue addOperation:diskOperation];
////    }
////    else
////    {
//        BaseDownLoadOperation *operation = (BaseDownLoadOperation*)[BaseDownLoadOperation operation];
//        operation.downloadURL = url;
//        operation.delegate = delegate;
////        operation.isSaveSmallCache = YES;
////        operation.smallCacheSize = smallCacheSize;
//        [[self sharedDownloader].downloadQueue addOperation:operation];
////    }
//}

@end
