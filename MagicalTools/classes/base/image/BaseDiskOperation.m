//
//  BaseDiskOperation.m
//  LuShiHelper
//
//  Created by Brian on 13-12-10.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseDiskOperation.h"

#define kDiskOperation       @"operation"
#define kDiskOperationReceivedBytes   @"receivedBytes"
#define kDiskOperationTotalBytes      @"totalBytes"
#define kDiskOperationBakeInfo        @"bakeInfo"
#define kDiskOperationData            @"data"
#define kDiskOperationError           @"error"

@implementation BaseDiskOperation

- (void)dealloc
{
    self.delegate = nil;
    
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
//    _diskOperationType = eBaseDiskOperationTypeRead;
}

#pragma mark 主入口
- (void)main
{
    @autoreleasepool {
        if (![self isCancelled] && _downloadURL) {
            [[NSThread currentThread] setName:@"com.base.diskOperation"];
            
            [self downloadDidStartWithOperation:self];
            
            if ([[BaseDownloaderCache sharedInstance] hasCacheForKey:_downloadURL.absoluteString]) {
                NSString* path = [[BaseDownloaderCache sharedInstance] getCachePathForKey:_downloadURL.absoluteString];
                
                NSData* data = [[NSData alloc] initWithContentsOfFile:path];
                
                [self downloadDidProgressWithOperation:self receivedBytes:data.length totalBytes:data.length info:nil];
                [self downloadDidCompleteWithOperation:self data:data];
            }else{
                [self downloadDidFailWithOperation:self error:[NSError errorWithDomain:@"Read File Error!" code:-300 userInfo:nil]];
            }
            
//            NSString *key = nil;
//            if (NO == isSmallCache_) {
//                key = [[BaseDownloaderCache sharedInstance] getCachePathForKey:_downloadURL.absoluteString];
//            }
//            else
//            {
//                key = [NSString stringWithFormat:@"%@_@%.0f*%.0f", [CTDownloaderCache keyForURL:_downloadURL], smallCacheSize_.width, smallCacheSize_.height];
//                
//                //大图写入文件，但是小图未写入文件，直接做压缩
//                if ([[CTDownloaderCache sharedInstance] hasCacheForKey:[CTDownloaderCache keyForURL:_downloadURL]] && ![[CTDownloaderCache sharedInstance] hasCacheForKey:key]) {
//                    if (data_) {
//                        data_ = nil;
//                    }
//                    data_ = [[NSMutableData alloc] initWithData:[[CTDownloaderCache sharedInstance] dataForKey:key]];
//                    UIImage *tempImage = [UIImage imageWithData:data_];
//                    UIImage *scaledImage = [CTDownloadTaskOperation scaleImage:tempImage toSize:smallCacheSize_];
//                    NSData *scaledData = UIImagePNGRepresentation(scaledImage);
//                    [[CTDownloaderCache sharedInstance] setData:scaledData forKey:[NSString stringWithFormat:@"%@_@%.0f*%.0f", [CTDownloaderCache keyForURL:_downloadURL], smallCacheSize_.width, smallCacheSize_.height]];
//                    data_ = nil;;
//                    data_ = [[NSMutableData alloc] initWithData:scaledData];
//                }
//            }
//            
//            if (data_ || [[CTDownloaderCache sharedInstance] hasCacheForKey:key]) {
//                if (!data_) {
//                    if (kCTDownloaderIsUseMemoryCache) {
//                        data_ = [[NSMutableData alloc] initWithData:[[CTDownloaderCache sharedInstance] getMemoryCacheForKey:key]];//方案二：将下载状态图存入缓存中
//                    }
//                    else
//                    {
//                        data_ = [[NSMutableData alloc] initWithData:[[CTDownloaderCache sharedInstance] dataForKey:key]];//方案一：直接从物理文件获取图片数据
//                    }
//                }
//                
//                [self downloadDidProgressWithOperation:self receivedBytes:data_.length totalBytes:data_.length info:nil];
//                [self downloadDidCompleteWithOperation:self data:data_];
//            }
//            else
//            {
//                [self downloadDidFailWithOperation:self error:[NSError errorWithDomain:@"Read File Error!" code:-300 userInfo:nil]];
//            }
        }
    }
}
#pragma mark - --------------------功能函数--------------------
#pragma mark - Create Dictionary
- (NSDictionary *)createProgressDictionaryWithReceivedBytes:(NSUInteger)receivedBytes totalBytes:(long long)totalBytes info:(id)bakeInfo
{
    return [NSDictionary dictionaryWithObjectsAndKeys:self, kDiskOperation, [NSNumber numberWithUnsignedInteger:receivedBytes], kDiskOperationReceivedBytes, [NSNumber numberWithLongLong:totalBytes], kDiskOperationTotalBytes, [NSNull null], kDiskOperationBakeInfo, nil];
}

