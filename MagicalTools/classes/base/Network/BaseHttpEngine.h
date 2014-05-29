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

- (void)httpGetWithURL:(NSString*)url success:(SenderSuccessMethod)success fail:(SenderFailMethod)fail;

- (NSDictionary*)serObject:(id)object;
- (NSDictionary*)serFileData:(id)object;

- (NSMutableData*)dataWithDictionary:(NSDictionary*)dictionary;

@end
