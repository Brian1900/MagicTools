//
//  CTSerializeObject.m
//  TestSerializer
//
//  Created by 陆文杰 on 12-11-22.
//  Copyright (c) 2012年 Brian. All rights reserved.
//

#import "CTSerializeObject.h"
#import <objc/runtime.h>
#import "BaseDefine.h"

static CTSerializeObject * ser = nil;

@implementation CTSerializeObject

@synthesize jsonObject;
@synthesize objectString;

#pragma mark - 系统方法

- (id)init
{
    self = [super init];
    
    if (self) {
        objectString = [[NSMutableString alloc] initWithCapacity:1];
        [objectString appendString:@"\n"];
        jsonLevel = -1;
    }
    return self;
}

- (void)dealloc
{
    jsonObject = nil;
    objectString = nil;
}

- (void)clean
{
    [objectString setString:@""];
    jsonLevel = -1;
    jsonIndex = 0;
    jsonObject = nil;
}

#pragma mark - 单例模式
+ (CTSerializeObject*) getInstance
{
    if (ser == nil) {
        ser = [[super alloc] init];
    }
    return ser;
}

//#pragma mark - 文件存取
//- (NSString*)getPath
//{
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
//    
//    return path;
//}

#pragma mark - 序列化相关-私有方法

//加入json缩进
- (void) fillWithBlank
{
    for (NSInteger i = 0; i<jsonLevel; i++) {
        [objectString appendString:@"    "];
    }
}

//class序列化
- (void) parseClass:(id)object nameOfObject:(NSString*)name isLast:(BOOL)last neesClassName:(BOOL)needName isArray:(BOOL)isArray
{
    jsonLevel++;
    
    //解析object开始
    
    NSString *className = NSStringFromClass([object class]);
    
    if (!className) {//int bool double
        
        return ;
    }
    
    if ([className compare:@"__NSCFString"] == NSOrderedSame || [className compare:@"__NSCFConstantString"] == NSOrderedSame) {//字符串要特殊处理
        className = @"NSMutableString";
        
        jsonLevel--;
        
        [self parseString:className Value:object isLast:last];
        return;
    }
    
    if ([className compare:@"__NSArrayM"] == NSOrderedSame || [className compare:@"__NSArrayI"] == NSOrderedSame) {//字符串要特殊处理
        className = @"NSMutableArray";
        
        jsonLevel--;
        
        [self parseArray:className Value:object isLast:last];
        return;
    }
    
//    if ([className compare:@"NSConcreteData"] == NSOrderedSame || [className compare:@"NSConcreteMutableData"] == NSOrderedSame) {//字符串要特殊处理
//        className = @"NSMutableData";
//        
//        jsonLevel--;
    
//        [self parseData:className Value:object isLast:last isArray:NO];
//        return;
//    }
    
    if(!isArray){//非标准json格式，添加对象的类名和字段名
        [self fillWithBlank];
        if (name) {
            [objectString appendFormat:@"\"%@\":\n",name];
        }
    }else{
        [self fillWithBlank];
        [objectString appendFormat:@"\"%@\":\n",className];//修改
    }
    
    [self fillWithBlank];
    [objectString appendFormat:@"{\n"];
    
    const char *cClassName = [className UTF8String];
    
    id theClass = objc_getClass(cClassName);
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList(theClass, &outCount);
    
    NSMutableArray *propertyNames = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *propertyNameString = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        [propertyNames addObject:propertyNameString];
        
        SEL selector = NSSelectorFromString(propertyNameString);
        
//        SEL selector = NSSelectorFromString(propertyNameString);
//        id value = [object performSelector:selector];
//        
//        if (value == nil)
//        {
//            value = [NSNull null];
//        }
        
        NSString* type = [NSString stringWithFormat:@"%s",property_getAttributes(property)];
        
#ifdef BUG_LOG
        TLog(@"CTSerializeObject %@",type);
#endif
        
        if ([type rangeOfString:@"NSString"].length != 0) {
            id value = [object performSelector:selector];
            [self parseString:propertyNameString Value:value isLast:i==outCount-1];
        }
//        else if([type rangeOfString:@"NSMutableData"].length != 0 || [type rangeOfString:@"NSData"].length != 0){
//            [self parseData:propertyNameString Value:value isLast:i==outCount-1 isArray:isArray];
//        }
        else if([[[type substringToIndex:2] lowercaseString] compare:@"ti"] == NSOrderedSame){
            NSInteger intValue = (NSInteger)[object performSelector:selector];
            
            [self parseInteger:propertyNameString Value:intValue isLast:i==outCount-1];
        }
        else if([[[type substringToIndex:2] lowercaseString] compare:@"td"] == NSOrderedSame){
            NSNumber *doubleValue = [object valueForKey:propertyNameString];
            
            [self parseDouble:propertyNameString Value:[doubleValue doubleValue] isLast:i==outCount-1];
        }
        else if([type rangeOfString:@"NSArray"].length != 0 || [type rangeOfString:@"NSMutableArray"].length != 0)
        {
            id value = [object performSelector:selector];

            [self parseArray:propertyNameString Value:value isLast:i==outCount-1];
        }
        else if([type rangeOfString:@"NSDictionary"].length != 0 || [type rangeOfString:@"NSMutableDictionary"].length != 0)
        {
            id value = [object performSelector:selector];
            
            [self parseDicionary:propertyNameString Value:value isLast:i==outCount-1];
        }
        else if ([[[type substringToIndex:2] lowercaseString] compare:@"tc"] == NSOrderedSame)
        {
            BOOL s = (BOOL)[object performSelector:selector];
            
            [self parseBool:propertyNameString Value:s isLast:i==outCount-1];
        }
        else{
            id value = [object performSelector:selector];
            [self parseClass:value nameOfObject:propertyNameString isLast:i==outCount-1 neesClassName:YES isArray:NO];
        }
        
    }
    free(properties); //yubo
    
    [self fillWithBlank];
    
    if (last) {
        [objectString appendFormat:@"}\n"];
    }
    else{
        [objectString appendFormat:@"},\n"];
    }
    
    jsonLevel--;
}