- (NSDictionary *)createCompleteDictionaryWithData:(NSData *)data
{
    return [NSDictionary dictionaryWithObjectsAndKeys:self, kDiskOperation, data, kDiskOperationData, nil];
}

- (NSDictionary *)createFailDictionaryWithError:(NSError *)error
{
    return [NSDictionary dictionaryWithObjectsAndKeys:self, kDiskOperation, error, kDiskOperationError, nil];
}

#pragma mark - 回调
- (void)downloadDidStartWithOperation:(BaseDiskOperation *)operation
{
    [self performSelectorOnMainThread:@selector(downloadDidStartInMainThread:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:operation, kDiskOperation, nil] waitUntilDone:YES];
}
- (void)downloadDidStartInMainThread:(NSDictionary *)dictionary
{
    BaseDiskOperation *operation = [dictionary valueForKey:kDiskOperation];
    
    if ([self isCancelled]) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadDidStartWithOperation:)]) {
        [self.delegate downloadDidStartWithOperation:operation];
    }
}
- (void)downloadDidProgressWithOperation:(BaseDiskOperation *)operation receivedBytes:(NSUInteger)receivedBytes totalBytes:(long long)totalBytes info:(id)bakeInfo
{
    [self performSelectorOnMainThread:@selector(downloadDidProgressInMainThread:) withObject:[self createProgressDictionaryWithReceivedBytes:receivedBytes totalBytes:totalBytes info:bakeInfo] waitUntilDone:YES];
}
- (void)downloadDidProgressInMainThread:(NSDictionary *)dictionary
{
    BaseDiskOperation *operation = [dictionary valueForKey:kDiskOperation];
    NSUInteger receivedBytes = [[dictionary valueForKey:kDiskOperationReceivedBytes] unsignedIntegerValue];
    long long totalBytes = [[dictionary valueForKey:kDiskOperationTotalBytes] longLongValue];
    id bakeInfo = [dictionary valueForKey:kDiskOperationBakeInfo];
    
    if ([self isCancelled]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadDidProgressWithOperation:receivedBytes:totalBytes:info:)]) {
        [self.delegate downloadDidProgressWithOperation:operation receivedBytes:receivedBytes totalBytes:totalBytes info:bakeInfo];
    }
}
- (void)downloadDidCompleteWithOperation:(BaseDiskOperation *)operation data:(NSData *)data
{
    NSData *theData = data;
    
    [self performSelectorOnMainThread:@selector(downloadDidCompleteInMainThread:) withObject:[self createCompleteDictionaryWithData:theData] waitUntilDone:YES];
}
- (void)downloadDidCompleteInMainThread:(NSDictionary *)dictionary
{
//    if (isCalledDelegate_ == NO) {
//        isCalledDelegate_ = YES;
    
        BaseDiskOperation *operation = [dictionary valueForKey:kDiskOperation];
        NSData *data = [dictionary valueForKey:kDiskOperationData];
        
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
        
        
        //        isFinished_ = YES;
//    }
    
}
- (void)downloadDidFailWithOperation:(BaseDiskOperation *)operation error:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(downloadDidFailInMainThread:) withObject:[self createFailDictionaryWithError:error] waitUntilDone:YES];
}
- (void)downloadDidFailInMainThread:(NSDictionary *)dictionary
{
//    if (isCalledDelegate_ == NO) {
//        isCalledDelegate_ = YES;
    
        BaseDiskOperation *operation = [dictionary valueForKey:kDiskOperation];
        NSError *error = [dictionary valueForKey:kDiskOperationError];
        
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
        
        //        isFinished_ = YES;
//    }
}
- (void)downloadDidCancelWithOperation:(BaseDiskOperation *)operation
{
    [self performSelectorOnMainThread:@selector(downloadDidCancelInMainThread:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:self, kDiskOperation, nil] waitUntilDone:YES];
}
- (void)downloadDidCancelInMainThread:(NSDictionary *)dictionary
{
//    if (isCalledDelegate_ == NO) {
//        isCalledDelegate_ = YES;
    
        BaseDiskOperation *operation = [dictionary valueForKey:kDiskOperation];
        
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
        
        
        //        isFinished_ = YES;
//    }
}

#pragma mark - --------------------属性相关--------------------
- (void)setDownloadURL:(NSURL *)url
{
    if (_downloadURL != url) {
        _downloadURL = nil;
        _downloadURL = url;
    }
}

#pragma mark - --------------------接口API--------------------



- (void)cancel
{
    [super cancel];
    
    [self downloadDidCancelWithOperation:self];
}

@end
