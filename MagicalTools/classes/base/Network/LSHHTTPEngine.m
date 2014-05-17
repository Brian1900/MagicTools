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

- (NSDictionary*)buildHeadDic:(NetWorkBaseRequest*)request
{
    return [NSDictionary dictionaryWithObjects:@[request.type,@"ios",__dataSource.UDID,__dataSource.app_version,__dataSource.ipAddress,__dataSource.userModel.userid] forKeys:@[@"type",@"source",@"UDID",@"currentVersion",@"ip",@"userid"]];
}




#pragma mark - 1-9
- (void)sendUpdate:(gm861ClientUpdateRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendUpdate header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
//         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendUpdate sendUpdate Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendUpdate fail json error");
             fail(sender);
         }else{
             gm861ClientUpdateResponse* response = [[gm861ClientUpdateResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 response.version = [weatherDic objectForKey:@"version"];
                 response.clientURL = [weatherDic objectForKey:@"clientURL"];
                 
                 success(response);
             }
         }
     }fail:^(id sender)
     {
         TLog(@"sendUpdate fail");
         fail(nil);
     }];
}

- (void)sendSendVerify:(gm862SendVerifyRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendSendVerify header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendSendVerify Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendSendVerify fail json error");
             fail(sender);
         }else{
             gm862SendVerifyResponse* response = [[gm862SendVerifyResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 response.second = [weatherDic objectForKey:@"second"];
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendSendVerify fail");
         fail(nil);
     }];
}

- (void)sendGetVerifyImage:(gm862_2GetVerifyImageRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendGetVerifyImage header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendGetVerifyImage Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendGetVerifyImage fail json error");
             fail(sender);
         }else{
             gm862_2GetVerifyImageResponse* response = [[gm862_2GetVerifyImageResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 response.secretURL = [weatherDic objectForKey:@"secretURL"];
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendGetVerifyImage fail");
         fail(nil);
     }];
}

- (void)sendVerify:(gm863VerifyRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendVerify header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendVerify Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendVerify fail json error");
             fail(sender);
         }else{
             gm863VerifyResponse* response = [[gm863VerifyResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendVerify fail");
         fail(nil);
     }];
}

- (void)sendRegist:(gm864RegistRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendRegist header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendRegist Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendRegist fail json error");
             fail(sender);
         }else{
             gm864RegistResponse* response = [[gm864RegistResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 response.userid = [weatherDic objectForKey:@"userid"];
                 response.imageURL = [NSString stringWithFormat:@"%@%@",imageHost,[weatherDic objectForKey:@"imageURL"]];
                 response.appUsed = [[weatherDic objectForKey:@"appUsed"] integerValue];
                 response.record = [[weatherDic objectForKey:@"record"] integerValue];
                 response.nickName = [weatherDic objectForKey:@"nickName"];
                 response.attNum = [[weatherDic objectForKey:@"attNum"] integerValue];
                 response.fansNum = [[weatherDic objectForKey:@"fansNum"] integerValue];
                 response.source = [weatherDic objectForKey:@"source"];
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendRegist fail");
         fail(nil);
     }];
}
- (void)sendNicknameCheck:(gm864_2NicknameCheckRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"gm864_2NicknameCheckRequest header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"gm864_2NicknameCheckRequest Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"gm864_2NicknameCheckRequest fail json error");
             fail(sender);
         }else{
             gm864_2NicknameCheckResponse *response=[[gm864_2NicknameCheckResponse alloc]init];             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 success(response);
             }
        }
         
     }fail:^(id sender)
     {
         TLog(@"gm864_2NicknameCheckRequest fail");
         fail(nil);
     }];
}
- (void)sendLogin:(gm865LoginRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendLogin header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendLogin Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendLogin fail json error");
             fail(sender);
         }else{
             gm865LoginResponse* response = [[gm865LoginResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 response.userid = [weatherDic objectForKey:@"userid"];
                 response.imageURL = [NSString stringWithFormat:@"%@%@",imageHost,[weatherDic objectForKey:@"imageURL"]];
                 response.appUsed = [[weatherDic objectForKey:@"appUsed"] integerValue];
                 response.record = [[weatherDic objectForKey:@"record"] integerValue];
                 response.nickName = [weatherDic objectForKey:@"nickName"];
                 response.attNum = [[weatherDic objectForKey:@"attNum"] integerValue];
                 response.fansNum = [[weatherDic objectForKey:@"fansNum"] integerValue];
                 response.source = [weatherDic objectForKey:@"source"];
                 response.signature = [weatherDic objectForKey:@"signature"];
                 response.signLabel = [weatherDic objectForKey:@"signLabel"];
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendLogin fail");
         fail(nil);
     }];
}

