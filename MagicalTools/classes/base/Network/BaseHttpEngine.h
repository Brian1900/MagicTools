//
//  BaseHttpEngine.h
//  LuShiHelper
//
//  Created by Brian on 13-11-12.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "BaseDefine.h"

@interface BaseHttpEngine : NSObject

@property (strong, nonatomic) ASINetworkQueue* networkQueue;

+ (id)getInstance;

- (void)httpGetWithURL:(NSString*)url dictionary:(NSDictionary*)dictionary success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;
- (void)httpPostWithURL:(NSString*)urlNSString dictionary:(NSDictionary*)dictionary file:(NSDictionary*)filePathDic headDic:headDic success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

//- (void)httpPostWithURL:(NSString*)urlNSString dictionary:(NSDictionary*)dictionary file:(NSDictionary*)filePathDic headDic:headDic success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (void)httpPostDataProcessWithURL:(NSString*)urlNSString dictionary:(NSDictionary*)dictionary file:(NSDictionary*)filePathDic headDic:headDic success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail uploadDelegate:(id<ASIProgressDelegate>)delegate;

- (NSDictionary*)serObject:(id)object;
- (NSDictionary*)serFileData:(id)object;

- (NSMutableData*)dataWithDictionary:(NSDictionary*)dictionary;

@end
