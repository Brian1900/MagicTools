//
//  BaseHTTPCache.m
//  CommonTools
//
//  Created by Brian on 14-1-6.
//  Copyright (c) 2014年 gm86. All rights reserved.
//

#import "BaseHTTPCache.h"
#import "BaseUtil.h"

#define kHTTPDirectoryName @"httpCache"
#define kHTTPCachePlistName @"httpCache.plist"

static BaseHTTPCache *_httpCache;

static NSString * __cacheDirectory;

static inline NSString * CacheDirectory()
{
	if(!__cacheDirectory) {
		NSString * cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		__cacheDirectory = [[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:kHTTPDirectoryName];
	}
	
	return __cacheDirectory;
}

static inline NSString * cachePathForKey(NSString * key)
{
	return [CacheDirectory() stringByAppendingPathComponent:key];
}

@implementation BaseHTTPCacheOperationQueue

@end

@implementation BaseHTTPCache

+ (id)sharedInstance
{
    @synchronized(self) {
		if(!_httpCache) {
			_httpCache = [[self alloc] init];
		}
	}
    
    return _httpCache;
}

+ (void)releaseInstance
{
    @synchronized(self) {
        if (_httpCache) {
            _httpCache = nil;
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
    
    if (!_httpCacheQueue) {
        _httpCacheQueue = [[BaseHTTPCacheOperationQueue alloc] init];
    }
    
    [[NSFileManager defaultManager] createDirectoryAtPath:CacheDirectory()
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
    
    if (!_cacheDictionary) {
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:cachePathForKey(kHTTPCachePlistName)];
        
        if([dict isKindOfClass:[NSDictionary class]]) {
            _cacheDictionary = [dict mutableCopy];
        } else {
            _cacheDictionary = [[NSMutableDictionary alloc] init];
        }
    }
}

- (void)saveCacheDictionary
{
    [_cacheDictionary writeToFile:cachePathForKey(kHTTPCachePlistName) atomically:YES];
}

- (NSString*)getHTTPSaveName:(NSString*)url
{
    if (url.length < 3) {
        return nil;
    }
    
    NSString* name = [NSString stringWithFormat:@"%@.html",[BaseUtil stringFromMD5:url]];
    
    return name;
}

- (void)saveHTTPdata:(NSData*)data toPath:(NSString*)url
{
    NSString* name = [self getHTTPSaveName:url];
    if (!name) {
        return ;
    }
    
    [_cacheDictionary setObject:name forKey:url];
    [self saveCacheDictionary];
    
    [data writeToFile:cachePathForKey(name) atomically:YES];
}

- (NSString*)getHTTPSavePath:(NSString*)url
{
    NSString* name = [self getHTTPSaveName:url];
    return cachePathForKey(name);
}

- (BOOL)hasCacheForKey:(NSString *)url
{
    NSString* name = [self getHTTPSaveName:url];
    
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

- (NSString*)HTTPCacheForKey:(NSString *)url
{
    NSString* contetn = nil;
    NSString* path = [self getCachePathForKey:url];
    if (path) {
        contetn = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:path] encoding:NSUTF8StringEncoding];
    }
    
	return contetn;
}

@end