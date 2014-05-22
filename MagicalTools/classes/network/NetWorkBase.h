//
//  NetWorkBase.h
//  GM86
//
//  Created by Brian on 14-3-26.
//  Copyright (c) 2014年 gm86. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkBaseRequest : NSObject

@property (strong,nonatomic) NSString* url;
//@property (strong,nonatomic) NSString* source;
//@property (strong,nonatomic) NSString* UDID;
//@property (strong,nonatomic) NSString* currentVersion;
//@property (strong,nonatomic) NSString* ip;
//@property (strong,nonatomic) NSString* userid;

@end

@interface NetWorkBaseResponse : NSObject

@property (assign,nonatomic) NSInteger status;
@property (strong,nonatomic) NSString* errorMessage;

@end