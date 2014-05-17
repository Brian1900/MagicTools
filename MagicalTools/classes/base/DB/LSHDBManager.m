//
//  LSHDBManager.m
//  LuShiHelper
//
//  Created by Brian on 13-11-13.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "LSHDBManager.h"
//#import "LSHDBModel.h"

static LSHDBManager* dbManager = nil;
static NSLock *excutionLock = nil;
@implementation LSHDBManager

+ (LSHDBManager*)getInstance
{
    if (!dbManager) {
        dbManager = [[LSHDBManager alloc] init];
    }
    
    return dbManager;
}

+ (NSLock *)getExcutionLock
{
    if (!excutionLock) {
        excutionLock = [[NSLock alloc] init];
    }
    return excutionLock;
}

#pragma mark - 数据库初始化
- (void)initDB
{
//    @synchronized(self)
//    {
//        int retValue = -1;
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSArray *path1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//        NSString *documentPath = [path1 objectAtIndex:0];
//        NSString *path = [documentPath stringByAppendingPathComponent:dbName];
//        NSBundle *mainBundle = [NSBundle mainBundle];
//        NSString *fromPath = [[mainBundle resourcePath] stringByAppendingPathComponent:dbName];
//        
//        // 文件存在，则打开目录文件
//        if([fileManager fileExistsAtPath:path] == YES)
//        {
//            bool isNew = [self verifyCurrentVersionIsNewSourcePath:path];
//            
//            if(isNew == NO)
//            {
//                //读取旧数据库文件中的部分用户纪录，之后写入新数据库,如果版本为3.4，则从plist中读取用户数据
//                [self CopyDataToCache:path];
//                
//                // 首先 删除旧的文件(不管删除与否，下面拷贝的方法都会执行)
//                [fileManager removeItemAtPath:path error:nil];
//                
//                // 文件不存在，拷贝 文件到 document 下面
//                BOOL bo = [fileManager copyItemAtPath:fromPath toPath:path error:NULL];
//                
//                if(bo)
//                {
//                    sqlite3_shutdown();
//                    retValue = sqlite3_config(SQLITE_CONFIG_MULTITHREAD);
//                    if (retValue != SQLITE_OK) {
//                        //                            TLog(@"Database Config Failed!");
//                    }
//                    sqlite3_initialize();
//                    
//                    sqlite3_open([path UTF8String], &database);
//                    
//                    [self writeCacheToNewDB];
//                }
//            }else
//            {
//                sqlite3_shutdown();
//                retValue = sqlite3_config(SQLITE_CONFIG_MULTITHREAD);
//                if (retValue != SQLITE_OK) {
//                    //                        TLog(@"Database Config Failed!");
//                }
//                sqlite3_initialize();
//                
//                sqlite3_open([path UTF8String], &database);
//            }
//        }else
//        {
//            // 文件不存在，拷贝 文件到 document 下面
//            NSError* error;
//            
//            BOOL bo = [fileManager copyItemAtPath:fromPath toPath:path error:&error];
//            
//            if(bo == true)
//            {
//                sqlite3_shutdown();
//                retValue = sqlite3_config(SQLITE_CONFIG_MULTITHREAD);
//                if (retValue != SQLITE_OK) {
//                    //                        TLog(@"Database Config Failed!");
//                }
//                sqlite3_initialize();
//                
//                sqlite3_open([path UTF8String], &database);
//            }
//        }
//    }
}

- (void)writeCacheToNewDB
{
//    [self setUserSetting:@"saveflow" OptionValue:saveflow];
//    [self setUserSetting:@"username" OptionValue:username];
//    [self setUserSetting:@"password" OptionValue:password];
}

- (void)CopyDataToCache:(NSString*)path
{
    int retValue = -1;
    sqlite3_shutdown();
    retValue = sqlite3_config(SQLITE_CONFIG_MULTITHREAD);
    if (retValue != SQLITE_OK) {
    }
    sqlite3_initialize();
    sqlite3_open([path UTF8String], &database);
    //开启数据库

//    saveflow = [self getUserSetting:@"saveflow"];
//    password = [self getUserSetting:@"password"];
//    username = [self getUserSetting:@"username"];

    //关闭数据库
    sqlite3_close(database);
}