- (void)sendThirdLogin:(gm865LoginRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendThirdLogin header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendThirdLogin Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendThirdLogin fail json error");
             fail(sender);
         }else{
             gm865_2LoginResponse* response = [[gm865_2LoginResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 response.userid = [weatherDic objectForKey:@"userid"];
                 response.imageURL = [NSString stringWithFormat:@"%@%@",imageHost,[weatherDic objectForKey:@"imageURL"]];
                 response.appUsed = [[weatherDic objectForKey:@"appUsed"] integerValue];
                 response.record = [[weatherDic objectForKey:@"record"] integerValue];
                 response.nickName = [weatherDic objectForKey:@"nickName"];
                 response.attNum = [[weatherDic objectForKey:@"attNum"] integerValue];
                 response.fansNum = [[weatherDic objectForKey:@"fansNum"] integerValue];
                 response.source = [weatherDic objectForKey:@"source"];
                 response.signature = [weatherDic objectForKey:@"signature"];
                 response.signLabel = [weatherDic objectForKey:@"signLabel"];
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendThirdLogin fail");
         fail(nil);
     }];
}

- (void)sendSetPassword:(gm866SetPasswordRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendSetPassword header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendSetPassword Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendSetPassword fail json error");
             fail(sender);
         }else{
             gm866SetPasswordResponse* response = [[gm866SetPasswordResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 response.userid = [weatherDic objectForKey:@"userid"];
                 response.imageURL = [NSString stringWithFormat:@"%@%@",imageHost,[weatherDic objectForKey:@"imageURL"]];
                 response.appUsed = [[weatherDic objectForKey:@"appUsed"] integerValue];
                 response.record = [[weatherDic objectForKey:@"record"] integerValue];
                 response.nickName = [weatherDic objectForKey:@"nickName"];
                 response.attNum = [[weatherDic objectForKey:@"attNum"] integerValue];
                 response.fansNum = [[weatherDic objectForKey:@"fansNum"] integerValue];
                 response.source = [weatherDic objectForKey:@"source"];
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendSetPassword fail");
         fail(nil);
     }];
}

- (void)sendRecommendElement:(gm867RecommendElementRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendRecommendElement header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendRecommendElement Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendRecommendElement fail json error");
             fail(sender);
         }else{
             gm867RecommendElementResponse* response = [[gm867RecommendElementResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"elementArray"];
                 
                 response.elementArray = [NSMutableArray arrayWithCapacity:1];
                 for (NSDictionary* dic in array) {
                     gm867RecommendModel* model = [[gm867RecommendModel alloc] init];
                     model.element = [dic objectForKey:@"element"];
                     model.imageURL = [NSString stringWithFormat:@"%@%@",imageHost,[dic objectForKey:@"imageURL"]];
                     [response.elementArray addObject:model];
                 }
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendRecommendElement fail");
         fail(nil);
     }];
}

- (void)sendSendElement:(gm868SendElementRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendSendElement header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendSendElement Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendSendElement fail json error");
             fail(sender);
         }else{
             gm868SendElementResponse* response = [[gm868SendElementResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendSendElement fail");
         fail(nil);
     }];
}

