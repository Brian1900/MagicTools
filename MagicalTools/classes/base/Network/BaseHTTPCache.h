//
//  BaseHTTPCache.h
//  CommonTools
//
//  Created by Brian on 14-1-6.
//  Copyright (c) 2014年 gm86. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseHTTPCacheOperationQueue : NSOperationQueue

@end

@interface BaseHTTPCache : NSObject

{
    NSMutableArray *_memoryCacheArray;
    BaseHTTPCacheOperationQueue *_httpCacheQueue;
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

- (void)saveHTTPdata:(NSData*)data toPath:(NSString*)url;

- (BOOL)hasCacheForKey:(NSString *)url;
- (NSString*)getHTTPSavePath:(NSString*)url;//获取存储路径
- (NSString *)getCachePathForKey:(NSString *)url;//获取缓存的存储路径

- (void)clearCache;
- (NSString*)HTTPCacheForKey:(NSString *)url;

@end
