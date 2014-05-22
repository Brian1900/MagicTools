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

@property (nonatomic,assign) float salaryBefore;

@property (nonatomic,assign) NSInteger startTax;
@property (nonatomic,assign) NSInteger minSecurity;
@property (nonatomic,assign) NSInteger maxSecurity;
@property (nonatomic,assign) NSInteger baseSecurity;
@property (nonatomic,assign) NSInteger minHouse;
@property (nonatomic,assign) NSInteger maxHouse;
@property (nonatomic,assign) NSInteger baseHouse;

@property (nonatomic,assign) NSInteger payableTax;

@property (nonatomic,assign) float paidTax;
@property (nonatomic,assign) float startPaidTax;
@property (nonatomic,assign) float salaryAfter;

@property (nonatomic,assign) float selfOld;
@property (nonatomic,assign) float selfMed;
@property (nonatomic,assign) float selfJob;
@property (nonatomic,assign) float selfHouse;
@property (nonatomic,assign) float selfHurt;
@property (nonatomic,assign) float selfBirth;

@property (nonatomic,assign) float selfPaidOld;
@property (nonatomic,assign) float selfPaidMed;
@property (nonatomic,assign) float selfPaidJob;
@property (nonatomic,assign) float selfPaidHouse;
@property (nonatomic,assign) float selfPaidHurt;
@property (nonatomic,assign) float selfPaidBirth;

@property (nonatomic,assign) float comOld;
@property (nonatomic,assign) float comMed;
@property (nonatomic,assign) float comJob;
@property (nonatomic,assign) float comHurt;
@property (nonatomic,assign) float comBirth;
@property (nonatomic,assign) float comHouse;

@property (nonatomic,assign) float comPaidOld;
@property (nonatomic,assign) float comPaidMed;
@property (nonatomic,assign) float comPaidJob;
@property (nonatomic,assign) float comPaidHurt;
@property (nonatomic,assign) float comPaidBirth;
@property (nonatomic,assign) float comPaidHouse;

- (void)reset;

@end
