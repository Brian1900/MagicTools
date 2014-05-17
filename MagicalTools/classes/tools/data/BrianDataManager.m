//
//  BrianDataManager.m
//  MagicalTools
//
//  Created by 陆 文杰 on 14-4-26.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import "BrianDataManager.h"

@implementation BrianDataManager

- (id)init
{
    if (self = [super init]) {
        self.cityDatas = [NSMutableArray arrayWithCapacity:1];
    }
    
    return self;
}

- (void)readData
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"cityData" ofType:@"plist"];
    
    NSArray* dataArray = [[NSArray alloc] initWithContentsOfFile:path];
    
    for (NSDictionary* dic in dataArray) {
        BrianCityData* data = [[BrianCityData alloc] init];
        data.cityName = [dic objectForKey:@"cityName"];
        data.startMoney = [[dic objectForKey:@"startMoney"] integerValue];
        data.minMoney = [[dic objectForKey:@"minMoney"] integerValue];
        data.houseMinMoney = [[dic objectForKey:@"houseMinMoney"] integerValue];
        data.housemaxMoney = [[dic objectForKey:@"housemaxMoney"] integerValue];
        data.selfOld = [[dic objectForKey:@"selfOld"] floatValue];
        data.selfMed = [[dic objectForKey:@"selfMed"] floatValue];
        data.selfJob = [[dic objectForKey:@"selfJob"] floatValue];
        data.selfHouse = [[dic objectForKey:@"selfHouse"] floatValue];
        data.selfHurt = [[dic objectForKey:@"selfHurt"] floatValue];
        data.selfBirth = [[dic objectForKey:@"selfBirth"] floatValue];
        data.comOld = [[dic objectForKey:@"comOld"] floatValue];
        data.comMed = [[dic objectForKey:@"comMed"] floatValue];
        data.comJob = [[dic objectForKey:@"comJob"] floatValue];
        data.comHurt = [[dic objectForKey:@"comHurt"] floatValue];
        data.comBirth = [[dic objectForKey:@"comBirth"] floatValue];
        data.comHouse = [[dic objectForKey:@"comHouse"] floatValue];
        
        [self.cityDatas addObject:data];
    }
}

@end

@implementation BrianCityData

@end