- (BOOL)verifyCurrentVersionIsNewSourcePath:(NSString*)localPath
{
//    return NO;
    
    bool isRight = NO;
    
    sqlite3 *localDatabase = nil;
    
    int error = sqlite3_open([localPath UTF8String], &localDatabase);
    
    if(error != SQLITE_OK)
    {
		sqlite3_close(localDatabase);
	}
    
    // 获取两个数据库中的版本号
    NSString *localVersion = [self getUserSettingWithSqlite3:localDatabase key:@"version"];
    
//    if(localVersion.length > 0 && currentVersion.length > 0 && [localVersion integerValue] >= [currentVersion integerValue])
//    {
//        isRight = YES;
//    }
    
    return isRight;
}

#pragma mark - private method
-(NSString *)getUserSettingWithSqlite3:(sqlite3 *)localDatabase key:(NSString*)key
{
    [[LSHDBManager getExcutionLock] lock];
    
    NSString *optionValue = @"";
    
    sqlite3_stmt *stmt;
    
    NSString * sql = @"SELECT %@ FROM %@ WHERE %@ = '%@'";
    
    sql = [NSString stringWithFormat:sql, DBKey_value,DBTable_userSetting,DBKey_key,key];
    
    int success = sqlite3_prepare_v2(localDatabase, [sql UTF8String], -1, &stmt, NULL);
    
    if (success != SQLITE_OK)
    {
        TLog(@"sql excute fail. sql = [%@]",sql);
    }
    
    // 执行SQL文，并获取结果
  	if (sqlite3_step(stmt) == SQLITE_ROW)
    {
        char* value = (char*)sqlite3_column_text(stmt, 0);
        if(value != NULL)
        {
            optionValue = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
        }
    }
    // 释放资源
    sqlite3_finalize(stmt);
    
    [[LSHDBManager getExcutionLock] unlock];
    
    return optionValue;
}