- (void)sendRecommendAtt:(gm869RecommendAttRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"SendRecommendAtt header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"SendRecommendAtt Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"SendRecommendAtt fail json error");
             fail(sender);
         }else{
             gm869RecommendAttResponse* response = [[gm869RecommendAttResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"attentionArray"];
                 
                 response.attentionArray = [NSMutableArray arrayWithCapacity:1];
                 for (NSDictionary* dic in array) {
                     gm869Model* model = [[gm869Model alloc] init];
                     model.userid = [dic objectForKey:@"userid"];
                     model.nickName = [dic objectForKey:@"nickName"];
                     model.imageURL = [NSString stringWithFormat:@"%@%@",imageHost,[dic objectForKey:@"imageURL"]];
                     model.signature = [dic objectForKey:@"signature"];
                     
                     [response.attentionArray addObject:model];
                 }
                 
                 success(response);
             }
         }
     }fail:^(id sender)
     {
         TLog(@"SendRecommendAtt fail");
         fail(nil);
     }];
}

#pragma mark - 10-19

- (void)sendAttList:(gm8610_2AttListRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* asiRequest = sender;
         
         NSString* string = [[NSString alloc] initWithData:asiRequest.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendAttList header = [%@] body = [%@]",asiRequest.requestHeaders, string);
         
         NSData* data = [asiRequest responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendAttList Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendAttList fail json error");
             fail(sender);
         }else{
             gm8610_2AttListResponse* response = [[gm8610_2AttListResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"attArray"];
                 
                 response.attArray = [NSMutableArray arrayWithCapacity:1];
                 for (NSDictionary* dic in array) {
                     gm8610_2Model* model = [[gm8610_2Model alloc] init];
                     model.userid = [dic objectForKey:@"userid"];
                     model.imageURL = [NSString stringWithFormat:@"%@%@",imageHost,[dic objectForKey:@"imageURL"]];
                     model.nickName = [dic objectForKey:@"nickName"];
                     model.signature = [dic objectForKey:@"signature"];
                     model.isAtt = [[dic objectForKey:@"isAtt"] boolValue];
                     [response.attArray addObject:model];
                 }
                 
                 response.currentPage = [[weatherDic objectForKey:@"currentPage"] integerValue];
                 response.totlePage = [[weatherDic objectForKey:@"totlePage"] integerValue];
                 response.totleNum = [[weatherDic objectForKey:@"totleNum"] integerValue];
                 
                 if ([request.operation isEqualToString:@"1"]) {
                     __dataSource.userModel.attNum = response.totleNum;
                 }else{
                     __dataSource.userModel.fansNum = response.totleNum;
                 }
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendAttList fail");
         fail(nil);
     }];
}

- (void)sendAttManager:(gm8610AttManagerRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* asiRequest = sender;
         
         NSString* string = [[NSString alloc] initWithData:asiRequest.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendAttManager header = [%@] body = [%@]",asiRequest.requestHeaders, string);
         
         NSData* data = [asiRequest responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendAttManager Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendAttManager fail json error");
             fail(sender);
         }else{
             gm8610AttManagerResponse* response = [[gm8610AttManagerResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 if ([request.attentionType isEqualToString:@"2"]) {
                     if ([request.operation isEqualToString:@"1"]) {
                         __dataSource.userModel.attNum ++;
                     }else{
                         __dataSource.userModel.attNum --;
                     }
                 }
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendAttManager fail");
         fail(nil);
     }];
}

- (void)sendHotTag:(gm8611HotTagRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendHotTag header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendHotTag Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendHotTag fail json error");
             fail(sender);
         }else{
             gm8611HotTagResponse* response = [[gm8611HotTagResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"signArray"];
                 
                 response.signArray = [NSMutableArray arrayWithArray:array];
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendHotTag fail");
         fail(nil);
     }];
}

- (void)sendSelfSetting:(gm8612SelfSettingRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendSelfSetting header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendSelfSetting Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendSelfSetting fail json error");
             fail(sender);
         }else{
             gm8612SelfSettingResponse* response = [[gm8612SelfSettingResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             response.imageURL = [weatherDic objectForKey:@"imageURL"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendSelfSetting fail");
         fail(nil);
     }];
}

- (void)sendNewsManager:(gm8613NewsManagerRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail delegate:(id<ASIProgressDelegate>)delegate
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostDataProcessWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendNewsManager header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendNewsManager Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendNewsManager fail json error");
             fail(sender);
         }else{
             gm8613NewsManagerResponse* response = [[gm8613NewsManagerResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendNewsManager fail");
         fail(nil);
     } uploadDelegate:delegate];
}

- (void)sendNews:(gm8614NewsRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendNews header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendNews Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendNews fail json error");
             fail(sender);
         }else{
             gm8614NewsResponse* response = [[gm8614NewsResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"dynamicArray"];
                 response.dynamicArray = [NSMutableArray arrayWithCapacity:1];
                 BOOL isbool;
                 for (NSDictionary* dic in array)
                 {
                     gm8614NewsModel* model = [[gm8614NewsModel alloc] init];
                     model.noteid = [dic objectForKey:@"noteid"];
                     model.tarNoteid = [dic objectForKey:@"tarNoteid"];
                     model.portraitURL = [dic objectForKey:@"portraitURL"];
                     model.nickName = [dic objectForKey:@"nickName"];
                     model.label = [dic objectForKey:@"label"];
                     model.typeName = [dic objectForKey:@"typeName"];
                     model.time = [dic objectForKey:@"time"];
                     model.tip=[dic objectForKey:@"tip"];
                     model.imageURL = [NSString stringWithFormat:@"%@%@",imageHost,[dic objectForKey:@"imageURL"]];
                     model.totleNum = [[dic objectForKey:@"totalNum"] integerValue];
                     model.comment = [[dic objectForKey:@"comment"] integerValue];
                     model.greate = [[dic objectForKey:@"greate"] integerValue];
                     model.isZan = [[dic objectForKey:@"isZan"] boolValue];
                     model.isCollect = [[dic objectForKey:@"isCollect"] boolValue];
                     model.isAtt = [[dic objectForKey:@"isAtt"] boolValue];
                     model.width = [[dic objectForKey:@"width"] integerValue];
                     model.height = [[dic objectForKey:@"height"] integerValue];
                     [response.dynamicArray addObject:model];
                 }
                 
                 array = [weatherDic objectForKey:@"gameArray"];
                 response.gameArray = [NSMutableArray arrayWithCapacity:1];
                 for (NSDictionary* dic in array)
                 {
                     gm8614GameModel* model = [[gm8614GameModel alloc] init];
                     model.gameid = [dic objectForKey:@"gameid"];
                     model.imageURL = [NSString stringWithFormat:@"%@%@",gameicon,[dic objectForKey:@"imageURL"]];
                     model.name = [dic objectForKey:@"name"];
                     [response.gameArray addObject:model];
                 }
                 
                 response.gameLibid = [weatherDic objectForKey:@"gameLibid"];
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendNews fail");
         fail(nil);
     }];
}

- (void)sendZan:(gm8615ZanRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendZan header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendZan Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendZan fail json error");
             fail(sender);
         }else{
             gm8615ZanResponse* response = [[gm8615ZanResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendZan fail");
         fail(nil);
     }];
}

- (void)sendColManager:(gm8616ColManagerRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendColManager header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendColManager Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendColManager fail json error");
             fail(sender);
         }else{
             gm8616ColManagerResponse* response = [[gm8616ColManagerResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendColManager fail");
         fail(nil);
     }];
}

- (void)sendPersonDetail:(gm8617PersonDetailRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendPersonDetail header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendPersonDetail Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendPersonDetail fail json error");
             fail(sender);
         }else{
             gm8617PersonDetailResponse* response = [[gm8617PersonDetailResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 response.attNum = [weatherDic objectForKey:@"attNum"];
                 response.fansNum = [weatherDic objectForKey:@"fansNum"];
                 response.record = [[weatherDic objectForKey:@"record"] integerValue];
                 response.appUsed = [[weatherDic objectForKey:@"appUsed"] integerValue];
                 response.isAtt = [[weatherDic objectForKey:@"isAtt"] boolValue];
                 response.imageURL = [NSString stringWithFormat:@"%@%@",imageHost,[weatherDic objectForKey:@"imageURL"]];
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendPersonDetail fail");
         fail(nil);
     }];
}

- (void)sendCommentList:(gm8618CommentListRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendCommentList header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendCommentList Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendCommentList fail json error");
             fail(sender);
         }else{
             gm8618CommentListResponse* response = [[gm8618CommentListResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"dynamicArray"];
                 
                 response.dynamicArray = [NSMutableArray arrayWithCapacity:1];
                 for (NSDictionary* dic in array) {
                     gm8618Model* model = [[gm8618Model alloc] init];
                     model.commentid = [dic objectForKey:@"commentid"];
                     model.tarUserid = [dic objectForKey:@"tarUserid"];
                     model.portraitURL = [NSString stringWithFormat:@"%@%@",imageHost,[dic objectForKey:@"portraitURL"]];
                     model.nickName = [dic objectForKey:@"nickName"];
                     model.time = [dic objectForKey:@"time"];
                     model.comment = [dic objectForKey:@"comment"];
                     [response.dynamicArray addObject:model];
                 }
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendCommentList fail");
         fail(nil);
     }];
}

- (void)sendCommentManager:(gm8619CommentManagerRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendCommentManager header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendCommentManager Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendCommentManager fail json error");
             fail(sender);
         }else{
             gm8619CommentManagerResponse* response = [[gm8619CommentManagerResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendCommentManager fail");
         fail(nil);
     }];
}

#pragma mark - 20-29
- (void)sendSearch:(gm8620SearchRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendSearch header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendSearch Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendSearch fail json error");
             fail(sender);
         }else{
             gm8620SearchResponse* response = [[gm8620SearchResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"resultArray"];
                 
                 response.resultArray = [NSMutableArray arrayWithCapacity:1];
                 for (NSDictionary* dic in array) {
                     gm8620Model* model = [[gm8620Model alloc] init];
                     
                     model.resultid = [dic objectForKey:@"resultid"];
                     model.imageURL = [dic objectForKey:@"imageURL"];
                     model.nickName = [dic objectForKey:@"nickName"];
                     model.isTar = [[dic objectForKey:@"isTar"] boolValue];
                     model.signature = [dic objectForKey:@"signature"];
                     
                     [response.resultArray addObject:model];
                 }
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendSearch fail");
         fail(nil);
     }];
}

