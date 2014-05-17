//
//  BaseDownloaderCache.m
//  LuShiHelper
//
//  Created by Brian on 13-12-10.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseDownloaderCache.h"
#import "BaseUtil.h"

#define kCTDownloaderCacheDirectoryName @"downloaderCache"
#define kCTDownloaderCachePlistName @"downloaderCache.plist"

static BaseDownloaderCache *__downloaderCache;

static NSString * __cacheDirectory;

static inline NSString * CacheDirectory()
{
	if(!__cacheDirectory) {
		NSString * cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		__cacheDirectory = [[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:kCTDownloaderCacheDirectoryName];
	}
	
	return __cacheDirectory;
}

static inline NSString * cachePathForKey(NSString * key)
{
	return [CacheDirectory() stringByAppendingPathComponent:key];
}

@implementation BaseDiskOperationQueue



@end

@implementation BaseDownloaderCache

+ (id)sharedInstance
{
    @synchronized(self) {
		if(!__downloaderCache) {
			__downloaderCache = [[self alloc] init];
		}
	}
    
    return __downloaderCache;
}

+ (void)releaseInstance
{
    @synchronized(self) {
        if (__downloaderCache) {
            __downloaderCache = nil;
        }
    }
}

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
    if (!_memoryCacheArray) {
        _memoryCacheArray = [[NSMutableArray alloc] init];
    }
    
    if (!_diskOperationQueue) {
        _diskOperationQueue = [[BaseDiskOperationQueue alloc] init];
    }
    
    [[NSFileManager defaultManager] createDirectoryAtPath:CacheDirectory()
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
    
    if (!_cacheDictionary) {
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:cachePathForKey(kCTDownloaderCachePlistName)];
        
        if([dict isKindOfClass:[NSDictionary class]]) {
            _cacheDictionary = [dict mutableCopy];
        } else {
            _cacheDictionary = [[NSMutableDictionary alloc] init];
        }
    }
}

- (void)saveCacheDictionary
{
    [_cacheDictionary writeToFile:cachePathForKey(kCTDownloaderCachePlistName) atomically:YES];
}

- (NSString*)getImageSaveName:(NSString*)url
{
    if (url.length < 3) {
        return nil;
    }
    
    NSRange range = [url rangeOfString:@"." options:NSBackwardsSearch];
    
    NSString* name = [NSString stringWithFormat:@"%@.%@",[BaseUtil stringFromMD5:url],[url substringFromIndex:url.length-range.location+1]];
    
    return name;
}

- (void)saveImagedata:(NSData*)data toPath:(NSString*)url
{
    NSString* name = [self getImageSaveName:url];
    if (!name) {
        return ;
    }
    
    [_cacheDictionary setObject:name forKey:url];
    [self saveCacheDictionary];
    
    [data writeToFile:cachePathForKey(name) atomically:YES];
}

- (NSString*)getImageSavePath:(NSString*)url
{
    NSString* name = [self getImageSaveName:url];
    return cachePathForKey(name);
}

- (BOOL)hasCacheForKey:(NSString *)url
{
    NSString* name = [self getImageSaveName:url];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:cachePathForKey(name)];
}

- (NSString *)getCachePathForKey:(NSString *)url
{
    NSString* cachePath = nil;
    if ([self hasCacheForKey:url]) {
        NSString* name = [_cacheDictionary objectForKey:url];
        cachePath = cachePathForKey(name);
    }
    
    return cachePath;
}

- (void)clearCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:CacheDirectory() error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[CacheDirectory() stringByAppendingPathComponent:filename] error:NULL];
    }
    
    [_cacheDictionary removeAllObjects];
    [self saveCacheDictionary];
}

- (UIImage*)imageForKey:(NSString *)url
{
    UIImage* image;
    NSString* path = [self getCachePathForKey:url];
    if (path) {
        image = [UIImage imageWithContentsOfFile:path];
    }
    
	return image;
}



@end
