//
//  LSHDBManager.h
//  LuShiHelper
//
//  Created by Brian on 13-11-13.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDefine.h"
#import <sqlite3.h>

@interface LSHDBManager : NSObject
{
    sqlite3 *database;
    NSString* username;
    NSString* password;
    NSString* version;
    NSString* saveflow;
}


+ (LSHDBManager*)getInstance;

- (void)initDB;

//- (void)updateDB:(NSArray*)cards;
//- (NSMutableArray *)getAllCards;
//
//-(void)setUserSetting:(NSString *)key OptionValue:(NSString *) value;
//-(NSString *)getUserSetting:(NSString *) option;


@end



#define DBTable_name @"cardinfo"
#define DBTable_userSetting @"userSetting"

#define DBKey_key @"key"
#define DBKey_value @"value"

#define DBKey_cardid @"cardid"
#define DBKey_cardname @"cardname"
#define DBKey_imgpath @"imgpath"
#define DBKey_imgpathapp @"imgpath_app"
#define DBKey_description @"description"
#define DBKey_options @"options"
#define DBKey_version @"version"
#define DBKey_health @"health"
#define DBKey_mana @"mana"
#define DBKey_attack @"attack"
#define DBKey_profession @"profession"
#define DBKey_type @"type"
#define DBKey_race @"race"
#define DBKey_speSkill @"speSkill"
#define DBKey_rarity @"rarity"
#define DBKey_belongs @"belongs"
#define DBKey_painter @"painter"
#define DBKey_decompose @"decompose"
#define DBKey_compose @"compose"
#define DBKey_collection @"collection"
#define DBKey_useNewPic @"useNewPic"
#define DBKey_canSelect @"useNewPic_app"
#define DBKey_exist @"exist"