//对象序列化
- (void) parseObject:(id)object nameOfObject:(NSString*)name isLast:(BOOL)last neesClassName:(BOOL)needName isArray:(BOOL)isArray
{
    jsonLevel++;
    
    //解析object开始
    
    NSString *className = NSStringFromClass([object class]);
    
    if ([className compare:@"__NSCFString"] == NSOrderedSame || [className compare:@"__NSCFConstantString"] == NSOrderedSame) {//字符串要特殊处理
        className = @"";// = @"NSMutableString";
        
        jsonLevel--;
        
        [self parseString:className Value:object isLast:last];
        return;
    }
    
//    if ([className compare:@"NSConcreteData"] == NSOrderedSame || [className compare:@"NSConcreteMutableData"] == NSOrderedSame) {//字符串要特殊处理
//        className = @"NSMutableData";
//        
//        jsonLevel--;
//        
//        [self parseData:className Value:object isLast:last isArray:isArray];
//        return;
//    }
    
    if(!isArray){//非标准json格式，添加对象的类名和字段名
        [self fillWithBlank];
        [objectString appendFormat:@"%@:\n",name];
    }else{
        [self fillWithBlank];
        [objectString appendFormat:@"%@:\n",className];//修改
    }
    
    [self fillWithBlank];
    [objectString appendFormat:@"{\n"];
    
    const char *cClassName = [className UTF8String];
    
    id theClass = objc_getClass(cClassName);
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList(theClass, &outCount);
    
    NSMutableArray *propertyNames = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *propertyNameString = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        [propertyNames addObject:propertyNameString];
        
        SEL selector = NSSelectorFromString(propertyNameString);
        id value = [object performSelector:selector];
        
        if (value == nil)
        {
            value = [NSNull null];
        }
        
        NSString* type = [NSString stringWithFormat:@"%s",property_getAttributes(property)];
        
#ifdef BUG_LOG
        TLog(@"CTSerializeObject %@",type);
#endif
        
        if ([type rangeOfString:@"NSString"].length != 0) {
            [self parseString:propertyNameString Value:value isLast:i==outCount-1];
        }
        else if([[[type substringToIndex:2] lowercaseString] compare:@"ti"] == NSOrderedSame){
            NSInteger intValue = (NSInteger)[object performSelector:selector];
            
            [self parseInteger:propertyNameString Value:intValue isLast:i==outCount-1];
        }
        else if([[[type substringToIndex:2] lowercaseString] compare:@"td"] == NSOrderedSame){
            NSNumber *doubleValue = [object valueForKey:propertyNameString];
            
            [self parseDouble:propertyNameString Value:[doubleValue doubleValue] isLast:i==outCount-1];
        }
        else if([type rangeOfString:@"NSArray"].length != 0 || [type rangeOfString:@"NSMutableArray"].length != 0)
        {
            [self parseArray:propertyNameString Value:value isLast:i==outCount-1];
        }
        else if ([[[type substringToIndex:2] lowercaseString] compare:@"tc"] == NSOrderedSame)
        {
            BOOL s = (BOOL)[object performSelector:selector];
            
            [self parseBool:propertyNameString Value:s isLast:i==outCount-1];
        }
        else{
            jsonLevel--;
            [self parseClass:value nameOfObject:propertyNameString isLast:i==outCount-1 neesClassName:YES isArray:NO];
            jsonLevel++;
        }
        
    }
    free(properties); //yubo
    
    [self fillWithBlank];
    
    if (last) {
        [objectString appendFormat:@"}\n"];
    }
    else{
        [objectString appendFormat:@"},\n"];
    }
    
    jsonLevel--;
}

//data序列化
//- (void) parseData:(NSString*)key Value:(NSData*)data isLast:(BOOL)last isArray:(BOOL)isArray
//{
//    jsonLevel++;
//    
//    [self fillWithBlank];
//    
//    NSString* string = [[NSString alloc] initWithData:data encoding:encoding];
//    
//    if(last){
//        if (isArray) {
//            [objectString appendFormat:@"NSMutableData-%@:\"%@\"\n",key,string];
//        }else{
//            [objectString appendFormat:@"NSMutableData-%@:\"%@\"\n",key,string];
//        }
//    }
//    else{
//        if (isArray) {
//            [objectString appendFormat:@"NSMutableData-%@:\"%@\",\n",key,string];
//        }else{
//            [objectString appendFormat:@"NSMutableData-%@:\"%@\",\n",key,string];
//        }
//    }
//    
//    [string release];
//    
//    jsonLevel--;
//}

