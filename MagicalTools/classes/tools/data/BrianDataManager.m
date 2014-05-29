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
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"cityData" ofType:@"plist"];
//    
//    NSArray* dataArray = [[NSArray alloc] initWithContentsOfFile:path];
//    
//    for (NSDictionary* dic in dataArray) {
//        BrianCityData* data = [[BrianCityData alloc] init];
//        data.cityName = [dic objectForKey:@"cityName"];
//        data.minSecurity = [[dic objectForKey:@"startSecurity"] integerValue];
//        data.maxSecurity = [[dic objectForKey:@"maxHouse"] integerValue];
//        data.startTax = [[dic objectForKey:@"startTax"] integerValue];
//        data.minHouse = [[dic objectForKey:@"minHouse"] integerValue];
//        data.maxHouse = [[dic objectForKey:@"maxHouse"] integerValue];
//        data.selfOld = [[dic objectForKey:@"selfOld"] floatValue];
//        data.selfMed = [[dic objectForKey:@"selfMed"] floatValue];
//        data.selfJob = [[dic objectForKey:@"selfJob"] floatValue];
//        data.selfHouse = [[dic objectForKey:@"selfHouse"] floatValue];
//        data.selfHurt = [[dic objectForKey:@"selfHurt"] floatValue];
//        data.selfBirth = [[dic objectForKey:@"selfBirth"] floatValue];
//        data.comOld = [[dic objectForKey:@"comOld"] floatValue];
//        data.comMed = [[dic objectForKey:@"comMed"] floatValue];
//        data.comJob = [[dic objectForKey:@"comJob"] floatValue];
//        data.comHurt = [[dic objectForKey:@"comHurt"] floatValue];
//        data.comBirth = [[dic objectForKey:@"comBirth"] floatValue];
//        data.comHouse = [[dic objectForKey:@"comHouse"] floatValue];
//        
//        [self.cityDatas addObject:data];
//    }
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"个税计算" ofType:@"txt"];
    
    NSError* error;
    
    NSString* taxString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];//
    
    NSArray* citys = [taxString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    for (int i=0; i<[citys count]; i++) {
        NSString* city = [citys objectAtIndex:i];
        
        NSArray* cityData = [city componentsSeparatedByString:@";"];
        
        BrianCityData* data = [[BrianCityData alloc] init];
        data.cityName = [cityData objectAtIndex:0];
        data.startTax = [NSDecimalNumber decimalNumberWithString:[cityData objectAtIndex:1]];
        data.minSecurity = [NSDecimalNumber decimalNumberWithString:[cityData objectAtIndex:2]];
        data.minHouse = [NSDecimalNumber decimalNumberWithString:[cityData objectAtIndex:3]];
        data.maxSecurity = [NSDecimalNumber decimalNumberWithString:[cityData objectAtIndex:4]];
        data.maxHouse = [NSDecimalNumber decimalNumberWithString:[cityData objectAtIndex:4]];
        
        data.selfOld = [NSDecimalNumber decimalNumberWithString:[cityData objectAtIndex:5]];
        data.selfMed = [NSDecimalNumber decimalNumberWithString:[cityData objectAtIndex:6]];
        data.selfJob = [NSDecimalNumber decimalNumberWithString:[cityData objectAtIndex:7]];
        data.selfHouse = [NSDecimalNumber decimalNumberWithString:[cityData objectAtIndex:8]];
        
        data.comOld = [NSDecimalNumber decimalNumberWithString:[cityData objectAtIndex:9]];
        data.comMed = [NSDecimalNumber decimalNumberWithString:[cityData objectAtIndex:10]];
        data.comJob = [NSDecimalNumber decimalNumberWithString:[cityData objectAtIndex:11]];
        data.comHurt = [NSDecimalNumber decimalNumberWithString:[cityData objectAtIndex:12]];
        data.comBirth = [NSDecimalNumber decimalNumberWithString:[cityData objectAtIndex:13]];
        data.comHouse = [NSDecimalNumber decimalNumberWithString:[cityData objectAtIndex:14]];
        
        [self.cityDatas addObject:data];
    }
}

@end

@implementation BrianCityData

- (void)reset
{
    self.selfHurt = [NSDecimalNumber decimalNumberWithString:@"0"];
    self.selfBirth = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    self.selfPaidOld = [NSDecimalNumber decimalNumberWithString:@"0"];
    self.selfPaidMed = [NSDecimalNumber decimalNumberWithString:@"0"];;
    self.selfPaidJob = [NSDecimalNumber decimalNumberWithString:@"0"];;
    self.selfPaidHouse = [NSDecimalNumber decimalNumberWithString:@"0"];;
    self.selfPaidHurt = [NSDecimalNumber decimalNumberWithString:@"0"];;
    self.selfPaidBirth = [NSDecimalNumber decimalNumberWithString:@"0"];;
    
    self.baseSecurity = [NSDecimalNumber decimalNumberWithString:@"0"];;
    self.baseHouse = [NSDecimalNumber decimalNumberWithString:@"0"];;
    
    self.payableTax = [NSDecimalNumber decimalNumberWithString:@"0"];;
    self.paidTax = [NSDecimalNumber decimalNumberWithString:@"0"];;
    self.startPaidTax = [NSDecimalNumber decimalNumberWithString:@"0"];;
    self.salaryBefore = [NSDecimalNumber decimalNumberWithString:@"0"];;
    self.salaryAfter = [NSDecimalNumber decimalNumberWithString:@"0"];;
    
    self.comPaidOld = [NSDecimalNumber decimalNumberWithString:@"0"];;
    self.comPaidMed = [NSDecimalNumber decimalNumberWithString:@"0"];;
    self.comPaidJob = [NSDecimalNumber decimalNumberWithString:@"0"];;
    self.comPaidHurt = [NSDecimalNumber decimalNumberWithString:@"0"];;
    self.comPaidBirth = [NSDecimalNumber decimalNumberWithString:@"0"];;
    self.comPaidHouse = [NSDecimalNumber decimalNumberWithString:@"0"];;
}

@end


