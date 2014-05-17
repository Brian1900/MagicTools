//
//  BrianDataSource.h
//  MagicalTools
//
//  Created by Brian on 14-5-15.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import "BaseDataSource.h"
#import "BrianDataManager.h"

@class BrianDataSource;

extern BrianDataSource *__dataSource;

void initDataSource();
void freeDataSource();

@interface BrianDataSource : BaseDataSource

@property (nonatomic,strong) BrianDataManager* dataManager;


@end
