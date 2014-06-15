//
//  BrianDataManager.h
//  MagicalTools
//
//  Created by 陆 文杰 on 14-4-26.
//  Copyright (c) 2014年 陆 文杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrianDataManager : NSObject

@property (nonatomic,strong) NSMutableArray* cityDatas;

- (void)readData;

@end

@interface BrianCityData : NSObject

@property (nonatomic,strong) NSString* cityName;

@property (nonatomic,strong) NSDecimalNumber* salaryBefore;

@property (nonatomic,strong) NSDecimalNumber* startTax;
@property (nonatomic,strong) NSDecimalNumber* minSecurity;
@property (nonatomic,strong) NSDecimalNumber* maxSecurity;
@property (nonatomic,strong) NSDecimalNumber* baseSecurity;
@property (nonatomic,strong) NSDecimalNumber* minHouse;
@property (nonatomic,strong) NSDecimalNumber* maxHouse;
@property (nonatomic,strong) NSDecimalNumber* baseHouse;

@property (nonatomic,strong) NSDecimalNumber* payableTax;

@property (nonatomic,strong) NSDecimalNumber* paidTax;
@property (nonatomic,strong) NSDecimalNumber* startPaidTax;
@property (nonatomic,strong) NSDecimalNumber* salaryAfter;

@property (nonatomic,strong) NSDecimalNumber* selfOld;
@property (nonatomic,strong) NSDecimalNumber* selfMed;
@property (nonatomic,strong) NSDecimalNumber* selfJob;
@property (nonatomic,strong) NSDecimalNumber* selfHouse;
@property (nonatomic,strong) NSDecimalNumber* selfHurt;
@property (nonatomic,strong) NSDecimalNumber* selfBirth;

@property (nonatomic,strong) NSDecimalNumber* selfPaidOld;
@property (nonatomic,strong) NSDecimalNumber* selfPaidMed;
@property (nonatomic,strong) NSDecimalNumber* selfPaidJob;
@property (nonatomic,strong) NSDecimalNumber* selfPaidHouse;
@property (nonatomic,strong) NSDecimalNumber* selfPaidHurt;
@property (nonatomic,strong) NSDecimalNumber* selfPaidBirth;

@property (nonatomic,strong) NSDecimalNumber* comOld;
@property (nonatomic,strong) NSDecimalNumber* comMed;
@property (nonatomic,strong) NSDecimalNumber* comJob;
@property (nonatomic,strong) NSDecimalNumber* comHurt;
@property (nonatomic,strong) NSDecimalNumber* comBirth;
@property (nonatomic,strong) NSDecimalNumber* comHouse;

@property (nonatomic,strong) NSDecimalNumber* comPaidOld;
@property (nonatomic,strong) NSDecimalNumber* comPaidMed;
@property (nonatomic,strong) NSDecimalNumber* comPaidJob;
@property (nonatomic,strong) NSDecimalNumber* comPaidHurt;
@property (nonatomic,strong) NSDecimalNumber* comPaidBirth;
@property (nonatomic,strong) NSDecimalNumber* comPaidHouse;

- (void)reset;

@end
