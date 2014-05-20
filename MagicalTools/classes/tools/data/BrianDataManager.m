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
        data.minSecurity = [[dic objectForKey:@"startSecurity"] integerValue];
        data.maxSecurity = [[dic objectForKey:@"maxHouse"] integerValue];
        data.startTax = [[dic objectForKey:@"startTax"] integerValue];
        data.minHouse = [[dic objectForKey:@"minHouse"] integerValue];
        data.maxHouse = [[dic objectForKey:@"maxHouse"] integerValue];
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

- (void)reset
{
    self.selfPaidOld = 0.0;
    self.selfPaidMed = 0.0;
    self.selfPaidJob = 0.0;
    self.selfPaidHouse = 0.0;
    self.selfPaidHurt = 0.0;
    self.selfPaidBirth = 0.0;
    
    self.baseSecurity = 0;
    self.baseHouse = 0;
    
    self.payableTax = 0;
    self.paidTax = 0.0;
    self.salaryAfter = 0.0;
    
    self.comPaidOld = 0.0;
    self.comPaidMed = 0.0;
    self.comPaidJob = 0.0;
    self.comPaidHurt = 0.0;
    self.comPaidBirth = 0.0;
    self.comPaidHouse = 0.0;
}

@end