//array序列化
- (void) parseDicionary:(NSString*)key Value:(NSDictionary*)dic isLast:(BOOL)last
{
    jsonLevel++;
    
    [self fillWithBlank];
    [objectString appendFormat:@"\"%@\":\n",key];
    
    [self fillWithBlank];
    [objectString appendFormat:@"[\n"];
    
    if ([dic isKindOfClass:[NSNull class]]) {
        [self fillWithBlank];
        [objectString appendFormat:@"NULL\n"];
    }
    else{
        NSArray* keys = [dic allKeys];
        for (int i=0; i<[keys count]; i++) {
            jsonLevel++;
            
            [self fillWithBlank];
            [objectString appendFormat:@"{\n"];
            
            NSString* key = [keys objectAtIndex:i];
            NSString* value = [dic objectForKey:key];
            
            jsonLevel++;
            
            [self fillWithBlank];
            [objectString appendFormat:@"\"%@\":\"%@\"\n",key,value];
            
            jsonLevel--;
            
            [self fillWithBlank];
            if (i + 1<[keys count]) {
                [objectString appendFormat:@"},\n"];
            }else{
                [objectString appendFormat:@"}\n"];
            }
            
            jsonLevel--;
        }
    }
    
    [self fillWithBlank];
    
    if (last) {
        [objectString appendFormat:@"]\n"];
    }
    else{
        [objectString appendFormat:@"],\n"];
    }
    
    jsonLevel--;
}

//array序列化
- (void) parseArray:(NSString*)key Value:(NSArray*)array isLast:(BOOL)last
{
    jsonLevel++;
    
    [self fillWithBlank];
    [objectString appendFormat:@"\"%@\":\n",key];
    
    [self fillWithBlank];
    [objectString appendFormat:@"[\n"];
    
    if ([array isKindOfClass:[NSNull class]]) {
        [self fillWithBlank];
        [objectString appendFormat:@"NULL\n"];
    }
    else{
        for (int i=0; i<[array count]; i++) {
            id item = [array objectAtIndex:i];
            [self parseObject:item nameOfObject:key isLast:i==[array count]-1 neesClassName:NO isArray:YES];
        }
    }
    
    [self fillWithBlank];
    
    if (last) {
        [objectString appendFormat:@"]\n"];
    }
    else{
        [objectString appendFormat:@"],\n"];
    }
    
    jsonLevel--;
}

//string序列化
- (void) parseString:(NSString*)key Value:(NSString*)value isLast:(BOOL)last
{
    jsonLevel++;
    
    [self fillWithBlank];
    
    if(last){
        if (key.length > 0) {
            [objectString appendFormat:@"\"%@\":\"%@\"\n",key,value];
        }else{
            [objectString appendFormat:@"\"%@\"\n",value];
        }
    }
    else{
        if (key.length > 0) {
            [objectString appendFormat:@"\"%@\":\"%@\",\n",key,value];
        }else{
            [objectString appendFormat:@"\"%@\",\n",value];
        }
    }
    
    jsonLevel--;
}

//double序列化
- (void) parseDouble:(NSString*)key Value:(double)value isLast:(BOOL)last
{
    jsonLevel++;
    
    [self fillWithBlank];
    
    if (last) {
        [objectString appendFormat:@"\"%@\":%f\n",key,value];
    }
    else{
        [objectString appendFormat:@"\"%@\":%f,\n",key,value];
    }
    
    jsonLevel--;
}

//int序列化
- (void) parseInteger:(NSString*)key Value:(NSInteger)value isLast:(BOOL)last
{
    jsonLevel++;
    
    [self fillWithBlank];
    
    if (last) {
        if (key.length > 0) {
            [objectString appendFormat:@"\"%@\":%d\n",key,value];
        }else{
            [objectString appendFormat:@"%d\n",value];
        }
        
    }
    else{
        if (key.length > 0) {
            [objectString appendFormat:@"\"%@\":%d,\n",key,value];
        }else{
            [objectString appendFormat:@"%d,\n",value];
        }
    }
    
    jsonLevel--;
}

//bool序列化
- (void) parseBool:(NSString*)key Value:(BOOL)value isLast:(BOOL)last
{
    jsonLevel++;
    
    [self fillWithBlank];
    
    NSString* valueString = @"true";
    if (!value) {
        valueString = @"false";
    }
    
    if (last) {
        if (key.length > 0) {
            [objectString appendFormat:@"\"%@\":%@\n",key,valueString];
        }else{
            [objectString appendFormat:@"%@\n",valueString];
        }
    }
    else{
        if (key.length > 0) {
            [objectString appendFormat:@"\"%@\":%@,\n",key,valueString];
        }else{
            [objectString appendFormat:@"%@\n",valueString];
        }
        
    }
    
    jsonLevel--;
}

#pragma mark - 序列化相关-公有方法

//实例化接口
//object 需要序列化的对象
//arg1 id 需要序列化的对象
//return 如果为@""表示序列化失败
- (NSMutableString*) serialize:(id)object
{
    NSMutableString* jsonString = nil;
    
#ifdef BUG_LOG
    TLog(@"serialize start %@",NSStringFromClass([object class]));
#endif
    @synchronized(self) {
        @try {
            [self clean];
            
            [objectString setString:@""];
            
            [self parseClass:object nameOfObject:nil isLast:YES neesClassName:NO isArray:NO];
            
            jsonString = [objectString mutableCopy];
        }
        @catch (NSException *exception) {
            TLog(@"CTSerializeObject %@",exception);
            [objectString setString:@""];
        }
        @finally {
            
        }
    }
#ifdef BUG_LOG
    TLog(@"serialize end %@",NSStringFromClass([object class]));
#endif
    return jsonString;
}