- (void)sendInviteFriends:(gm8621InviteFriendsRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendInviteFriends header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendInviteFriends Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendInviteFriends fail json error");
             fail(sender);
         }else{
             gm8621InviteFriendsResponse* response = [[gm8621InviteFriendsResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"phoneArray"];
                 
                 response.phoneArray = [NSMutableArray arrayWithCapacity:1];
                 for (NSDictionary* dic in array) {
                     gm8621model* model = [[gm8621model alloc] init];
                     
                     model.userid = [dic objectForKey:@"userid"];
                     model.isAtt = [[dic objectForKey:@"isAtt"] boolValue];
                     model.nickName = [dic objectForKey:@"nickName"];
                     model.icon = [dic objectForKey:@"icon"];
                     model.signature = [dic objectForKey:@"signature"];
                     model.phoneNum= [dic objectForKey:@"phoneNum"];
                     [response.phoneArray addObject:model];
                 }
                 
                 success(response);
             }
             
             
             
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendInviteFriends fail");
         fail(nil);
     }];
}

- (void)sendPushSetting:(gm8622PushSettingRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendPushSetting header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendPushSetting Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendPushSetting fail json error");
             fail(sender);
         }else{
             gm8622PushSettingResponse* response = [[gm8622PushSettingResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 success(response);
             }
//             response.pushStutus = [weatherDic objectForKey:@"pushStutus"];

             
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendPushSetting fail");
         fail(nil);
     }];
}
- (void)sendPushSettingtwo:(gm8622_2PushSettingRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail{
 
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendPushSettingtwo header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendPushSettingtwo Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendPushSettingtwo fail json error");
             fail(sender);
         }else{
             gm8622_2PushSettingResponse* response = [[gm8622_2PushSettingResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             response.pushStatus = [weatherDic objectForKey:@"pushStatus"];
             if (response.status == 0) {
                 fail(response);
             }else{
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendPushSettingtwo fail");
         fail(nil);
     }];
}
- (void)sendMessageManager:(gm8623MessageManagerRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendMessageManager header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendMessageManager Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendMessageManager fail json error");
             fail(sender);
         }else{
             gm8623MessageManagerResponse* response = [[gm8623MessageManagerResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"infoArray"];
                 
                 response.infoArray = [NSMutableArray arrayWithCapacity:1];
                 for (NSDictionary* dic in array) {
                     gm8623Model* model = [[gm8623Model alloc] init];
                     
                     model.infoid = [dic objectForKey:@"infoid"];
                     model.userid = [dic objectForKey:@"userid"];
                     model.userName = [dic objectForKey:@"userName"];
                     model.portraitURL = [NSString stringWithFormat:@"%@%@",imageHost,[dic objectForKey:@"portraitURL"]];
                     model.imageURL = [NSString stringWithFormat:@"%@%@",imageHost,[dic objectForKey:@"imageURL"]];
                     model.message = [dic objectForKey:@"message"];
                     model.time = [dic objectForKey:@"time"];
                     
                     [response.infoArray addObject:model];
                 }
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendMessageManager fail");
         fail(nil);
     }];
}
- (void)sendGameRecommend:(gm8624GameRecommendRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail
{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendGameRecommend header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendGameRecommend Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendGameRecommend fail json error");
             fail(sender);
         }else{
             gm8624GameRecommendResponse* response = [[gm8624GameRecommendResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"gameArray"];
                 
                 response.gameArray = [NSMutableArray arrayWithCapacity:1];
                 for (NSDictionary* dic in array) {
                     gm8624Model* model = [[gm8624Model alloc] init];
                     
                     model.gameid = [dic objectForKey:@"gameid"];
                     model.gameSize = [dic objectForKey:@"gameSize"];
                     model.gameType = [dic objectForKey:@"gameType"];
                     model.name = [dic objectForKey:@"name"];
                     model.imageURL = [NSString stringWithFormat:@"%@%@",gameicon,[dic objectForKey:@"imageURL"]];
                     model.companyName = [dic objectForKey:@"companyName"];
                     model.downLoad = [dic objectForKey:@"downLoad"];
                     model.gameVersion = [dic objectForKey:@"gameVersion"];
                     model.gameScore = [dic objectForKey:@"gameScore"];
                     
                     [response.gameArray addObject:model];
                 }
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendGameRecommend fail");
         fail(nil);
     }];
}

-(void)sendFocusFigure:(gm8625FocusFigureRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendFocusFigure header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendFocusFigure Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendFocusFigure fail json error");
             fail(sender);
         }else{
             gm8625FocusFigureResponse* response = [[gm8625FocusFigureResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"slideArray"];
                 
                 response.slideArray = [NSMutableArray arrayWithCapacity:1];
                 for (NSDictionary* dic in array) {
                     gm8625Model* model = [[gm8625Model alloc] init];
                     
                     model.type = [dic objectForKey:@"type"];
                     model.tarid = [dic objectForKey:@"tarid"];
                     model.imageURL = [NSString stringWithFormat:@"%@%@",imageHost,[dic objectForKey:@"imageURL"]];
                     
                     [response.slideArray addObject:model];
                 }
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendFocusFigure fail");
         fail(nil);
     }];}

