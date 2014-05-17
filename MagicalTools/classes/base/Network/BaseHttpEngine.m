//
//  BaseHttpEngine.m
//  LuShiHelper
//
//  Created by Brian on 13-11-12.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseHttpEngine.h"
#import <objc/runtime.h>

static BaseHttpEngine* httpEngine = nil;

@implementation BaseHttpEngine

+ (id)getInstance
{
    if (!httpEngine) {
        httpEngine = [[BaseHttpEngine alloc] init];
    }
    return httpEngine;
}

- (id)init
{
    if (self = [super init]) {
        _networkQueue = [[ASINetworkQueue alloc] init];
        [_networkQueue reset];
        [_networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete:)];
        [_networkQueue setRequestDidFailSelector:@selector(imageFetchFailed:)];
    }
    
    return self;
}

- (NSDictionary*)serObject:(id)object
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    const char *cClassName = [NSStringFromClass([object class])  UTF8String];
    
    id theClass = objc_getClass(cClassName);
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList(theClass, &outCount);
    
    NSMutableArray *propertyNames = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *propertyNameString = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSString *propertyAttString = [[NSString alloc] initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        [propertyNames addObject:propertyNameString];
        
        SEL selector = NSSelectorFromString(propertyNameString);
        id value = nil;
        
        if ([propertyAttString rangeOfString:@"Ti"].length!=0) {
            value = [NSString stringWithFormat:@"%d",[[object valueForKey:propertyNameString] intValue]];
        }else{
            value = [object performSelector:selector];
        }
        
//        if (value == nil)
//        {
//            value = [NSNull null];
//        }
        
        if ([propertyAttString rangeOfString:@"NSMutableString"].length==0) {
            if ([propertyAttString rangeOfString:@"String"].length != 0 && value == nil)
            {
                value = @"";
            }
            
            [dic setObject:value forKey:propertyNameString];
        }
    }
    free(properties);
    
    return dic;
}

- (NSDictionary*)serFileData:(id)object
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    const char *cClassName = [NSStringFromClass([object class])  UTF8String];
    
    id theClass = objc_getClass(cClassName);
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList(theClass, &outCount);
    
    NSMutableArray *propertyNames = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *propertyNameString = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSString *propertyAttString = [[NSString alloc] initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        [propertyNames addObject:propertyNameString];
        
        SEL selector = NSSelectorFromString(propertyNameString);
        
        if ([propertyAttString rangeOfString:@"NSMutableString"].length!=0) {
            id value = nil;
            
            if ([propertyAttString rangeOfString:@"Ti"].length!=0) {
                value = [NSString stringWithFormat:@"%d",[[object valueForKey:propertyNameString] intValue]];
            }else{
                value = [object performSelector:selector];
            }
            
//            if (value == nil)
//            {
//                value = [NSNull null];
//            }
            
            if (value) {
                [dic setObject:value forKey:propertyNameString];
            }
        }
    }
    free(properties);
    
    return dic;
}

