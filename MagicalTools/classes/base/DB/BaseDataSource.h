//
//  LSHDataSource.h
//  LuShiHelper
//
//  Created by Brian on 13-11-26.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDefine.h"



@interface BaseDataSource : NSObject

@property (assign, nonatomic) BOOL isWIFI;//是否是wifi
@property (assign, nonatomic) NSInteger viewHeight;
@property (strong, nonatomic) NSString* ipAddress;
@property (assign, nonatomic) BOOL isIphone5;
@property (assign, nonatomic) CGFloat version;//设备版本号
@property (strong, nonatomic) NSString* app_version;//软件版本号
@property (strong, nonatomic) NSString* UDID;

@end
