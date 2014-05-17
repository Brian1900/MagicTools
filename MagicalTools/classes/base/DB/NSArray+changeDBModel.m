//
//  NSArray+changeDBModel.m
//  LuShiHelper
//
//  Created by Brian on 13-11-13.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "NSArray+changeDBModel.h"

@implementation NSArray(changeDBModel)

- (NSInteger)cardType:(NSString*)typeName
{
    if ([typeName isEqualToString:@"技能"]) {
        return ECardTypeSkill;
    }else
        if ([typeName isEqualToString:@"随从"]) {
        return ECardTypeAccompany;
    }else if ([typeName isEqualToString:@"武器"]) {
        return ECardTypeWeapon;
    }else if ([typeName isEqualToString:@"英雄技能"]) {
        return ECardTypeHeroSkill;
    }
    
    TLog(@"cardType %@",typeName);
    return 0;
}

- (NSInteger)cardProfession:(NSString*)professionName
{
    if ([professionName isEqualToString:@"战士"]) {
        return ECardProfessionWarriop;
    }else if ([professionName isEqualToString:@"牧师"]) {
        return ECardProfessionPriest;
    }else if ([professionName isEqualToString:@"萨满"]) {
        return ECardProfessionShaman;
    }else if ([professionName isEqualToString:@"术士"]) {
        return ECardProfessionWarlock;
    }else if ([professionName isEqualToString:@"圣骑士"]) {
        return ECardProfessionPaladin;
    }else if ([professionName isEqualToString:@"德鲁伊"]) {
        return ECardProfessionDrvid;
    }else if ([professionName isEqualToString:@"猎人"]) {
        return ECardProfessionHunter;
    }else if ([professionName isEqualToString:@"法师"]) {
        return ECardProfessionMage;
    }else if ([professionName isEqualToString:@"潜行者"]) {
        return ECardProfessionRogue;
    }else if ([professionName isEqualToString:@"中立"]) {
        return ECardProfessionNeutrality;
    }
    
    TLog(@"cardProfession %@",professionName);
    return 0;
}

- (NSInteger)cardRarity:(NSString*)rarityName
{
    if ([rarityName isEqualToString:@"稀有"]) {
        return ECardRarityRarity;
    }else if ([rarityName isEqualToString:@"普通"]) {
        return ECardRarityNormal;
    }else if ([rarityName isEqualToString:@"免费"]) {
        return ECardRarityFree;
    }else if ([rarityName isEqualToString:@"传说"]) {
        return ECardRarityLegend;
    }else if ([rarityName isEqualToString:@"史诗"]) {
        return ECardRarityEpic;
    }else if ([rarityName isEqualToString:@""]) {
        return ECardRarityNon;
    }
    
    TLog(@"cardRarity %@",rarityName);
    
    return 0;
}

- (NSInteger)cardGroup:(NSString*)groupName
{
    if ([groupName isEqualToString:@"专家"]) {
        return ECardGroupProfession;
    }else if([groupName isEqualToString:@"普通"]){
        return ECardGroupNormal;
    }else if([groupName isEqualToString:@"基础"]){
        return ECardGroupBasic;
    }else if([groupName isEqualToString:@"任务"]){
        return ECardGroupTask;
    }else if([groupName isEqualToString:@"奖励"]){
        return ECardGroupAward;
    }else if([groupName isEqualToString:@""]){
        return ECardGroupNon;
    }
    
    TLog(@"cardGroup %@",groupName);
    return 0;
}

- (NSInteger)cardRace:(NSString*)raceName
{
    if ([raceName isEqualToString:@"恶魔"]) {
        return ECardRaceDemon;
    }else if([raceName isEqualToString:@"野兽"]){
        return ECardRaceBeast;
    }else if([raceName isEqualToString:@"海盗"]){
        return ECardRacePirate;
    }else if([raceName isEqualToString:@"龙"]){
        return ECardRaceDragon;
    }else if([raceName isEqualToString:@"鱼人"]){
        return ECardRaceMerman;
    }else if([raceName isEqualToString:@"野兽"]){
        return ECardRaceBeast;
    }else if([raceName isEqualToString:@"图腾"]){
        return ECardRaceTotem;
    }
    
    TLog(@"cardRace %@",raceName);
    return 0;
}

- (NSMutableArray*)changeModel
{
    NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:1];
//
//    for (int i=0; i<[self count]; i++) {
//        CardModel* cardModel = [self objectAtIndex:i];
//        
//        LSHDBModel* DBModel = [[LSHDBModel alloc] init];
//        DBModel.cardid = cardModel.cardid;
//        DBModel.cardname = cardModel.cardname;
//        DBModel.imgpath = cardModel.imgpath;
//        DBModel.description = cardModel.description;
//        DBModel.options = cardModel.options;
//        DBModel.version = cardModel.version;
//        DBModel.imgpath_app = cardModel.imgpath_app;
//        DBModel.exist = cardModel.status;
//        
//        NSArray* attArray = [cardModel.attribute allKeys];
//        for (int j=0; j<[attArray count]; j++) {
//            NSString* key = [attArray objectAtIndex:j];
//            NSString* value = [cardModel.attribute objectForKey:key];
//            if ([key isEqualToString:@"卡牌类型"]) {
//                DBModel.type = [NSString stringWithFormat:@"%d",[self cardType:value]];
//            }else if ([key isEqualToString:@"职业"]) {
//                DBModel.profession = [NSString stringWithFormat:@"%d",[self cardProfession:value]];
//            }else if ([key isEqualToString:@"稀有度"]) {
//                DBModel.rarity = [NSString stringWithFormat:@"%d",[self cardRarity:value]];
//            }else if ([key isEqualToString:@"所属卡组"]) {
//                DBModel.belongs = [NSString stringWithFormat:@"%d",[self cardGroup:value]];
//            }else if ([key isEqualToString:@"画师"]) {
//                DBModel.painter = value;
//            }else if ([key isEqualToString:@"合成需要"]) {
//                DBModel.compose = value;
//            }else if ([key isEqualToString:@"分解获得"]) {
//                DBModel.decompose = value;
//            }else if ([key isEqualToString:@"可收集"]){
//                DBModel.collection = value;
//            }else if ([key isEqualToString:@"种族"]){
//                DBModel.race = [NSString stringWithFormat:@"%d",[self cardRace:value]];
//            }else if ([key isEqualToString:@"特殊技能"]){
//                DBModel.speSkill = value;
//            }else if ([key isEqualToString:@"生命"]){
//                DBModel.health = value;
//            }else if ([key isEqualToString:@"攻击"]){
//                DBModel.attack = value;
//            }else if ([key isEqualToString:@"法力"]){
//                DBModel.mana= value;
//            }else if ([key isEqualToString:@"可加入卡组"]){
//                DBModel.canSelect= value;
//            }else {
//                TLog(@"attArray.key = %@",key);
//            }
//        }
//        
//        [newArray addObject:DBModel];
//    }
//    
    return newArray;
}

@end