-(void)sendClassification:(gm8626ClassificationRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendClassification header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendClassification Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendClassification fail json error");
             fail(sender);
         }else{
             gm8626ClassificationResponse* response = [[gm8626ClassificationResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"typeArray"];
                 
                 response.typeArray = [NSMutableArray arrayWithCapacity:1];
                 for (NSDictionary* dic in array) {
                     gm8626Model* model = [[gm8626Model alloc] init];
                     model.Type = [dic objectForKey:@"type"];
                     
                     NSArray* catearray  = [dic objectForKey:@"cateArray"];
                     
                     model.cateArray = [NSMutableArray arrayWithCapacity:1];
                     for (NSDictionary* dict in catearray) {
                         
                         gm8626cateModel* casemodel = [[gm8626cateModel alloc] init];
                         
                         casemodel.cateid = [dict objectForKey:@"cateid"];
                         casemodel.cateName = [dict objectForKey:@"cateName"];
                         casemodel.cateDetail = [dict objectForKey:@"cateDetail"];
                         [model.cateArray addObject:casemodel];
                         
                     }

                     [response.typeArray addObject:model];
                 }
                 
                 success(response);
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendClassification fail");
         fail(nil);
     }];}

-(void)sendScreening:(gm8627ScreeningRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendScreening header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendScreening Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendScreening fail json error");
             fail(sender);
         }else{
             gm8627ScreeningResponse* response = [[gm8627ScreeningResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"gameArray"];
                 response.currentPage = [[weatherDic objectForKey:@"currentPage"] integerValue];
                 response.totlePage = [[weatherDic objectForKey:@"totlePage"] integerValue];
                 
                 response.gameArray = [NSMutableArray arrayWithCapacity:1];
                 for (NSDictionary* dic in array) {
                     gm8627Model* model = [[gm8627Model alloc] init];
                     
                     model.gameid = [dic objectForKey:@"gameid"];
                     model.gameSize = [dic objectForKey:@"gameSize"];
                     model.gameType = [dic objectForKey:@"gameType"];
                     model.name = [dic objectForKey:@"name"];
                     model.imageURL = [NSString stringWithFormat:@"%@%@",imageHost,[dic objectForKey:@"imageURL"]];
                     model.companyName = [dic objectForKey:@"companyName"];
                     model.downLoad = [dic objectForKey:@"downLoad"];
                     model.gameVersion = [dic objectForKey:@"gameVersion"];
                     model.gameScore = [dic objectForKey:@"gameScore"];
                     
                     [response.gameArray addObject:model];
                 }
                 
                 success(response);

             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendScreening fail");
         fail(nil);
     }];
}

