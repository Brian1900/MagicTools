//
//  LSHDBModel.m
//  LuShiHelper
//
//  Created by Brian on 13-11-13.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "LSHDBModel.h"
//#import "LSHCardDBUpdate.h"
#import "BaseUtil.h"
#import "CTSerializeObject.h"
#import "BaseDataSource.h"

@implementation LSHDBModel

- (id)init
{
    if (self = [super init]) {
        _cardid = @"";
        _cardname = @"";
        _imgpath = @"";
        _description = @"";
        _options = @"";
        _version = @"";
        _health = @"";
        _mana = @"";
        _attack = @"";
        _profession = @"";
        _type = @"";
        _rarity = @"";
        _belongs = @"";
        _painter = @"";
        _decompose = @"";
        _compose = @"";
        _collection = @"";
        _useNewPic = @"0";
        _count = @"1";
        _race = @"";
        _speSkill = @"";
        _canSelect = @"";
        _exist = @"1";
    }
    
    return self;
}

+ (NSString*)getNameFromProIndex:(NSInteger)index
{
    switch (index) {
        case ECardProfessionAll:
            return @"全部";
            break;
        case ECardProfessionWarriop:
            return @"战士";
            break;
        case ECardProfessionPriest:
            return @"牧师";
            break;
        case ECardProfessionWarlock:
            return @"术士";
            break;
        case ECardProfessionShaman:
            return @"萨满";
            break;
        case ECardProfessionHunter:
            return @"猎人";
            break;
        case ECardProfessionPaladin:
            return @"圣骑士";
            break;
        case ECardProfessionDrvid:
            return @"德鲁伊";
            break;
        case ECardProfessionMage:
            return @"法师";
            break;
        case ECardProfessionRogue:
            return @"潜行者";
            break;
        case ECardProfessionNeutrality:
            return @"中立";
            break;
        default:
            return @"全部";
            break;
    }
}

+ (NSString*)getNameFromTypeIndex:(NSInteger)index
{
    switch (index) {
        case ECardTypeAll:
            return @"全部";
            break;
        case ECardTypeSkill:
            return @"技能";
            break;
        case ECardTypeAccompany:
            return @"随从";
            break;
        case ECardTypeWeapon:
            return @"武器";
            break;
        case ECardTypeHeroSkill:
            return @"英雄技能";
            break;
        default:
            return @"全部";
            break;
    }
}

+ (NSString*)getNameFromRarityIndex:(NSInteger)index
{
    switch (index) {
        case ECardRarityAll:
            return @"全部";
            break;
        case ECardRarityFree:
            return @"免费";
            break;
        case ECardRarityNormal:
            return @"普通";
            break;
        case ECardRarityRarity:
            return @"稀有";
            break;
        case ECardRarityEpic:
            return @"史诗";
            break;
        case ECardRarityLegend:
            return @"传说";
            break;
        default:
            return @"全部";
            break;
    }
}

+ (NSString*)getNameFromBelongIndex:(NSInteger)index
{
    switch (index) {
        case ECardGroupProfession:
            return @"专家";
            break;
        case ECardGroupNormal:
            return @"普通";
            break;
        case ECardGroupBasic:
            return @"基础";
            break;
        case ECardGroupTask:
            return @"任务";
            break;
        case ECardGroupAward:
            return @"奖励";
            break;
        default:
            return @"全部";
            break;
    }
}

-  (id)copyWithZone:(NSZone *)zone
{
    LSHDBModel* model = [LSHDBModel allocWithZone:zone];
    model.cardid = self.cardid;
    model.cardname = self.cardname;
    model.type = self.type;
    model.profession = self.profession;
    model.race = self.race;
    model.speSkill = self.speSkill;
    model.decompose = self.decompose;
    model.compose = self.compose;
    model.collection = self.collection;
    model.mana = self.mana;
    model.health = self.health;
    model.attack = self.attack;
    model.description = self.description;
    model.belongs = self.belongs;
    model.painter = self.painter;
    model.imgpath = self.imgpath;
    model.imgpath_app = self.imgpath_app;
    model.options = self.options;
    model.version = self.version;
    model.useNewPic = self.useNewPic;
    model.count = self.count;
    model.canSelect = self.canSelect;
    model.exist = self.exist;
    return model;
}

@end


@implementation MyCardGroup

