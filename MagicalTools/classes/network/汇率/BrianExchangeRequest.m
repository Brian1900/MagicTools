//
//  BrianExchangeRequest.m
//  MagicalTools
//
//  Created by Brian on 14-5-22.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import "BrianExchangeRequest.h"

@implementation BrianExchangeRequest

- (id)init
{
	self = [super init];
    
    self.url = @"http://download.finance.yahoo.com/d/quotes.html?s=%@=X&f=sl1d1t1ba&e=.html";
    
    return self;
}

@end

@implementation BrianExchangeResponse

- (id)init
{
	self = [super init];
    
    return self;
}

@end