-(void)sendGameDetail:(gm8628GameDetailRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendGameDetail header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendGameDetail Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendGameDetail fail json error");
             fail(sender);
         }else{
             gm8628GameDetailResponse* response = [[gm8628GameDetailResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"imageArray"];
                 
                 
                 response.imageArray = [NSMutableArray arrayWithCapacity:1];
                 for (NSString* url in array) {
                    [response.imageArray addObject:[NSString stringWithFormat:@"%@%@",gameicon,url]];
                 }
                 
                 response.icon = [NSString stringWithFormat:@"%@%@",gameicon,[weatherDic objectForKey:@"icon"]];
                 response.name=[weatherDic objectForKey:@"name"];
                 response.fansNum=[[weatherDic objectForKey:@"fansNum"] intValue];
                 response.version=[weatherDic objectForKey:@"wersion"];
                 response.size=[weatherDic objectForKey:@"size"];
                 response.info=[weatherDic objectForKey:@"info"];
                 response.type=[weatherDic objectForKey:@"type"];
                 response.isCol=[[weatherDic objectForKey:@"isCol"] boolValue];
                 response.isAtt=[[weatherDic objectForKey:@"isAtt"] boolValue];
                 response.appGameid=[weatherDic objectForKey:@"appGameid"];
                 response.download=[weatherDic objectForKey:@"download"];

                 success(response);
                 
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendGameDetail fail");
         fail(nil);
     }];
}