#pragma mark - 序列化基本数据类型 bool int double

//凡序列化接口
//jsonString 需要反序列化的符合规则的字符串
//arg1 id 需要序列化的对象
//arg2 name 字段名
//arg3 type 0 bool 1 int 2 double
//return 序列化的结果
- (NSMutableString*) serialize:(id)object name:(NSString*)name type:(int)type
{
    NSMutableString* serString = @"";
    
    @synchronized(self) {
        [self clean];
        
        [objectString setString:@""];
        
        jsonLevel++;
        switch (type) {
            case 0:
            {
                [self fillWithBlank];
                bool value = [object performSelector:NSSelectorFromString(name)];
                if (value) {
                    [objectString appendString:@"true"];
                }
                else{
                    [objectString appendString:@"false"];
                }
            }
                break;
            case 1:
            {
                [self fillWithBlank];
                NSInteger value = (NSInteger)[object performSelector:NSSelectorFromString(name)];
                [objectString appendFormat:@"%d",value];
            }
                break;
            case 2:
            {
                [self fillWithBlank];
                NSNumber* number = [object valueForKey:name];
                [objectString appendFormat:@"%f",[number doubleValue]];
            }
                break;
            default:
                break;
        }
        jsonLevel--;
        
        serString = [objectString mutableCopy];
        
    }
    
    return serString;
}

#pragma mark - 反序列化基本数据类型 bool int double

//凡序列化接口
//jsonString 需要反序列化的符合规则的字符串
//arg1 jsonString 反序列化的字符串
//arg2 type 0 bool 1 int 2 double
//return 反序列化的结果
- (id) deSerialize:(NSMutableString*) jsonString type:(int)type
{
    id objectDeser = nil;
    
    @synchronized(self) {
        [self clean];
        
        [self deleteAllBlank:jsonString];
        
        switch (type) {
            case 0:
            {
                jsonObject = nil;
                if ([[jsonString lowercaseString] compare:@"true"] == NSOrderedSame) {
                    jsonObject = [NSNumber numberWithBool:YES];
                }
                else{
                    jsonObject = (id)NO;
                }
            }
                break;
            case 1:
            {
                jsonObject = nil;
                jsonObject = [NSNumber numberWithInteger:[jsonString integerValue]];
            }
                break;
            case 2:
            {
                self.jsonObject = [NSNumber numberWithDouble:[jsonString doubleValue]];
            }
                break;
            default:
                break;
        }
        
        objectDeser = [self.jsonObject copy];
    }
    return objectDeser;
}

#pragma mark - 反序列化相关-公有方法

- (NSArray*) deSerializeArray:(NSMutableString*) jsonString classType:(Class)classType  hasKey:(BOOL)hasKey
{
    NSArray* array = nil;
    
#ifdef BUG_LOG
    TLog(@"deSerialize start");
#endif
    @synchronized(self) {
        @try {
            [self clean];
            
            [self deleteAllBlank:jsonString];
            
            jsonIndex++;
            
            array = [self inductArray:jsonString object:(Class)classType hasKey:hasKey];
        }
        @catch (NSException *exception) {
            TLog(@"CTSerializeObject %@",exception);
            self.jsonObject = nil;
            array = nil;
        }
        @finally {
            
        }
    }
#ifdef BUG_LOG
    TLog(@"deSerialize end");
#endif
    return array;
}

//凡序列化接口
//jsonString 需要反序列化的符合规则的字符串
//arg1 NSMutableString 需要反序列化的字符串
//return 如果为nil表示反序列化失败 且可能会有一定的内存泄漏
- (id) deSerialize:(NSMutableString*) jsonString classType:(Class)classType hasKey:(BOOL)hasKey
{
    id objectDeser = nil;
    
#ifdef BUG_LOG
    TLog(@"deSerialize start");
#endif
    @synchronized(self) {
        @try {
            [self clean];
            
            [self deleteAllBlank:jsonString];
            
            [self inductObject:jsonString className:nil typeOfClass:classType hasKey:hasKey];
            
            objectDeser = [self.jsonObject copy];
        }
        @catch (NSException *exception) {
            TLog(@"CTSerializeObject %@",exception);
            self.jsonObject = nil;
        }
        @finally {
            
        }
    }
#ifdef BUG_LOG
    TLog(@"deSerialize end");
#endif
    return objectDeser;
}

#pragma mark - 反序列化相关-私有方法

//删除缩进和换行
- (void) deleteAllBlank:(NSMutableString*) jsonString
{
    [jsonString replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [jsonString length])];
    
    [jsonString replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [jsonString length])];
    
    [jsonString replaceOccurrencesOfString:@"\r" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [jsonString length])];
    
    [jsonString replaceOccurrencesOfString:@"\t" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [jsonString length])];
}

//调用相关set方法 setKey:value
- (void) performMethod:(id)class key:(NSString*)key value:(id)value
{
    if ([[key substringToIndex:1] isEqualToString:@"\""]) {//key 多了引号的容错
        key = [key substringFromIndex:1];
    }
    if ([[key substringFromIndex:key.length-1] isEqualToString:@"\""]) {
        key = [key substringToIndex:key.length-1];
    }
    
    NSString* string = [key substringWithRange:NSMakeRange(1, [key length]-1)];
    
    NSString* cap = [[key substringToIndex:1] uppercaseString];
    string = [NSString stringWithFormat:@"set%@%@:",cap,string];
    
    SEL selector = NSSelectorFromString(string);
    if ([class respondsToSelector:selector]) {
        [class performSelector:selector withObject:value];
    }
}

