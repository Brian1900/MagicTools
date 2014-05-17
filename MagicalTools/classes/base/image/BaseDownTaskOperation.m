//
//  BaseDownTaskOperation.m
//  LuShiHelper
//
//  Created by Brian on 13-12-10.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseDownTaskOperation.h"

@implementation BaseDownTaskOperation

@synthesize downLoadData = _downLoadData;
@synthesize downloadURL = _downloadURL;

+ (id)operation
{
    BaseDownTaskOperation *operation = [[[self class] alloc] init];
    return operation;
}

- (void)setDelegate:(id<BaseDownloadTaskOperationDelegate>)newDelegate
{
    _delegate = newDelegate;
}

@end