- (NSURL*)urlWithUrl:(NSString*)url dictionary:(NSDictionary*)dictionary
{
    if (!dictionary || [dictionary count] == 0) {
        TLog(@"HTTP GET %@",url);
        return [NSURL URLWithString:url];
    }
    url = [url stringByAppendingString:@"?"];
    NSArray* keys = [dictionary allKeys];
    for (int i=0; i<[keys count]; i++) {
        NSString* value = [dictionary objectForKey:[keys objectAtIndex:i]];
        url = [url stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",[keys objectAtIndex:i],value]];
    }
    
    url = [url substringToIndex:url.length-1];
    TLog(@"HTTP GET %@",url);
    return [NSURL URLWithString:url];
}

- (NSMutableData*)dataWithDictionary:(NSDictionary*)dictionary
{
    if (!dictionary || [dictionary count] == 0) {
        return [NSMutableData dataWithCapacity:1];
    }
    
    NSString* dataString = @"";
    NSArray* keys = [dictionary allKeys];
    for (int i=0; i<[keys count]; i++) {
        NSString* value = [dictionary objectForKey:[keys objectAtIndex:i]];
        dataString = [dataString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",[keys objectAtIndex:i],value]];
    }
    
    dataString = [dataString substringToIndex:dataString.length-1];
    TLog(@"HTTP POST body = [%@]",dataString);
    return [[dataString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
}

- (void)httpGetWithURL:(NSString*)urlNSString dictionary:(NSDictionary*)dictionary success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSURL* url = [self urlWithUrl:urlNSString dictionary:dictionary];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    request.successCallBack = success;
    request.failCallBack = fail;
    
    [_networkQueue addOperation:request];
    
    [_networkQueue go];
}

- (void)httpPostDataProcessWithURL:(NSString*)urlNSString dictionary:(NSDictionary*)dictionary file:(NSDictionary*)filePathDic headDic:headDic success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail uploadDelegate:(id<ASIProgressDelegate>)delegate
{
    NSURL* url = [self urlWithUrl:urlNSString dictionary:nil];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    
    [delegate setCurrentRequest:request];
    
    if (delegate) {
        [request setUploadProgressDelegate:delegate];
    }
    
    for (int i=0; i<[[dictionary allKeys] count]; i++) {
        [request setPostValue:[dictionary objectForKey:[[dictionary allKeys] objectAtIndex:i]] forKey:[[dictionary allKeys] objectAtIndex:i]];
    }
    
    for (int i=0; i<[[filePathDic allKeys] count]; i++) {
        NSString* filePath = [filePathDic objectForKey:[[filePathDic allKeys] objectAtIndex:i]];
        if (filePath.length > 0) {
            [request setFile:[filePathDic objectForKey:[[filePathDic allKeys] objectAtIndex:i]] forKey:[[filePathDic allKeys] objectAtIndex:i]];
        }
    }
    
    for (int i=0; i<[[headDic allKeys] count]; i++) {
        [request addRequestHeader:[[headDic allKeys] objectAtIndex:i] value:[headDic objectForKey:[[headDic allKeys] objectAtIndex:i]]];
    }
    
    TLog(@"HTTP POST URL = [%@] \n header = [%@] \n body = [%@]",urlNSString,request.requestHeaders,dictionary);
    
    request.successCallBack = success;
    request.failCallBack = fail;
    
    [request startAsynchronous];
    
//    [_networkQueue addOperation:request];
//    
//    [_networkQueue go];
}

- (void)httpPostWithURL:(NSString*)urlNSString dictionary:(NSDictionary*)dictionary file:(NSDictionary*)filePathDic headDic:headDic success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSURL* url = [self urlWithUrl:urlNSString dictionary:nil];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    
    for (int i=0; i<[[dictionary allKeys] count]; i++) {
        [request setPostValue:[dictionary objectForKey:[[dictionary allKeys] objectAtIndex:i]] forKey:[[dictionary allKeys] objectAtIndex:i]];
    }
    
    for (int i=0; i<[[filePathDic allKeys] count]; i++) {
        NSString* filePath = [filePathDic objectForKey:[[filePathDic allKeys] objectAtIndex:i]];
        if (filePath.length > 0) {
            [request setFile:[filePathDic objectForKey:[[filePathDic allKeys] objectAtIndex:i]] forKey:[[filePathDic allKeys] objectAtIndex:i]];
        }
    }
    
    for (int i=0; i<[[headDic allKeys] count]; i++) {
        [request addRequestHeader:[[headDic allKeys] objectAtIndex:i] value:[headDic objectForKey:[[headDic allKeys] objectAtIndex:i]]];
    }
    
    TLog(@"HTTP POST URL = [%@] \n header = [%@] \n body = [%@]",urlNSString,request.requestHeaders,dictionary);
    
    request.successCallBack = success;
    request.failCallBack = fail;
    
    [_networkQueue addOperation:request];
    
    [_networkQueue go];
}

//- (void)httpPostWithURL:(NSString*)urlNSString dictionary:(NSDictionary*)dictionary file:(NSDictionary*)filePathDic headDic:headDic success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
//{
//    [self httpPostWithURL:urlNSString dictionary:dictionary file:filePathDic headDic:headDic success:success fail:fail];
//}

- (void)imageFetchComplete:(ASIHTTPRequest *)request
{
    if ([_networkQueue operationCount] == 0) {
        [_networkQueue setSuspended:YES];
    }
}

- (void)imageFetchFailed:(ASIHTTPRequest *)request
{
	if ([_networkQueue operationCount] == 0) {
        [_networkQueue setSuspended:YES];
    }
}

@end