////调用相关set方法 setKey:value
- (void) performMethodBasicData:(id)class key:(NSString*)key value:(NSNumber*)value
{
    if ([[key substringToIndex:1] isEqualToString:@"\""]) {
        key = [key substringFromIndex:1];
    }
    if ([[key substringFromIndex:key.length-1] isEqualToString:@"\""]) {
        key = [key substringToIndex:key.length-1];
    }
    
    //    NSString* string = [key substringWithRange:NSMakeRange(1, [key length]-1)];
    //
    //    NSString* cap = [[key substringToIndex:1] uppercaseString];
    //    string = [NSString stringWithFormat:@"set%@%@:",cap,string];
    //
    [class setValue:value forKey:key];
}

//反序列化string
- (NSString*) inductString:(NSMutableString*)jsonString
{
    NSRange range = [[jsonString substringFromIndex:jsonIndex] rangeOfString:@"\""];
    
    int length = 1;
    
    NSString* s = [jsonString substringWithRange:NSMakeRange(range.location + jsonIndex + length, 1)];
    BOOL needStop = [s isEqualToString:@"}"] || [s isEqualToString:@","] || [s isEqualToString:@"]"] || [s compare:@" "]==NSOrderedSame || [s compare:@"\r"]==NSOrderedSame || [s compare:@"\n"]==NSOrderedSame;
    while (!needStop) {
        NSRange rangeTemp = [[jsonString substringFromIndex:jsonIndex + range.location+ + length] rangeOfString:@"\""];
        range = NSMakeRange(range.location + rangeTemp.location + length, 1);
        s = [jsonString substringWithRange:NSMakeRange(range.location + jsonIndex + length, 1)];
        needStop = [s isEqualToString:@"}"] || [s isEqualToString:@","] || [s isEqualToString:@"]"] || [s compare:@" "]==NSOrderedSame || [s compare:@"\r"]==NSOrderedSame || [s compare:@"\n"]==NSOrderedSame;
    }
    
    NSString* string = [jsonString substringWithRange:NSMakeRange(jsonIndex, range.location)];
    
    jsonIndex += range.location+1;
    
    return string;
}

//反序列化bool
- (BOOL) inductBOOL:(NSMutableString*)jsonString
{
    NSString* s = [jsonString substringWithRange:NSMakeRange(jsonIndex, 1)];
    
    if ([[s lowercaseString] compare:@"t"] == NSOrderedSame) {
        jsonIndex+=4;
        return YES;
    }
    else if([[s lowercaseString] compare:@"f"] == NSOrderedSame){
        jsonIndex+=5;
        return NO;
    }
    
    return NO;
}

//凡序列化double
- (double) inductDouble:(NSMutableString*)jsonString
{
    int Integerlength = 0;
    double value = 0;
    
    while (YES) {
        NSString* s = [jsonString substringWithRange:NSMakeRange(jsonIndex, 1)];
        
        if([s compare:@"}"]==NSOrderedSame || [s compare:@"]"]==NSOrderedSame || [s compare:@","]==NSOrderedSame || [s compare:@" "]==NSOrderedSame || [s compare:@"\r"]==NSOrderedSame || [s compare:@"\n"]==NSOrderedSame)
        {
            jsonIndex--;
            Integerlength--;
            break;
        }
        
        jsonIndex++;
        Integerlength++;
    }
    
    value = [[jsonString substringWithRange:NSMakeRange(jsonIndex-Integerlength, Integerlength+1)] doubleValue];
    
    return value;
}

//凡序列化int
- (NSInteger) inductInteger:(NSMutableString*)jsonString
{
    int Integerlength = 0;
    NSInteger value = 0;
    
    while (YES) {
        NSString* s = [jsonString substringWithRange:NSMakeRange(jsonIndex, 1)];
        
        if([s compare:@"}"]==NSOrderedSame || [s compare:@"]"]==NSOrderedSame || [s compare:@","]==NSOrderedSame || [s compare:@" "]==NSOrderedSame || [s compare:@"\r"]==NSOrderedSame || [s compare:@"\n"]==NSOrderedSame)
        {
            jsonIndex--;
            Integerlength--;
            break;
        }
        
        jsonIndex++;
        Integerlength++;
    }
    
    value = [[jsonString substringWithRange:NSMakeRange(jsonIndex-Integerlength, Integerlength+1)] integerValue];
    
    return value;
}

//反序列化对象
- (id) inductClass:(NSMutableString*)jsonString className:(NSString*)className hasKey:(BOOL)hasKey
{
    Class class = NSClassFromString(className);
    id object = [[class alloc] init];
    
    [self inductObject:jsonString className:object typeOfClass:class hasKey:hasKey];
    
    return object;
}

