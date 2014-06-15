//
//  LSHHTTPEngine.h
//  LuShiHelper
//
//  Created by Brian on 13-11-12.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHttpEngine.h"
#import "CTSerializeObject.h"
#import "BaseDefine.h"
#import "BaseHTTPCache.h"

#import "BrianExchangeRequest.h"

@interface LSHHTTPEngine : NSObject
{
    BaseHTTPCache* httpCache;
}

@property (strong, nonatomic) BaseHttpEngine* httpEngine;
@property (nonatomic, copy) NSString* ipAddress;
@property (nonatomic, copy) NSString* token;
@property (nonatomic, copy) NSString* uuid;

+ (id)getInstance;

- (void)sendGetExchange:(BrianExchangeRequest*)request success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

@end