- (id)init
{
    if (self = [super init]) {
        self.cardGroup = [NSMutableArray arrayWithCapacity:1];
        self.cardGroupName = @"";
        self.cardPro = @"2";
        self.cardCount = @"0";
        self.cardCount0 = @"0";
        self.cardCount1 = @"0";
        self.cardCount2 = @"0";
        self.cardCount3 = @"0";
        self.cardCount4 = @"0";
        self.cardCount5 = @"0";
        self.cardCount6 = @"0";
        self.cardCount7 = @"0";
    }
    
    return self;
}

- (MyCardGroup*)copyWithZone:(NSZone *)zone
{
    MyCardGroup* newModel = [MyCardGroup allocWithZone:zone];
    newModel.cardGroup = [NSMutableArray arrayWithCapacity:1];
    for (int i=0; i<[self.cardGroup count]; i++) {
        [newModel.cardGroup addObject:[[self.cardGroup objectAtIndex:i] copy]];
    }
    newModel.cardGroupName = self.cardGroupName;
    newModel.cardPro = self.cardPro;
    newModel.cardCount = self.cardCount;
    newModel.cardCount0 = self.cardCount0;
    newModel.cardCount1 = self.cardCount1;
    newModel.cardCount2 = self.cardCount2;
    newModel.cardCount3 = self.cardCount3;
    newModel.cardCount4 = self.cardCount4;
    newModel.cardCount5 = self.cardCount5;
    newModel.cardCount6 = self.cardCount6;
    newModel.cardCount7 = self.cardCount7;
    return newModel;
}

-(UIImage*)getImageFromPro
{
    switch ([self.cardPro integerValue]) {
        case ECardProfessionWarriop:
            return [UIImage imageNamed:@"img_zhanshi.png"];
            break;
        case ECardProfessionPriest:
            return [UIImage imageNamed:@"img_mushi.png"];
            break;
        case ECardProfessionWarlock:
            return [UIImage imageNamed:@"img_shushi.png"];
            break;
        case ECardProfessionShaman:
            return [UIImage imageNamed:@"img_saman.png"];
            break;
        case ECardProfessionHunter:
            return [UIImage imageNamed:@"img_lieren.png"];
            break;
        case ECardProfessionPaladin:
            return [UIImage imageNamed:@"img_shengqishi.png"];
            break;
        case ECardProfessionDrvid:
            return [UIImage imageNamed:@"img_deluyi.png"];
            break;
        case ECardProfessionMage:
            return [UIImage imageNamed:@"img_fashi.png"];
            break;
        case ECardProfessionRogue:
            return [UIImage imageNamed:@"img_qianxingzhe.png"];
            break;
        default:
            return [UIImage imageNamed:@"img_fashi.png"];;
            break;
    }
}

-(EAddCardError)addCard:(LSHDBModel*)cardModel
{
    if ([self.cardCount integerValue] >= 30) {
        return EAddCardErrorFull;
    }
    
    EAddCardError error = EAddCardErrorOK;
    
    LSHDBModel* existCard = nil;
    
    for (int i = 0; i < [self.cardGroup count]; i ++) {
        LSHDBModel* model = [self.cardGroup objectAtIndex:i];
        if ([model.cardid isEqualToString:cardModel.cardid]) {
            if ([model.count isEqualToString:@"2"]) {
                error = EAddCardErrorMax;
            }else{
                existCard = model;
            }
            break;
        }
    }
    
    if (error == EAddCardErrorOK) {
        if (existCard) {
            if ([existCard.rarity isEqualToString:@"60"]) {
                error = EAddCardErrorLegendFull;
            }else{
                existCard.count = @"2";
                self.cardCount = [NSString stringWithFormat:@"%d",[self.cardCount integerValue]+1];
            }
        }else{
            [self.cardGroup addObject:cardModel];
            self.cardCount = [NSString stringWithFormat:@"%d",[self.cardCount integerValue]+1];
        }
    }
    
    return error;
}