//反序列化dictionary 都以NSMutableDictionary返回
- (NSMutableDictionary*) inductDictionary:(NSMutableString*)jsonString
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    BOOL keyOver = NO;
    BOOL valueStart = NO;
    int keyIndexStart = -1;
    
    NSInteger nullIndex = 0;
    
    NSString* key = @"";
    
    while (YES) {
        if (jsonIndex == [jsonString length]) {
            break;
        }
        
        NSString* s = [jsonString substringWithRange:NSMakeRange(jsonIndex, 1)];
        
        jsonIndex++;
        
        if ([s isEqualToString:@","]) {
            continue;
        }
        
        if ([s rangeOfString:@"]"].length != 0) {
            break;
        }
        
        if (!keyOver) {
            if (keyIndexStart == -1) {
                
                if ([s isEqualToString:@" "]) {
                    continue;
                }
                
                if ([s isEqualToString:@"\n"]) {
                    continue;
                }
                
                if ([s isEqualToString:@"\r"]) {
                    continue;
                }
                
                if ([s isEqualToString:@"\t"]) {
                    continue;
                }
                
                if ([s isEqualToString:@"{"]) {
                    continue;
                }
                
                if ([s isEqualToString:@"}"]) {
                    continue;
                }
                
                if ([s isEqualToString:@","]) {
                    continue;
                }
                
                keyIndexStart = jsonIndex-1;
            }
            
            if ([s compare:@":"] == NSOrderedSame) {
                key = [jsonString substringWithRange:NSMakeRange(keyIndexStart, jsonIndex - keyIndexStart-1)];
                keyIndexStart = -1;
                keyOver = YES;
                
                valueStart = YES;
            }
        }
        else if (valueStart){
            if ([s isEqualToString:@","]) {
                continue;
            }
            
            if ([s isEqualToString:@"\n"]) {
                continue;
            }
            
            if ([s isEqualToString:@"\r"]) {
                continue;
            }
            
            if ([s isEqualToString:@"\t"]) {
                continue;
            }
            
            if ([s isEqualToString:@" "]) {
                continue;
            }
            
            if ([s isEqualToString:@"n"] || [s isEqualToString:@"N"]) {
                nullIndex = jsonIndex-1;
                continue;
            }
            
            if ([s isEqualToString:@","] || [s isEqualToString:@"\n"] || [s isEqualToString:@"\r"] || [s isEqualToString:@"\t"] || [s isEqualToString:@" "] || [s isEqualToString:@"}"]) {
                NSString* nullString = [jsonString substringWithRange:NSMakeRange(nullIndex, jsonIndex - nullIndex-1)];
                if ([nullString isEqualToString:@"null"]) {
                    return dic;
                }
            }
            
            if ([s compare:@"\""] == NSOrderedSame) {//键值对
                if ([[key substringToIndex:1] isEqualToString:@"\""]) {
                    key = [key substringFromIndex:1];
                }
                if ([[key substringFromIndex:key.length-1] isEqualToString:@"\""]) {
                    key = [key substringToIndex:key.length-1];
                }
                
                NSString* value = [self inductString:jsonString];
                
                [dic setObject:value forKey:key];
            }
            
            keyOver = NO;
            valueStart = NO;
        }
    }
    
    return dic;
}

//反序列化array 都以NSMutableArray返回
- (NSMutableArray*) inductArray:(NSMutableString*)jsonString object:(Class)classType hasKey:(BOOL)hasKey
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:1];
    
    [self inductObject:jsonString array:array object:(Class)classType hasKey:hasKey];
    
    return array;
}

