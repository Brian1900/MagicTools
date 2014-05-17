//
//  LSHDataSource.m
//  LuShiHelper
//
//  Created by Brian on 13-11-26.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseDataSource.h"
#import "BaseNavigationController.h"
#import "APService.h"
#import "SvUDIDTools.h"
#import "BaseUtil.h"

@implementation BaseDataSource

-(id)init
{
    self = [super init];
    if (self) {
        _ipAddress = [BaseUtil getIPAddress];
        _app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        NSString* strVersion = [[UIDevice currentDevice] systemVersion];
        _version = [strVersion floatValue];
        _UDID = [SvUDIDTools UDID];
        
        if (DEVICE_HEIGHT == 568) {
            _isIphone5 = YES;
        }
    }
    return self;
}

@end
