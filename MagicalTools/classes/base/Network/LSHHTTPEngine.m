//
//  LSHHTTPEngine.m
//  LuShiHelper
//
//  Created by Brian on 13-11-12.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "LSHHTTPEngine.h"
#import <objc/runtime.h>
#import "NSString+Unicode.h"
#import "BaseUtil.h"
#import "BaseDataSource.h"

static LSHHTTPEngine* LSHHttpEngine = nil;

@implementation LSHHTTPEngine

+ (id)getInstance
{
    if (!LSHHttpEngine) {
        LSHHttpEngine = [[LSHHTTPEngine alloc] init];
    }
    return LSHHttpEngine;
}

- (id)init
{
    if (self = [super init]) {
        _httpEngine = [BaseHttpEngine getInstance];
        _ipAddress = [BaseUtil getIPAddress];
        _token = @"";
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        NSString *uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        self.uuid = uuid;
        
        if (!httpCache) {
            httpCache = [BaseHTTPCache sharedInstance];
        }
    }
    
    return self;
}

- (void)sendGetExchange:(BrianExchangeRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    [_httpEngine httpGetWithURL:[NSString stringWithFormat:request.url,request.beforeType,request.afterType]  success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendGetExchange header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//
         
         TLog(@"sendGetExchange sendUpdate Response Data = [%@]",json);
         
//         NSError* error = nil;
//         
//         NSDictionary *weatherDic = nil;
//         @try {
//             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//         }
//         @catch (NSException *exception) {
//             fail(sender);
//         }
//         @finally {
//             
//         }
//         
//         if (error) {
//             TLog(@"sendGetExchange fail json error");
//             fail(sender);
//         }else{
//             gm861ClientUpdateResponse* response = [[gm861ClientUpdateResponse alloc] init];
//             
//             response.status = [[weatherDic objectForKey:@"status"] integerValue];
//             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
//             
//             if (response.status == 0) {
//                 fail(response);
//             }else{
//                 response.version = [weatherDic objectForKey:@"version"];
//                 response.clientURL = [weatherDic objectForKey:@"clientURL"];
//                 
//                 success(response);
//             }
//         }
     }fail:^(id sender)
     {
         TLog(@"sendGetExchange fail");
         fail(nil);
     }];
}

@end
