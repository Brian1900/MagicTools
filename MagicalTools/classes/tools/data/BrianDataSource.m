//
//  BrianDataSource.m
//  MagicalTools
//
//  Created by Brian on 14-5-15.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import "BrianDataSource.h"




@implementation BrianDataSource

BaseDataSource *__dataSource;

void initDataSource()
{
    if (__dataSource == nil) {
        __dataSource = [[BrianDataSource alloc] init];
    }
}

void freeDataSource()
{
    __dataSource = nil;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.dataManager = [[BrianDataManager alloc] init];
        [self.dataManager readData];
    }
    return self;
}

@end