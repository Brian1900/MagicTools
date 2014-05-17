//
//  BaseDownloaderCache.h
//  LuShiHelper
//
//  Created by Brian on 13-12-10.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDiskOperationQueue : NSOperationQueue

@end

@interface BaseDownloaderCache : NSObject
{
    NSMutableArray *_memoryCacheArray;
    BaseDiskOperationQueue *_diskOperationQueue;
    NSMutableDictionary *_cacheDictionary;
}

/**
 获取单例对象
 @return 单例对象
 */
+ (id)sharedInstance;
/**
 释放单例对象
 */
+ (void)releaseInstance;

- (void)saveImagedata:(NSData*)data toPath:(NSString*)url;
- (BOOL)hasCacheForKey:(NSString *)url;
- (NSString*)getImageSavePath:(NSString*)url;//获取存储路径
- (NSString *)getCachePathForKey:(NSString *)url;//获取缓存的存储路径

- (void)clearCache;
- (UIImage*)imageForKey:(NSString *)url;

@end
