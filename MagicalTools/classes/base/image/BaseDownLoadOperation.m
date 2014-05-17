//
//  BaseDownLoadOperation.m
//  LuShiHelper
//
//  Created by Brian on 13-12-10.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseDownLoadOperation.h"
#import "BaseDownloaderCache.h"

#define kDownloaderOperation       @"operation"
#define kDownloaderReceivedBytes   @"receivedBytes"
#define kDownloaderTotalBytes      @"totalBytes"
#define kDownloaderBakeInfo        @"bakeInfo"
#define kDownloaderData            @"data"
#define kDownloaderError           @"error"

@implementation BaseDownLoadOperation

- (void)dealloc
{
    self.delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleDownloadTimeOut) object:nil];
}
#pragma mark - --------------------初始化--------------------

- (id)init
{
    self  = [super init];
    if (self) {
        [self initBaseData];
    }
    return self;
}

- (void)initBaseData
{
//    _isSaveSmallCache = NO;
    isFailed = NO;
    _callBackType = eDownloaderCallBackTypeDelegate;
    
    _request = nil;
    _connection = nil;
    _startBlock = nil;
    _processBlock = nil;
    _completeBlock = nil;
    _failBlock = nil;
    _canceledBlock = nil;
    _tryCount = 0;
}
#pragma mark 主入口
- (void)main
{
    @autoreleasepool {
        [[NSThread currentThread] setName:@"com.gm86.downloadOperation"];
        if (![self isCancelled] && self.downloadURL) {
            [self performSelector:@selector(handleDownloadTimeOut) withObject:nil afterDelay:kDownloaderTimeoutInterval * kDownloaderTryCount];
            
            [self downloadDidStartWithOperation:self];
            
//            if ([[DownloaderCache sharedInstance] hasCacheForURL:self.downloadURL]) {
//                if (kDownloaderIsUseMemoryCache) {
//                    data_ = [[NSMutableData alloc] initWithData:[[DownloaderCache sharedInstance] getMemoryCacheForURL:downloadURL_]];//方案二：从缓存内存中获取图片数据
//                }
//                else
//                {
//                    data_ = [[NSMutableData alloc] initWithData:[[DownloaderCache sharedInstance] dataForURL:downloadURL_]];//方案一：直接读物理文件获取图片数据
//                }
//                [self downloadDidProgressWithOperation:self receivedBytes:data_.length totalBytes:data_.length info:nil];
//                [self downloadDidCompleteWithOperation:self data:data_];
//            }
//            else
//            {
                if (_request) {
                    _request = nil;
                }
                if (_connection) {
                    _connection = nil;
                }
                if (self.downloadURL) {
                    _request = [[NSURLRequest alloc] initWithURL:self.downloadURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kDownloaderTimeoutInterval];
                    
                    NSMutableURLRequest* tempRequest = [_request mutableCopy];
                    [tempRequest setValue:@"no-cache, no-store" forHTTPHeaderField:@"Cache-Control"];
                    
                    if (breakpoint_resume) {
                        if (_path) {
                            NSData* data = [NSData dataWithContentsOfFile:[_path stringByAppendingString:@".temp"]];
                            if (data) {
                                downloadRange = data.length;
                                if (downloadRange > 0) {
                                    [tempRequest setValue:[NSString stringWithFormat:@"bytes=%d-",downloadRange] forHTTPHeaderField:@"Range"];
                                }
                            }
                        }
                    }
                    
                    _request = [tempRequest copy];// = NSURLRequestReturnCacheDataElseLoad;
                    
                    if (_request) {
                        self.tryCount ++;
                        _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
                        [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
                    }
                }
                
                if (_connection) {
                    [_connection start];
                    
                    while (!isFinished) {
                        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    }
                }
//            }
        }
    }
}


#pragma mark - --------------------功能函数--------------------
#pragma mark 强制超时
- (void)handleDownloadTimeOut
{
    [self connection:_connection didFailWithError:[NSError errorWithDomain:@"Download Timeout" code:-2001 userInfo:nil]];
}
#pragma mark - Create Dictionary
- (NSDictionary *)createProgressDictionaryWithReceivedBytes:(NSUInteger)receivedBytes totalBytes:(long long)totalBytes info:(id)bakeInfo
{
    return [NSDictionary dictionaryWithObjectsAndKeys:self, kDownloaderOperation, [NSNumber numberWithUnsignedInteger:receivedBytes], kDownloaderReceivedBytes, [NSNumber numberWithLongLong:totalBytes], kDownloaderTotalBytes, [NSNull null], kDownloaderBakeInfo, nil];
}

- (NSDictionary *)createCompleteDictionaryWithData:(NSData *)data
{
    return [NSDictionary dictionaryWithObjectsAndKeys:self, kDownloaderOperation, data, kDownloaderData, nil];
}

- (NSDictionary *)createFailDictionaryWithError:(NSError *)error
{
    return [NSDictionary dictionaryWithObjectsAndKeys:self, kDownloaderOperation, error, kDownloaderError, nil];
}

#pragma mark - Post Notification
- (void)postNotification:(int)notificationType
{
    switch (notificationType) {
        case eDownloaderStateStart:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDownloaderDidStartNotification object:self userInfo:[NSDictionary dictionaryWithObject:self forKey:@"operation"]];
        }
            break;
        case eDownloaderStateProgress:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDownloaderDidProgressNotification object:self userInfo:[self createProgressDictionaryWithReceivedBytes:[_downLoadData length] totalBytes:_totalBytes info:nil]];
        }
            break;
        case eDownloaderStateComplete:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDownloaderDidFailNotification object:self userInfo:[self createCompleteDictionaryWithData:_downLoadData]];
        }
            break;
        case eDownloaderStateFail:
        {
            //            [[NSNotificationCenter defaultCenter] postNotificationName:kDownloaderDidFailNotification object:self userInfo:[self createFailDictionaryWithError:[[error_ copy] autorelease]]];
        }
            break;
        case eDownloaderStateCancel:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDownloaderDidCancelNotification object:self userInfo:[NSDictionary dictionaryWithObject:self forKey:@"operation"]];
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark - 回调
- (void)downloadDidStartWithOperation:(BaseDownLoadOperation *)operation
{
    [self performSelectorOnMainThread:@selector(downloadDidStartInMainThread:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:operation, kDownloaderOperation, nil] waitUntilDone:YES];
}
- (void)downloadDidStartInMainThread:(NSDictionary *)dictionary
{
    BaseDownLoadOperation *operation = [dictionary valueForKey:kDownloaderOperation];
    
    if ([self isCancelled]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadDidStartWithOperation:)]) {
        [self.delegate downloadDidStartWithOperation:operation];
    }
}
- (void)downloadDidProgressWithOperation:(BaseDownLoadOperation *)operation receivedBytes:(NSUInteger)receivedBytes totalBytes:(long long)totalBytes info:(id)bakeInfo
{
    [self performSelectorOnMainThread:@selector(downloadDidProgressInMainThread:) withObject:[self createProgressDictionaryWithReceivedBytes:receivedBytes totalBytes:totalBytes info:bakeInfo] waitUntilDone:YES];
}
- (void)downloadDidProgressInMainThread:(NSDictionary *)dictionary
{
    BaseDownLoadOperation *operation = [dictionary valueForKey:kDownloaderOperation];
    NSUInteger receivedBytes = [[dictionary valueForKey:kDownloaderReceivedBytes] unsignedIntegerValue];
    long long totalBytes = [[dictionary valueForKey:kDownloaderTotalBytes] longLongValue];
    id bakeInfo = [dictionary valueForKey:kDownloaderBakeInfo];
    
    if ([self isCancelled]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadDidProgressWithOperation:receivedBytes:totalBytes:info:)]) {
        [self.delegate downloadDidProgressWithOperation:operation receivedBytes:receivedBytes totalBytes:totalBytes info:bakeInfo];
    }
}
- (void)downloadDidCompleteWithOperation:(BaseDownLoadOperation *)operation data:(NSData *)data
{
    NSData *theData = data;
    
//    if (isSaveSmallCache_) {
//        UIImage *tempImage = [UIImage imageWithData:data];
//        UIImage *scaledImage = [DownloadTaskOperation scaleImage:tempImage toSize:smallCacheSize_];
//        NSData *scaledData = UIImagePNGRepresentation(scaledImage);
//        [[DownloaderCache sharedInstance] setData:scaledData forKey:[NSString stringWithFormat:@"%@_@%.0f*%.0f", [DownloaderCache keyForURL:downloadURL_], smallCacheSize_.width, smallCacheSize_.height]];
//        theData = scaledData;
//    }
    
    [self performSelectorOnMainThread:@selector(downloadDidCompleteInMainThread:) withObject:[self createCompleteDictionaryWithData:theData] waitUntilDone:YES];
}
- (void)downloadDidCompleteInMainThread:(NSDictionary *)dictionary
{
    if (isCalledDelegate == NO) {
        isCalledDelegate = YES;
        
        BaseDownLoadOperation *operation = [dictionary valueForKey:kDownloaderOperation];
        NSData *data = [dictionary valueForKey:kDownloaderData];
        
        if ([self isCancelled]) {
            return;
        }
        
        @try {
            if (self.delegate && [self.delegate respondsToSelector:@selector(downloadDidCompleteWithOperation:data:)]) {
                [self.delegate downloadDidCompleteWithOperation:operation data:data];
            }
        }
        @catch (NSException *exception) {
            //            @throw exception;
        }
        @finally {
            self.delegate = nil;
        }
        
        isFinished = YES;
        CFRunLoopStop(CFRunLoopGetCurrent());
    }
    
}
- (void)downloadDidFailWithOperation:(BaseDownLoadOperation *)operation error:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(downloadDidFailInMainThread:) withObject:[self createFailDictionaryWithError:error] waitUntilDone:YES];
}
- (void)downloadDidFailInMainThread:(NSDictionary *)dictionary
{
    if (isCalledDelegate == NO) {
        isCalledDelegate = YES;
        
        BaseDownLoadOperation *operation = [dictionary valueForKey:kDownloaderOperation];
        NSError *error = [dictionary valueForKey:kDownloaderError];
        
        if ([self isCancelled]) {
            return;
        }
        @try {
            if (self.delegate && [self.delegate respondsToSelector:@selector(downloadDidFailWithOperation:error:)]) {
                [self.delegate downloadDidFailWithOperation:operation error:error];
            }
        }
        @catch (NSException *exception) {
            //            @throw exception;
        }
        @finally {
            self.delegate = nil;
        }
        
        isFinished = YES;
        CFRunLoopStop(CFRunLoopGetCurrent());
    }
}
- (void)downloadDidCancelWithOperation:(BaseDownLoadOperation *)operation
{
    [self performSelectorOnMainThread:@selector(downloadDidCancelInMainThread:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:self, kDownloaderOperation, nil] waitUntilDone:YES];
}
- (void)downloadDidCancelInMainThread:(NSDictionary *)dictionary
{
    if (isCalledDelegate == NO) {
        isCalledDelegate = YES;
        
        BaseDownLoadOperation *operation = [dictionary valueForKey:kDownloaderOperation];
        
        @try {
            if (self.delegate && [self.delegate respondsToSelector:@selector(downloadDidCancelWithOperation:)]) {
                [self.delegate downloadDidCancelWithOperation:operation];
            }
        }
        @catch (NSException *exception) {
            //            @throw exception;
        }
        @finally {
            self.delegate = nil;
        }
        
        
        isFinished = YES;
        CFRunLoopStop(CFRunLoopGetCurrent());
    }
}
#pragma mark - --------------------代理方法--------------------

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.tryCount > kDownloaderTryCount)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleDownloadTimeOut) object:nil];
        [self downloadDidFailWithOperation:self error:error];
    }
    else
    {
        self.tryCount++;
        _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
        [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_connection start];
    }
}
#pragma mark NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleDownloadTimeOut) object:nil];
    int code = 0;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        code = [(NSHTTPURLResponse *)response statusCode];
        
        if (code == 200 || code == 206) {
            _totalBytes = [response expectedContentLength];
            if (_downLoadData) {
                _downLoadData = nil;
            }
            
            _downLoadData = [[NSMutableData alloc] init];
            
            if (breakpoint_resume) {
                if (_path) {
                    NSData* data = [NSData dataWithContentsOfFile:[_path stringByAppendingString:@".temp"]];
                    if (data) {
                        downloadRange = data.length;
                        [_downLoadData appendData:data];
                        TLog(@" url:%@ existLength:%d webLength:%lld",_downloadURL.absoluteString,downloadRange,_totalBytes);
                    }
                }
            }
            
            [self downloadDidProgressWithOperation:self receivedBytes:[_downLoadData length] totalBytes:_totalBytes info:nil];
        }
        else
        {
            isFailed = YES;
            [self downloadDidFailWithOperation:self error:[NSError errorWithDomain:@"NSURLErrorDomain" code:-200 userInfo:nil]];
        }
    }
    else //非HTTP请求
    {
        _totalBytes = [response expectedContentLength];
        if (_downLoadData) {
            _downLoadData = nil;
        }
        _downLoadData = [[NSMutableData alloc] init];
        [self downloadDidProgressWithOperation:self receivedBytes:[_downLoadData length] totalBytes:_totalBytes info:nil];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (NO == isFailed) {
        [_downLoadData appendData:data];
        [self downloadDidProgressWithOperation:self receivedBytes:[_downLoadData length] totalBytes:_totalBytes info:nil];
        
        if (_path) {
            [_downLoadData writeToFile:[_path stringByAppendingString:@".temp"] atomically:YES];
        }
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (isFailed == NO) {
        if (_downLoadData.length == 0 || _downLoadData.length < _totalBytes) {
            [self downloadDidFailWithOperation:self error:[NSError errorWithDomain:@"NSURLErrorDomain" code:NSURLErrorDownloadDecodingFailedToComplete userInfo:nil]];
        }
        else
        {
            [[BaseDownloaderCache sharedInstance] saveImagedata:_downLoadData toPath:_downloadURL.absoluteString];
            if (breakpoint_resume) {
                if (_path) {
                    [[NSFileManager defaultManager] removeItemAtPath:[_path stringByAppendingString:@".temp"] error:nil];
                }
            }
            [self downloadDidCompleteWithOperation:self data:_downLoadData];
        }
    }
}


#pragma mark - --------------------属性相关--------------------
- (void)setDownloadURL:(NSURL *)url
{
    if (_downloadURL != url) {
        _downloadURL = nil;
        _downloadURL = url;
        downloadRange = 0;
        if (breakpoint_resume) {
            _path = nil;
            self.path = [[BaseDownloaderCache sharedInstance] getImageSavePath:_downloadURL.absoluteString];
        }
    }
}

- (void)setPath:(NSString *)path
{
    if (_path != path) {
        _path = nil;
        _path = path;
    }
}

#pragma mark - --------------------接口API--------------------
- (void)cancel
{
    if (NO == isFinished && NO == [self isCancelled]) {
        
        [super cancel];
        
        if (_connection) {
            [_connection cancel];
        }
        
        [self downloadDidCancelWithOperation:self];
    }
}

@end
