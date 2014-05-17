//
//  CTSerializeObject.h
//  TestSerializer
//
//  Created by 陆文杰 on 12-11-22.
//  Copyright (c) 2012年 Brian. All rights reserved.
//

#import <Foundation/Foundation.h>

//序列化和反序列化

enum{
    Type_Bool = 0,
    Type_Integer = 1,
    Type_Double = 2
}TypeOfProperty;

@interface CTSerializeObject : NSObject
{
    NSInteger jsonLevel;        //缩进，初始为－1
    NSInteger jsonIndex;        //凡序列化时，扫瞄的index
    NSStringEncoding encoding;  //编码格式
}

@property (nonatomic,retain) NSMutableString* objectString;//序列化得到的json字符串
@property (nonatomic,retain) id jsonObject;//反序列化后得到的对象实例

//单例
+ (CTSerializeObject*) getInstance;

//序列化
- (NSMutableString*) serialize:(id) object;
- (NSMutableString*) serialize:(id) object name:(NSString*) name type:(int) type;

//反序列化
- (NSArray*) deSerializeArray:(NSMutableString*) jsonString classType:(Class)classType hasKey:(BOOL)hasKey;
- (id) deSerialize:(NSMutableString*) jsonString classType:(Class)classType hasKey:(BOOL)hasKey;
- (id) deSerialize:(NSMutableString*) jsonString type:(int)type;

@end