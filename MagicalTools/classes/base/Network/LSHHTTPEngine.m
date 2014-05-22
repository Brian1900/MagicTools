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





@end