//#pragma mark - 数据库操作
//-(NSString *)getUserSetting:(NSString *) option
//{
//    [[LSHDBManager getExcutionLock] lock];
//    
//    NSString *optionValue = @"";
//
//    sqlite3_stmt *stmt;
//    
//    NSString * sql = @"SELECT %@ FROM %@ WHERE %@ = '%@'";
//    
//    sql = [NSString stringWithFormat:sql, DBKey_value,DBTable_userSetting,DBKey_key,option];
//    
//    int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
//    
//    if (success != SQLITE_OK)
//    {
//        TLog(@"sql excute fail. sql = [%@]",sql);
//    }
//    
//    // 执行SQL文，并获取结果
//  	if (sqlite3_step(stmt) == SQLITE_ROW)
//    {
//        char* value = (char*)sqlite3_column_text(stmt, 0);
//        if(value != NULL)
//        {
//            optionValue = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
//        }
//    }
//    // 释放资源
//    sqlite3_finalize(stmt);
//    
//    [[LSHDBManager getExcutionLock] unlock];
//    
//    return optionValue;
//}
//
//-(void)setUserSetting:(NSString *)key OptionValue:(NSString *) value
//{
//    [[LSHDBManager getExcutionLock] lock];
//    
//    sqlite3_stmt *stmt;
//    
//    NSString *sql = [NSString stringWithFormat:@" UPDATE %@ SET %@ = '%@' WHERE %@ = '%@' ", DBTable_userSetting, DBKey_value, value, DBKey_key, key];
//    
//    int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
//    
//    if (success != SQLITE_OK)
//    {
//        TLog(@"sql excute fail. sql = [%@]",sql);
//    }
//    
//    sqlite3_step(stmt);
//    
//    // 释放资源
//    sqlite3_finalize(stmt);
//    
//    [[LSHDBManager getExcutionLock] unlock];
//}
//
//- (NSMutableArray *)getAllCards
//{
//    NSMutableArray* cards = [NSMutableArray arrayWithCapacity:1];
//    
//    [[LSHDBManager getExcutionLock] lock];
//    
//    sqlite3_stmt *stmt;
//    
//    NSString * sql = @"SELECT * FROM %@ where %@ = '1' and %@ = '1'";
//    
//    sql = [NSString stringWithFormat:sql, DBTable_name,DBKey_exist,DBKey_canSelect];
//    
//    int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
//    
//    if (success != SQLITE_OK)
//    {
//        TLog(@"sql excute fail. sql = [%@]",sql);
//    }
//
//    // 执行SQL文，并获取结果
//  	while (sqlite3_step(stmt) == SQLITE_ROW)
//    {
//        LSHDBModel* model = [[LSHDBModel alloc] init];
//        model.cardid = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
//        model.cardname = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
//        model.imgpath = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
////        model.imgpath = [NSString stringWithFormat:@"www.gm86.com/%@",model.imgpath];
//        
//        model.description = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 3) encoding:NSUTF8StringEncoding];
//        model.options = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 4) encoding:NSUTF8StringEncoding];
//        
//        model.version = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 5) encoding:NSUTF8StringEncoding];
//        model.health = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 6) encoding:NSUTF8StringEncoding];
//        model.mana = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 7) encoding:NSUTF8StringEncoding];
//        model.attack = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 8) encoding:NSUTF8StringEncoding];
//        model.profession = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 9) encoding:NSUTF8StringEncoding];
//        
//        model.type = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 10) encoding:NSUTF8StringEncoding];
//        model.race = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 11) encoding:NSUTF8StringEncoding];
//        model.rarity = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 12) encoding:NSUTF8StringEncoding];
//        model.belongs = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 13) encoding:NSUTF8StringEncoding];
//        model.painter = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 14) encoding:NSUTF8StringEncoding];
//        
//        model.decompose = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 15) encoding:NSUTF8StringEncoding];
//        model.compose = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 16) encoding:NSUTF8StringEncoding];
//        model.collection = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 17) encoding:NSUTF8StringEncoding];
//        model.useNewPic = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 18) encoding:NSUTF8StringEncoding];
//        model.speSkill = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 19) encoding:NSUTF8StringEncoding];
//        
//        model.imgpath_app = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 20) encoding:NSUTF8StringEncoding];
//        model.canSelect = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 21) encoding:NSUTF8StringEncoding];
//        
////        model.useNewPic = @"1";
//        
//        [cards addObject:model];
//    }
//    
//    // 释放资源
//    sqlite3_finalize(stmt);
//    
//    [[LSHDBManager getExcutionLock] unlock];
//    
//    return cards;
//}
//
//-(LSHDBModel*)getCardDBModelFromCardID:(NSString*)cardID
//{
////    [[LSHDBManager getExcutionLock] lock];
//    
//    LSHDBModel* model = nil;
//    
//    sqlite3_stmt *stmt;
//    
//    NSString * sql = @"SELECT * FROM %@ where %@ = '%@' and %@ = '1'";
//    
//    sql = [NSString stringWithFormat:sql, DBTable_name,DBKey_cardid,cardID,DBKey_exist];
//    
//    int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
//    
//    if (success != SQLITE_OK)
//    {
//        TLog(@"sql excute fail. sql = [%@]",sql);
//    }
//    
//    // 执行SQL文，并获取结果
//  	while (sqlite3_step(stmt) == SQLITE_ROW)
//    {
//        model = [[LSHDBModel alloc] init];
//        model.cardid = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
//        model.cardname = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
//        model.imgpath = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
//        
//        model.description = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 3) encoding:NSUTF8StringEncoding];
//        model.options = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 4) encoding:NSUTF8StringEncoding];
//        
//        model.version = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 5) encoding:NSUTF8StringEncoding];
//        model.health = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 6) encoding:NSUTF8StringEncoding];
//        model.mana = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 7) encoding:NSUTF8StringEncoding];
//        model.attack = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 8) encoding:NSUTF8StringEncoding];
//        model.profession = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 9) encoding:NSUTF8StringEncoding];
//        
//        model.type = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 10) encoding:NSUTF8StringEncoding];
//        model.race = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 11) encoding:NSUTF8StringEncoding];
//        model.rarity = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 12) encoding:NSUTF8StringEncoding];
//        model.belongs = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 13) encoding:NSUTF8StringEncoding];
//        model.painter = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 14) encoding:NSUTF8StringEncoding];
//        
//        model.decompose = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 15) encoding:NSUTF8StringEncoding];
//        model.compose = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 16) encoding:NSUTF8StringEncoding];
//        model.collection = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 17) encoding:NSUTF8StringEncoding];
//        model.useNewPic = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 18) encoding:NSUTF8StringEncoding];
//        model.speSkill = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 19) encoding:NSUTF8StringEncoding];
//        
//        model.imgpath_app = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 20) encoding:NSUTF8StringEncoding];
//        model.canSelect = [NSString stringWithCString:(char*)sqlite3_column_text(stmt, 21) encoding:NSUTF8StringEncoding];
//    }
//    
//    // 释放资源
//    sqlite3_finalize(stmt);
//    
////    [[LSHDBManager getExcutionLock] unlock];
//    
//    return model;
//}
//
//- (BOOL)isCardExist:(NSString*)cardid
//{
//    BOOL cardExist = NO;
//    
//    sqlite3_stmt *stmt;
//    
//    NSString * sql = @"SELECT * FROM %@ where %@ = '%@' and %@ = '1'";
//    
//    sql = [NSString stringWithFormat:sql, DBTable_name,DBKey_cardid,cardid,DBKey_exist];
//    
//    int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
//    
//    if (success != SQLITE_OK)
//    {
//        TLog(@"sql excute fail. sql = [%@]",sql);
//    }
//    
//    // 执行SQL文，并获取结果
//    if (sqlite3_step(stmt) == SQLITE_ROW)
//    {
//        cardExist = YES;
//    }
//    
//    // 释放资源
//    sqlite3_finalize(stmt);
//    
//    return cardExist;
//}
//
//- (void)updateCard:(LSHDBModel*)card
//{
//    LSHDBModel* oldModel = [self getCardDBModelFromCardID:card.cardid];
//    
//    if (![card.imgpath isEqualToString:oldModel.imgpath] || ![card.imgpath_app isEqualToString:oldModel.imgpath_app]) {
//        card.useNewPic = @"1";
//    }
//    
//    sqlite3_stmt *stmt;
//    
//    NSString * sql = @"update %@ set %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' , %@ = '%@' where %@ = '%@'";
//    
//    sql = [NSString stringWithFormat:sql, DBTable_name,DBKey_cardname,card.cardname,DBKey_imgpath,card.imgpath,DBKey_description,card.description,DBKey_options,card.options,DBKey_version,card.version,DBKey_health,card.health,DBKey_mana,card.mana,DBKey_attack,card.attack,DBKey_profession,card.profession,DBKey_type,card.type,DBKey_rarity,card.rarity,DBKey_belongs,card.belongs,DBKey_painter,card.painter,DBKey_decompose,card.decompose,DBKey_useNewPic,card.useNewPic,DBKey_compose,card.compose,DBKey_collection,card.collection,DBKey_race,card.race,DBKey_speSkill,card.speSkill,DBKey_imgpathapp,card.imgpath_app,DBKey_canSelect,card.canSelect,DBKey_exist,card.exist,DBKey_cardid,card.cardid];
//    
//    int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
//    
//    if (success != SQLITE_OK)
//    {
//        TLog(@"sql excute fail. sql = [%@]",sql);
//    }else{
//        TLog(@"sql excute success. sql = [%@]",sql);
//    }
//    
//    // 执行SQL文，并获取结果
//    sqlite3_step(stmt);
//    
//    // 释放资源
//    sqlite3_finalize(stmt);
//}
//
//- (void)insertCard:(LSHDBModel*)card
//{
//    sqlite3_stmt *stmt;
//    
//    NSString * sql = @"insert into %@ ( %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ , %@) values ( '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@')";
//    
//    sql = [NSString stringWithFormat:sql, DBTable_name,DBKey_cardid,DBKey_cardname,DBKey_imgpath,DBKey_description,DBKey_options,DBKey_version,DBKey_health,DBKey_mana,DBKey_attack,DBKey_profession,DBKey_type,DBKey_rarity,DBKey_belongs,DBKey_painter,DBKey_decompose,DBKey_useNewPic,DBKey_compose,DBKey_collection,DBKey_race,DBKey_speSkill,DBKey_imgpathapp,DBKey_canSelect,DBKey_exist,card.cardid,card.cardname,card.imgpath,card.description,card.options,card.version,card.health,card.mana,card.attack,card.profession,card.type,card.rarity,card.belongs,card.painter,card.decompose,card.useNewPic,card.compose,card.collection,card.race,card.speSkill,card.imgpath_app,card.canSelect,card.exist];
//    
//    int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
//    
//    if (success != SQLITE_OK)
//    {
//        TLog(@"sql excute fail. sql = [%@]",sql);
//    }else{
//        TLog(@"sql excute success. sql = [%@]",sql);
//    }
//    
//    // 执行SQL文，并获取结果
//    sqlite3_step(stmt);
//        
//        // 释放资源
//    sqlite3_finalize(stmt);
//}
//
//- (void)updateDB:(NSArray*)cards
//{
//    NSInteger DBVersion = [[self getUserSetting:@"version"] integerValue];
//    
//    [[LSHDBManager getExcutionLock] lock];
//    
//    for (int i=0; i<[cards count]; i++) {
//        LSHDBModel* card = [cards objectAtIndex:i];
//        
//        if ([card.version integerValue] > DBVersion) {
//            DBVersion = [card.version integerValue];
//        }
//        
//        if ([self isCardExist:card.cardid]) {
//            [self updateCard:card];
//        }else{
//            [self insertCard:card];
//        }
//    }
//    
//    [[LSHDBManager getExcutionLock] unlock];
//    
//    [self setUserSetting:@"version" OptionValue:[NSString stringWithFormat:@"%d",DBVersion]];
//}



@end