//-(void)saveData
//{
//    NSString* path;
//    if (__dataSource.currentEditCardGroup) {
//        path = [BaseUtil getFileSavePath:__dataSource.currentEditCardGroup.cardGroupName pos:@"txt" isMatch:YES];
//        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//        
//        __dataSource.currentEditCardGroup = self;
//        
//        path = [BaseUtil getFileSavePath:self.cardGroupName pos:@"txt" isMatch:YES];
//    }else{
//        path = [BaseUtil getFileSavePath:self.cardGroupName pos:@"txt" isMatch:NO];
//        self.cardGroupName = [path.lastPathComponent stringByDeletingPathExtension];
//    }
//    
//    NSString* content = [[CTSerializeObject getInstance] serialize:self];
//    [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//}

//-(void)deleteData
//{
//    NSString* path = [BaseUtil getFileSavePath:self.cardGroupName pos:@"txt" isMatch:YES];
//    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//}

//-(NSInteger)countCard
//{
//    NSInteger count0 = 0;
//    NSInteger count1 = 0;
//    NSInteger count2 = 0;
//    NSInteger count3 = 0;
//    NSInteger count4 = 0;
//    NSInteger count5 = 0;
//    NSInteger count6 = 0;
//    NSInteger count7 = 0;
//    for (int i=0; i<[self.cardGroup count]; i++) {
//        LSHDBModel* model = [self.cardGroup objectAtIndex:i];
//        switch ([model.mana integerValue]) {
//            case 0:
//            {
//                count0 += [model.count integerValue];
//            }
//                break;
//            case 1:
//            {
//                count1 += [model.count integerValue];
//            }
//                break;
//            case 2:
//            {
//                count2 += [model.count integerValue];
//            }
//                break;
//            case 3:
//            {
//                count3 += [model.count integerValue];
//            }
//                break;
//            case 4:
//            {
//                count4 += [model.count integerValue];
//            }
//                break;
//            case 5:
//            {
//                count5 += [model.count integerValue];
//            }
//                break;
//            case 6:
//            {
//                count6 += [model.count integerValue];
//            }
//                break;
//            default:
//            {
//                count7 += [model.count integerValue];
//            }
//                break;
//        }
//    }
//    
//    NSInteger max = count0 > count1?count0 : count1;
//    max = count2 > max?count2 : max;
//    max = count3 > max?count3 : max;
//    max = count4 > max?count4 : max;
//    max = count5 > max?count5 : max;
//    max = count6 > max?count6 : max;
//    max = count7 > max?count7 : max;
//    
//    self.cardCount0 = [NSString stringWithFormat:@"%d",count0];
//    self.cardCount1 = [NSString stringWithFormat:@"%d",count1];
//    self.cardCount2 = [NSString stringWithFormat:@"%d",count2];
//    self.cardCount3 = [NSString stringWithFormat:@"%d",count3];
//    self.cardCount4 = [NSString stringWithFormat:@"%d",count4];
//    self.cardCount5 = [NSString stringWithFormat:@"%d",count5];
//    self.cardCount6 = [NSString stringWithFormat:@"%d",count6];
//    self.cardCount7 = [NSString stringWithFormat:@"%d",count7];
//    
//    return max;
//}

-(NSString*)shareURL
{
    NSString* shareURL = [NSString stringWithFormat:@"http://ls.gm86.com/cardmod/index.html#%d_",[self.cardPro integerValue]];
    
    for (int i=0; i<[self.cardGroup count]; i++) {
        LSHDBModel* model = [self.cardGroup objectAtIndex:i];
        shareURL = [shareURL stringByAppendingString:[NSString stringWithFormat:@"%@:%@,",model.cardid,model.count]];
    }
    
    if ([[shareURL substringFromIndex:shareURL.length-1] isEqualToString:@","]) {
        shareURL = [shareURL substringToIndex:shareURL.length-1];
    }
    
    return shareURL;
}

-(NSData*)codeData
{
    NSData* data = [self.cardPro dataUsingEncoding:NSUTF8StringEncoding];;
//
//    char pro = self.cardPro.length;
//    
////    Byte
//    
//    unsigned int c = "";
//    
//    [data appendBytes:&pro length:sizeof(pro)];
//    
//    NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
//    const char* bytes = [data bytes];
//    
//    char* newByte = NULL;
//    
//    newByte[4] = bytes[4];
    
//    byte[] ret= new byte[2];
//    ret[0] = (byte)((n>>8) & 0x000000ff);
//    ret[1] = (byte)(n & 0x000000ff);
//    
//    Byte[] preByte = new Byte[8];
    
    return data;
}

- (NSString *)ToHex:(uint16_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

@end