-(void)sendSearchGame:(gm8629SearchGameRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendsearchGame header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendsearchGame Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendsearchGame fail json error");
             fail(sender);
         }else{
             gm8629SearchGameResponse* response = [[gm8629SearchGameResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"gameArray"];
                 response.currentPage = [[weatherDic objectForKey:@"currentPage"] integerValue];
                 response.totlePage = [[weatherDic objectForKey:@"totlePage"] integerValue];
                 
                 response.gameArray = [NSMutableArray arrayWithCapacity:1];
                 for (NSDictionary* dic in array) {
                     gm8629Model* model = [[gm8629Model alloc] init];
                     
                     model.gameid = [dic objectForKey:@"gameid"];
                     model.gameSize = [dic objectForKey:@"gameSize"];
                     model.gameType = [dic objectForKey:@"gameType"];
                     model.name = [dic objectForKey:@"name"];
                     model.imageURL = [NSString stringWithFormat:@"%@%@",gameicon,[dic objectForKey:@"imageURL"]];
                     model.companyName = [dic objectForKey:@"companyName"];
                     model.downLoad = [dic objectForKey:@"downLoad"];
                     model.gameVersion = [dic objectForKey:@"gameVersion"];
                     model.gameScore = [dic objectForKey:@"gameScore"];
                     
                     [response.gameArray addObject:model];
                 }
                 
                 success(response);
                 
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendsearchGame fail");
         fail(nil);
     }];
}

