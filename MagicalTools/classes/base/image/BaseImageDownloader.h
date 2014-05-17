//
//  BaseImageDownloader.h
//  LuShiHelper
//
//  Created by Brian on 13-12-10.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseDownLoader.h"

@interface BaseImageDownloader : BaseDownLoader

/**
 添加下载任务
 @param url 下载url对象
 @param delegate 代理
 @param isSaveSmallCache 是否做压缩缓存
 @param smallCacheSize 压缩目标大小
 */
//+ (void)addDownloadTaskWithURL:(NSURL *)url delegate:(id)delegate isSaveSmallCache:(BOOL)isSaveSmallCache smallCacheSize:(CGSize)smallCacheSize;

@end