//反序列化对象 该对象是array的内容
- (void) inductObject:(NSMutableString*)jsonString array:(NSMutableArray*)array object:(Class)classObject hasKey:(BOOL)hasKey
{
    BOOL keyOver = YES;
    BOOL valueStart = YES;
    int keyIndexStart = -1;
    
    if (hasKey) {
        keyOver = NO;
        valueStart = NO;
    }
    
    NSString* classType;
    NSString* className;
    
    while (YES) {
        if (jsonIndex == [jsonString length]) {
            break;
        }
        
        NSString* s = [jsonString substringWithRange:NSMakeRange(jsonIndex, 1)];
        
        jsonIndex++;
        
        if ([s isEqualToString:@","]) {
            continue;
        }
        
        if ([s rangeOfString:@"]"].length != 0) {
            return ;
        }
        
        if (!keyOver) {
            if (keyIndexStart == -1) {
                
                if ([s isEqualToString:@" "]) {
                    continue;
                }
                
                if ([s isEqualToString:@"\n"]) {
                    continue;
                }
                
                if ([s isEqualToString:@"\r"]) {
                    continue;
                }
                
                if ([s isEqualToString:@"\t"]) {
                    continue;
                }
                
                keyIndexStart = jsonIndex-1;
            }
            
            if ([s compare:@":"] == NSOrderedSame) {
                classType = [jsonString substringWithRange:NSMakeRange(keyIndexStart, jsonIndex - keyIndexStart-1)];
                keyIndexStart = -1;
                keyOver = YES;
                
                valueStart = YES;
                
                NSRange range = [classType rangeOfString:@"-"];
                
                if (range.length!=0) {
                    className = [classType substringFromIndex:range.location+1];
                    //classType = [classType substringToIndex:range.location];
                }
                else{
                    className = @"";
                }
            }
        }
        //        else if ([s compare:@":"] == NSOrderedSame){
        //            valueStart = YES;
        //        }
        else if (valueStart){
            if ([s isEqualToString:@","]) {
                continue;
            }
            
            if ([s isEqualToString:@"\n"]) {
                continue;
            }
            
            if ([s isEqualToString:@"\r"]) {
                continue;
            }
            
            if ([s isEqualToString:@"\t"]) {
                continue;
            }
            
            if ([s isEqualToString:@" "]) {
                continue;
            }
            
            if ([s compare:@"{"] == NSOrderedSame) {//对象类型
                if (classType.length == 0) {
                    classType = NSStringFromClass(classObject);
                }
                id class = [self inductClass:jsonString className:classType hasKey:hasKey];
                
#ifdef BUG_LOG
                TLog(@"CTSerializeObject class %@",classType);
#endif
                
                [array addObject:class];
            }else if ([s compare:@"\""] == NSOrderedSame) {//字符串类型
                NSString* value = [self inductString:jsonString];
                
                if (className.length>0) {
#ifdef BUG_LOG
                    TLog(@"CTSerializeObject data %@ %@",classType,value);
#endif
                    NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];
                    
                    [array addObject:data];
                }
                else{
#ifdef BUG_LOG
                    TLog(@"CTSerializeObject string %@ %@",classType,value);
#endif
                    [array addObject:value];
                }
            }
            else if ([s compare:@"["] == NSOrderedSame){//数组类型，统一为NSMutableArray
                NSMutableArray* value = [self inductArray:jsonString object:nil hasKey:hasKey];
                
#ifdef BUG_LOG
                TLog(@"CTSerializeObject array %@",value);
#endif
                
                [array addObject:value];
            }
            else{//int类型或bool类型
                jsonIndex--;
                
                NSString* s = [jsonString substringWithRange:NSMakeRange(jsonIndex, 1)];
                
                s = [s stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
                if(s.length > 0)
                {
                    BOOL value = [self inductBOOL:jsonString];
                    
#ifdef BUG_LOG
                    TLog(@"CTSerializeObject bool %c",value);
#endif
                    
                    [array addObject:[NSNumber numberWithBool:value]];
                }else{
                    NSInteger value = [self inductInteger:jsonString];
                    
#ifdef BUG_LOG
                    TLog(@"CTSerializeObject int %d",value);
#endif
                    
                    [array addObject:[NSNumber numberWithInteger:value]];
                }
            }
            
            valueStart = YES;
            keyOver = YES;
            if (hasKey) {
                valueStart = NO;
                keyOver = NO;
            }
            
        }
        else{
        }
    }
}