-(void)sendCollectGameManager:(gm8630CollectManagerRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendCollectGameManager header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendCollectGameManager Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendCollectGameManager fail json error");
             fail(sender);
         }else{
             gm8630CollectManagerResponse* response = [[gm8630CollectManagerResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 success(response);
                 
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendCollectGameManager fail");
         fail(nil);
     }];
}

-(void)sendMyCollectGame:(gm8631MyCollectGamesRequest *)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail{
    NSDictionary* textDic = [_httpEngine serObject:request];
    NSDictionary* imgDic = [_httpEngine serFileData:request];
    NSDictionary* headDic = [self buildHeadDic:request];
    
    [_httpEngine httpPostWithURL:service_home dictionary:textDic file:imgDic headDic:headDic success:^(id sender)
     {
         ASIHTTPRequest* request = sender;
         
         NSString* string = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
         TLog(@"sendMyCollectGame header = [%@] body = [%@]",request.requestHeaders, string);
         
         NSData* data = [request responseData];
         NSMutableString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];//NSUTF8StringEncoding
         
         [json replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [json length])];
         
         TLog(@"sendMyCollectGame Response Data = [%@]",json);
         
         NSError* error = nil;
         
         NSDictionary *weatherDic = nil;
         @try {
             weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         }
         @catch (NSException *exception) {
             fail(sender);
         }
         @finally {
             
         }
         
         if (error) {
             TLog(@"sendMyCollectGame fail json error");
             fail(sender);
         }else{
             gm8631MyCollectGamesResponse* response = [[gm8631MyCollectGamesResponse alloc] init];
             
             response.status = [[weatherDic objectForKey:@"status"] integerValue];
             response.errorMessage = [weatherDic objectForKey:@"errorMessage"];
             
             if (response.status == 0) {
                 fail(response);
             }else{
                 NSArray* array = [weatherDic objectForKey:@"gameArray"];
                 
                 response.gameArray = [NSMutableArray arrayWithCapacity:1];
                 for (NSDictionary* dic in array) {
                     gm8631Model* model = [[gm8631Model alloc] init];
                     
                     model.gameid = [dic objectForKey:@"gameid"];
                     model.gameSize = [dic objectForKey:@"gameSize"];
                     model.gameType = [dic objectForKey:@"gameType"];
                     model.name = [dic objectForKey:@"name"];
                     model.imageURL = [NSString stringWithFormat:@"%@%@",gameicon,[dic objectForKey:@"imageURL"]];
                     model.companyName = [dic objectForKey:@"companyName"];
                     model.downLoad = [dic objectForKey:@"downLoad"];
                     model.gameVersion = [dic objectForKey:@"gameVersion"];
                     model.gameScore = [dic objectForKey:@"gameScore"];
                     
                     [response.gameArray addObject:model];
                 }
                 
                 success(response);
                 
             }
         }
         
     }fail:^(id sender)
     {
         TLog(@"sendMyCollectGame fail");
         fail(nil);
     }];
}

@end
