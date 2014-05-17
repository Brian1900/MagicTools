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

@property (nonatomic,assign) NSInteger startMoney;
@property (nonatomic,assign) NSInteger minMoney;
@property (nonatomic,assign) NSInteger houseMinMoney;
@property (nonatomic,assign) NSInteger housemaxMoney;

@property (nonatomic,assign) float selfOld;
@property (nonatomic,assign) float selfMed;
@property (nonatomic,assign) float selfJob;
@property (nonatomic,assign) float selfHouse;
@property (nonatomic,assign) float selfHurt;
@property (nonatomic,assign) float selfBirth;

@property (nonatomic,assign) float comOld;
@property (nonatomic,assign) float comMed;
@property (nonatomic,assign) float comJob;
@property (nonatomic,assign) float comHurt;
@property (nonatomic,assign) float comBirth;
@property (nonatomic,assign) float comHouse;



@end

@interface Brian : NSObject



@end