//反序列化对象 该对象是object的成员
- (void) inductObject:(NSMutableString*)jsonString className:(id)object typeOfClass:(Class)typeOfClass hasKey:(BOOL)hasKey
{
    BOOL keyOver = NO;
    BOOL valueStart = NO;
    int keyIndexStart = -1;
    
    BOOL intStart = NO;
    
    NSString* classType = @"";
    NSString* className = @"";
    
    if (!object) {
        keyOver = YES;
        valueStart = YES;
        classType = NSStringFromClass(typeOfClass);
    }
    
    int intValueIndex = 0;
    
    while (YES) {
        if (jsonIndex == [jsonString length]) {
            break;
        }
        
        NSString* s = [jsonString substringWithRange:NSMakeRange(jsonIndex, 1)];
        
        jsonIndex++;
        
//        if ([s isEqualToString:@"["]) {
//            NSMutableArray* value = [self inductArray:jsonString];
//            
//#ifdef BUG_LOG
//            TLog(@"CTSerializeObject array %@ %@",classType,value);
//#endif
//            
//            if (object) {
//                [self performMethod:object key:classType value:value];
//            }else{
//                self.jsonObject = [[NSMutableArray alloc] initWithArray:value];
//            }
//            break;
//        }
        
        if (!keyOver) {
            if ([s isEqualToString:@","]) {
                continue;
            }
            
            if ([s isEqualToString:@"\n"]) {
                continue;
            }
            
            if ([s isEqualToString:@"\r"]) {
                continue;
            }
            
            if ([s isEqualToString:@"\t"]) {
                continue;
            }
            
            if ([s isEqualToString:@" "]) {
                if (keyIndexStart != -1) {
                    classType = [jsonString substringWithRange:NSMakeRange(keyIndexStart, jsonIndex - keyIndexStart-1)];
                    keyIndexStart = -1;
                    keyOver = YES;
                    
                    valueStart = YES;
                    intValueIndex = 0;
                    
                    NSRange range = [classType rangeOfString:@"-"];
                    
                    if (range.length!=0) {
                        className = [classType substringFromIndex:range.location+1];
                        classType = [classType substringToIndex:range.location];
                    }
                    else{
                        className = classType;
                    }
                    continue;
                }else{
                    continue;
                }
            }
            
            if ([s rangeOfString:@"}"].length != 0 || [s rangeOfString:@"]"].length != 0) {
                return ;
            }
            
            if (keyIndexStart == -1) {
                keyIndexStart = jsonIndex-1;
            }
            
            if ([s compare:@":"] == NSOrderedSame) {
                classType = [jsonString substringWithRange:NSMakeRange(keyIndexStart, jsonIndex - keyIndexStart-1)];
                keyIndexStart = -1;
                keyOver = YES;
                
                valueStart = YES;
                intValueIndex = 0;
                
                NSRange range = [classType rangeOfString:@"-"];
                
                if (range.length!=0) {
                    className = [classType substringFromIndex:range.location+1];
                    classType = [classType substringToIndex:range.location];
                }
                else{
                    className = classType;
                }
            }
        }
        //        else if ([s compare:@":"] == NSOrderedSame){
        //            valueStart = YES;
        //            intValueIndex = 0;
        //        }
        else if (valueStart){
            if ([s isEqualToString:@":"]) {
                continue;
            }
            
            if (!intStart) {
                if ([s isEqualToString:@"\n"]) {
                    continue;
                }
                
                if ([s isEqualToString:@"\r"]) {
                    continue;
                }
                
                if ([s isEqualToString:@"\t"]) {
                    continue;
                }
                
                if ([s isEqualToString:@" "]) {
                    continue;
                }
            }
            
            if ([s compare:@"{"] == NSOrderedSame) {//对象类型
                id class = [self inductClass:jsonString className:classType hasKey:hasKey];
                
#ifdef BUG_LOG
                TLog(@"CTSerializeObject class %@",classType);
#endif
                
                if (!object) {
                    self.jsonObject = class;
                }else{
                    [self performMethod:object key:className value:class];
                }
            }else if ([s compare:@"\""] == NSOrderedSame) {//字符串类型
                NSString* value = [self inductString:jsonString];
//                if (className.length>0) {
//#ifdef BUG_LOG
//                    TLog(@"CTSerializeObject data %@ %@",classType,value);
//#endif
//                    NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];
//                    if (object) {
//                        [self performMethod:object key:className value:data];
//                    }
//                    else{
//                        self.jsonObject = [[NSMutableData alloc] initWithData:data];
//                    }
//                }
//                else{
#ifdef BUG_LOG
                    TLog(@"CTSerializeObject string %@ %@",classType,value);
#endif
//                if ([classType isEqualToString:@"\"version\""] && [value isEqualToString:@"2"]) {
//                    NSLog(@"come on");
//                }
                
                    if (object) {
                        [self performMethod:object key:classType value:value];
                    }
                    else{
                        self.jsonObject = [[NSMutableString alloc] initWithString:value];
                    }
//                }
            }
            else if ([s compare:@"["] == NSOrderedSame){//数组类型，统一为NSMutableArray
                if ([classType isEqualToString:@"\"attribute\""] || [classType isEqualToString:@"attribute"]) {
                    //字典
                    NSMutableDictionary* value = [self inductDictionary:jsonString];
                    
#ifdef BUG_LOG
                    TLog(@"CTSerializeObject dictionary %@ %@",classType,value);
#endif
                    
                    if (object) {
                        [self performMethod:object key:classType value:value];
                    }else{
                        self.jsonObject = value;
                    }
                }else{
                    NSMutableArray* value = [self inductArray:jsonString object:nil hasKey:hasKey];
                    
#ifdef BUG_LOG
                    TLog(@"CTSerializeObject array %@ %@",classType,value);
#endif
                    
                    if (object) {
                        [self performMethod:object key:classType value:value];
                    }else{
                        self.jsonObject = [[NSMutableArray alloc] initWithArray:value];
                    }
                }
            }
            else{//int类型或bool类型
                
                intStart = YES;
                
                if([s compare:@"}"]==NSOrderedSame || [s compare:@"]"]==NSOrderedSame || [s compare:@","]==NSOrderedSame || [s compare:@" "]==NSOrderedSame || [s compare:@"\r"]==NSOrderedSame || [s compare:@"\n"]==NSOrderedSame)
                {
                    NSString* value = [jsonString substringWithRange:NSMakeRange(jsonIndex-intValueIndex-1, intValueIndex)];
                    
                    if ([value isEqualToString:@"null"] && [classType isEqualToString:@"\"attribute\""]) {
                        NSDictionary* dic = [NSDictionary dictionary];
                        [self performMethod:object key:classType value:dic];
                    }else{
                        NSString* temp = [value stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];//将所有数字清空
                        
                        if([value compare:@"true"] == NSOrderedSame || [value compare:@"false"] == NSOrderedSame)//bool类型
                        {
                            NSNumber *boolNumber = [NSNumber numberWithBool:[value boolValue]];
                            
#ifdef BUG_LOG
                            TLog(@"CTSerializeObject boolValue %@ %@",classType,boolNumber);
#endif
                            
                            [self performMethodBasicData:object key:classType value:boolNumber];
                        }
                        else if(temp.length > 0 && [temp compare:@"."] == NSOrderedSame)//double类型
                        {
                            NSNumber* doubleValue = [NSNumber numberWithDouble:[value doubleValue]];
                            
#ifdef BUG_LOG
                            TLog(@"CTSerializeObject double %@ %@",classType,doubleValue);
#endif
                            [self performMethodBasicData:object key:classType value:doubleValue];
                        }
                        else{//int类型
                            NSNumber* integerNumber = [NSNumber numberWithInteger:[value integerValue]];
                            
#ifdef BUG_LOG
                            TLog(@"CTSerializeObject int %@ %@",classType,integerNumber);
#endif
                            
                            [self performMethodBasicData:object key:classType value:integerNumber];
                            //                        [self performMethod:object key:classType value:(id)integerValue];
                        }
                    }
                    
                    if ([s compare:@"}"]==NSOrderedSame || [s compare:@"]"]==NSOrderedSame) {
                        jsonIndex--;
                    }
                }
                else{
                    intValueIndex++;
                    continue;
                }
            }
            
            valueStart = NO;
            keyOver = NO;
            intStart = NO;
        }
        else{
        }
    }
}

@end
