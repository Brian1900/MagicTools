//
//  BrianExchangeRequest.h
//  MagicalTools
//
//  Created by Brian on 14-5-22.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkBase.h"

@interface BrianExchangeRequest : NetWorkBaseRequest

@property (nonatomic,strong) NSString* beforeType;
@property (nonatomic,strong) NSString* afterType;

@end

@interface BrianExchangeResponse : NetWorkBaseResponse

@end