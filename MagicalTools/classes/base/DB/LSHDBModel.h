//
//  LSHDBModel.h
//  LuShiHelper
//
//  Created by Brian on 13-11-13.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ECardTypeAll            = 0,
    ECardTypeSkill          = 1,
    ECardTypeAccompany      = 2,
    ECardTypeWeapon         = 3,
    ECardTypeHeroSkill      = 4
}ECardType;

typedef enum{
    ECardProfessionAll          = -1,
    ECardProfessionPriest       = 4,
    ECardProfessionWarlock      = 8,
    ECardProfessionShaman       = 6,
    ECardProfessionHunter       = 1,
    ECardProfessionPaladin      = 3,
    ECardProfessionDrvid        = 0,
    ECardProfessionMage         = 2,
    ECardProfessionRogue        = 5,
    ECardProfessionNeutrality   = 9,
    ECardProfessionWarriop      = 7
}ECardProfession;

typedef enum{
    ECardRarityNon          = 0,
    ECardRarityAll          = 10,
    ECardRarityFree         = 20,
    ECardRarityNormal       = 30,
    ECardRarityRarity       = 40,
    ECardRarityEpic         = 50,
    ECardRarityLegend       = 60,
}ECardRarity;

typedef enum{
    ECardGroupNon           = -1,
    ECardGroupBasic         = 0,
    ECardGroupProfession    = 10,
    ECardGroupNormal        = 20,
    ECardGroupTask          = 30,
    ECardGroupAward         = 40
}ECardGroup;

typedef enum{
    ECardRaceMerman         = 0,
    ECardRaceDragon         = 1,
    ECardRacePirate         = 2,
    ECardRaceDemon          = 3,
    ECardRaceBeast          = 4,
    ECardRaceTotem          = 5
}ECardRace;

typedef enum{
    ECardManaAll        = -1,
    ECardMana0          = 0,
    ECardMana1          = 1,
    ECardMana2          = 2,
    ECardMana3          = 3,
    ECardMana4          = 4,
    ECardMana5          = 5,
    ECardMana6          = 6,
    ECardMana7          = 7,
}ECardMana;

@interface LSHDBModel : NSObject<NSCopying>

@property (copy) NSString* cardid;
@property (copy) NSString* cardname;
@property (copy) NSString* type;// int
@property (copy) NSString* profession;//职业 int
@property (copy) NSString* race;//种族 int
@property (copy) NSString* rarity;//稀有度 int
@property (copy) NSString* speSkill;//特殊技能
@property (copy) NSString* decompose;//分解
@property (copy) NSString* compose;//合成
@property (copy) NSString* collection;//可收集
@property (copy) NSString* mana;// int
@property (copy) NSString* health;// int
@property (copy) NSString* attack;// int
@property (copy) NSString* description;//卡牌描述
@property (copy) NSString* belongs;//所属卡组 int
@property (copy) NSString* painter;//画师

@property (copy) NSString* imgpath;
@property (copy) NSString* imgpath_app;
@property (copy) NSString* options;//说明
@property (copy) NSString* version;// int

@property (copy) NSString* useNewPic;//是否用新的图片
@property (copy) NSString* count;//数量
@property (copy) NSString* canSelect;//是否可加入卡组
@property (copy) NSString* exist;//1存在

+ (NSString*)getNameFromProIndex:(NSInteger)index;
+ (NSString*)getNameFromTypeIndex:(NSInteger)index;
+ (NSString*)getNameFromRarityIndex:(NSInteger)index;
+ (NSString*)getNameFromBelongIndex:(NSInteger)index;

@end

typedef enum{
    EAddCardErrorOK,
    EAddCardErrorLegendFull,
    EAddCardErrorFull,
    EAddCardErrorMax
}EAddCardError;

@interface MyCardGroup : NSObject<NSCopying>

@property (strong, nonatomic) NSMutableArray* cardGroup;//LSHDBModel
@property (copy, nonatomic) NSString* cardGroupName;
@property (copy, nonatomic) NSString* cardPro;//int ECardProfession
@property (copy, nonatomic) NSString* cardCount;
@property (copy, nonatomic) NSString* cardCount0;
@property (copy, nonatomic) NSString* cardCount1;
@property (copy, nonatomic) NSString* cardCount2;
@property (copy, nonatomic) NSString* cardCount3;
@property (copy, nonatomic) NSString* cardCount4;
@property (copy, nonatomic) NSString* cardCount5;
@property (copy, nonatomic) NSString* cardCount6;
@property (copy, nonatomic) NSString* cardCount7;

-(UIImage*)getImageFromPro;
-(EAddCardError)addCard:(LSHDBModel*)cardModel;
-(void)saveData;
-(void)deleteData;
-(NSInteger)countCard;
-(NSString*)shareURL;
-(NSData*)codeData;

@end
