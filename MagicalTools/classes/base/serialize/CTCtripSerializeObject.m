//
//  CTSerializeObject.m
//  TestSerializer
//
//  Created by 陆文杰 on 12-11-22.
//  Copyright (c) 2012年 Brian. All rights reserved.
//

#import "CTCtripSerializeObject.h"
#import <objc/runtime.h>
#import "CTAnnotationModel.h"
#import "StringUtil.h"

static CTCtripSerializeObject * ser = nil;

@implementation CTCtripSerializeObject

@synthesize jsonObject;
@synthesize objectString;
@synthesize hasFree;

#pragma mark - 系统方法

- (id)init
{
    self = [super init];
    
    if (self) {
        objectString = [[NSMutableString alloc] initWithCapacity:1];
        [objectString appendString:@"\n"];
        jsonLevel = -1;
        hasFree = YES;
        encoding = [StringUtil getServerEncode];
    }
    return self;
}

- (void)dealloc
{
    [jsonObject release];
    [objectString release];
    [super dealloc];
}

- (void)clean
{
    [objectString setString:@""];
    jsonLevel = -1;
    jsonIndex = 0;
    jsonObject = nil;
}

#pragma mark - 单例模式
+ (CTCtripSerializeObject*) getInstance
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
    
    if ([className compare:@"NSConcreteData"] == NSOrderedSame || [className compare:@"NSConcreteMutableData"] == NSOrderedSame) {//字符串要特殊处理
        className = @"NSMutableData";
        
        jsonLevel--;
        
        [self parseData:className Value:object isLast:last isArray:NO];
        return;
    }
    
    if(!isArray && ![name isEqualToString:@"object"]){//非标准json格式，添加对象的类名和字段名
        [self fillWithBlank];
//        [objectString appendFormat:@"%@-%@:\n",className,name];
        [objectString appendFormat:@"%@:\n",name];
    }else{
//        [self fillWithBlank];
//        [objectString appendFormat:@"%@:\n",className];
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
        CLog(@"CTSerializeObject %@ %@",propertyNameString,type);
#endif
        
        if ([type rangeOfString:@"NSString"].length != 0) {
            [self parseString:propertyNameString Value:value isLast:i==outCount-1];
        }
        else if([type rangeOfString:@"NSMutableData"].length != 0 || [type rangeOfString:@"NSData"].length != 0){
            [self parseData:propertyNameString Value:value isLast:i==outCount-1 isArray:isArray];
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
            [self parseClass:value nameOfObject:propertyNameString isLast:i==outCount-1 neesClassName:YES isArray:NO];
        }
        
        [propertyNameString release];
    }
    free(properties); //yubo
    [propertyNames release];
    
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
        className = @"NSMutableString";
        
        jsonLevel--;
        
        [self parseString:className Value:object isLast:last];
        return;
    }
    
    if ([className compare:@"NSConcreteData"] == NSOrderedSame || [className compare:@"NSConcreteMutableData"] == NSOrderedSame) {//字符串要特殊处理
        className = @"NSMutableData";
        
        jsonLevel--;
        
        [self parseData:className Value:object isLast:last isArray:isArray];
        return;
    }
    
    if(!isArray && ![name isEqualToString:@"object"]){//非标准json格式，添加对象的类名和字段名
        [self fillWithBlank];
//        [objectString appendFormat:@"%@-%@:\n",className,name];
        [objectString appendFormat:@"%@:\n",name];
    }else{
//        [self fillWithBlank];
//        [objectString appendFormat:@"%@:\n",className];
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
        CLog(@"CTSerializeObject %@",type);
#endif
        
        if ([type rangeOfString:@"NSString"].length != 0) {
            [self parseString:propertyNameString Value:value isLast:i==outCount-1];
        }
        else if([type rangeOfString:@"NSMutableData"].length != 0 || [type rangeOfString:@"NSData"].length != 0){
            [self parseData:propertyNameString Value:value isLast:i==outCount-1 isArray:isArray];
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
        
        [propertyNameString release];
    }
    free(properties); //yubo
    [propertyNames release];
    
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
- (void) parseData:(NSString*)key Value:(NSData*)data isLast:(BOOL)last isArray:(BOOL)isArray
{
    jsonLevel++;
    
    [self fillWithBlank];
    
    NSString* string = [[NSString alloc] initWithData:data encoding:encoding];
    
    if(last){
//        if (isArray) {
//            [objectString appendFormat:@"NSMutableData-%@:\"%@\"\n",key,string];
//        }else{
            [objectString appendFormat:@"%@:\"%@\"\n",key,string];
//        }
    }
    else{
//        if (isArray) {
//            [objectString appendFormat:@"NSMutableData-%@:\"%@\",\n",key,string];
//        }else{
            [objectString appendFormat:@"%@:\"%@\",\n",key,string];
//        }
    }
    
    [string release];
    
    jsonLevel--;
}

//array序列化
- (void) parseArray:(NSString*)key Value:(NSArray*)array isLast:(BOOL)last
{
    jsonLevel++;
    
    [self fillWithBlank];
    [objectString appendFormat:@"%@:\n",key];
    
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
        [objectString appendFormat:@"%@:\"%@\"\n",key,value];
    }
    else{
        [objectString appendFormat:@"%@:\"%@\",\n",key,value];
    }
    
    jsonLevel--;
}

//double序列化
- (void) parseDouble:(NSString*)key Value:(double)value isLast:(BOOL)last
{
    jsonLevel++;
    
    [self fillWithBlank];
    
    if (last) {
        [objectString appendFormat:@"%@:%f\n",key,value];
    }
    else{
        [objectString appendFormat:@"%@:%f,\n",key,value];
    }
    
    jsonLevel--;
}

//int序列化
- (void) parseInteger:(NSString*)key Value:(NSInteger)value isLast:(BOOL)last
{
    jsonLevel++;
    
    [self fillWithBlank];
    
    if (last) {
        [objectString appendFormat:@"%@:%d\n",key,value];
    }
    else{
        [objectString appendFormat:@"%@:%d,\n",key,value];
    }
    
    jsonLevel--;
}

//bool序列化
- (void) parseBool:(NSString*)key Value:(BOOL)value isLast:(BOOL)last
{
    jsonLevel++;
    
    [self fillWithBlank];
    
    if (value) {
        if (last) {
            [objectString appendFormat:@"%@:true\n",key];
        }
        else{
            [objectString appendFormat:@"%@:true,\n",key];
        }
        
    }
    else{
        if (last) {
            [objectString appendFormat:@"%@:false\n",key];
        }
        else{
            [objectString appendFormat:@"%@:false,\n",key];
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
    
    @synchronized(self) {
        @try {
            
#ifdef BUG_LOG
            CLog(@"serialize start %@",NSStringFromClass([object class]));
#endif
            
            if (!hasFree) {
#ifdef BUG_LOG
                CLog(@"序列化出问题了");
#endif
            }
            
            self.hasFree = NO;

            [self clean];
            
            
            
            [objectString setString:@""];
            
            [self parseClass:object nameOfObject:@"object" isLast:YES neesClassName:NO isArray:NO];
            
            jsonString = [[objectString mutableCopy] autorelease];
            
        }
        @catch (NSException *exception) {
            CLog(@"CTSerializeObject %@",exception);
            [objectString setString:@""];
        }
        @finally {
            self.hasFree = YES;
#ifdef BUG_LOG
            CLog(@"serialize end %@",NSStringFromClass([object class]));
#endif
        }
    }
    
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
        
    }
    
    return objectString;
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
#ifdef BUG_LOG
        CLog(@"deSerialize start");
#endif
        
        if (!hasFree) {
#ifdef BUG_LOG
            CLog(@"反序列化出问题了");
#endif
        }
        
        self.hasFree = NO;
        
        [self clean];
        
//        [self deleteAllBlank:jsonString];
        
        switch (type) {
            case 0:
            {
                [jsonObject release];
                if ([[jsonString lowercaseString] compare:@"true"] == NSOrderedSame) {
                    jsonObject = (id)YES;
                }
                else{
                    jsonObject = (id)NO;
                }
            }
                break;
            case 1:
            {
                [jsonObject release];
                jsonObject = (id)[jsonString integerValue];
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
        self.hasFree = YES;
        
        objectDeser = [[self.jsonObject copy] autorelease];
        
#ifdef BUG_LOG
        CLog(@"deSerialize end");
#endif
    }
    

    
    return objectDeser;
}

#pragma mark - 反序列化相关-公有方法

//凡序列化接口
//jsonString 需要反序列化的符合规则的字符串
//arg1 NSMutableString 需要反序列化的字符串
//return 如果为nil表示反序列化失败 且可能会有一定的内存泄漏
- (id) deSerialize:(NSMutableString*) jsonString  classType:(Class)classType
{
    id objectDeser = nil;
    
    @synchronized(self) {
        @try {
            
#ifdef BUG_LOG
            CLog(@"deSerialize start");
#endif
            
            if (!hasFree) {
#ifdef BUG_LOG
                CLog(@"反序列化出问题了");
#endif
            }
            
            self.hasFree = NO;
            
            [self clean];
            
//            [self deleteAllBlank:jsonString];
            
            [self inductObject:jsonString className:nil typeOfClass:classType];
            
            objectDeser = [[self.jsonObject copy] autorelease];
        }
        @catch (NSException *exception) {
            CLog(@"CTSerializeObject %@",exception);
            self.jsonObject = nil;
        }
        @finally {
            self.hasFree = YES;
#ifdef BUG_LOG
            CLog(@"deSerialize end");
#endif
        }
        
    }

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
    if ([[key substringToIndex:1] isEqualToString:@"\""]) {
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
- (void) performMethod:(id)class key:(NSString*)key value:(NSNumber*)value isDouble:(BOOL)isDouble
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
- (id) inductClass:(NSMutableString*)jsonString className:(NSString*)className
{
    Class class = NSClassFromString(className);
    id object = [[class alloc] init];
    
    [self inductObject:jsonString className:object typeOfClass:class];
    
    return [object autorelease];
}

//反序列化array 都以NSMutableArray返回
- (NSMutableArray*) inductArray:(NSMutableString*)jsonString model:(id)model
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:1];
    
    [self inductObject:jsonString array:array model:model];
    
    return [array autorelease];
    
}

//反序列化对象 该对象是array的内容
- (void) inductObject:(NSMutableString*)jsonString array:(NSMutableArray*)array model:(id)model
{
    BOOL keyOver = YES;
    BOOL valueStart = YES;
    int keyIndexStart = -1;
    
    NSString* classType = @"";
    NSString* className = @"";
    
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
                id class = [self inductClass:jsonString className:model];
                
#ifdef BUG_LOG
                CLog(@"CTSerializeObject class %@",model);
#endif
                
                [array addObject:class];
                
//                [class release];
            }else if ([s compare:@"\""] == NSOrderedSame) {//字符串类型
                NSString* value = [self inductString:jsonString];
                
                if (className.length>0) {
#ifdef BUG_LOG
                    CLog(@"CTSerializeObject data %@ %@",classType,value);
#endif
                    NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];
                    
                    [array addObject:data];
                }
                else{
#ifdef BUG_LOG
                    CLog(@"CTSerializeObject string %@ %@",classType,value);
#endif
                    [array addObject:value];
                }
            }
//            else if ([s compare:@"["] == NSOrderedSame){//数组类型，统一为NSMutableArray
//                NSMutableArray* value = [self inductArray:jsonString];
//                
//#ifdef BUG_LOG
//                CLog(@"CTSerializeObject array %@",value);
//#endif
//                
//                [array addObject:value];
//                
//                [value release];
//            }
            else{//int类型或bool类型
                jsonIndex--;
                
                NSString* s = [jsonString substringWithRange:NSMakeRange(jsonIndex, 1)];
                
                s = [s stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
                if(s.length > 0)
                {
                    BOOL value = [self inductBOOL:jsonString];
                    
#ifdef BUG_LOG
                    CLog(@"CTSerializeObject bool %c",value);
#endif
                    
                    [array addObject:(id)value];
                }else{
                    NSInteger value = [self inductInteger:jsonString];
                    
#ifdef BUG_LOG
                    CLog(@"CTSerializeObject int %d",value);
#endif
                    
                    [array addObject:(id)value];
                }
            }
            
            valueStart = YES;
            keyOver = YES;
        }
        else{
        }
    }
}

//反序列化对象 该对象是object的成员
- (void) inductObject:(NSMutableString*)jsonString className:(id)object typeOfClass:(Class)typeOfClass
{
    BOOL keyOver = NO;
    BOOL valueStart = NO;
    int keyIndexStart = -1;
    
    BOOL intStart = NO;
    
    if (!object) {
        keyOver = YES;
        valueStart = YES;
    }
    
    NSString* classType = @"";
    NSString* className = @"";
        
    int intValueIndex = 0;
    
    id tempClass = [[typeOfClass alloc] init];
    NSMutableArray* annotationModel = [tempClass performSelector:@selector(getAnnotationArray)];
    [tempClass release];
    
    int arrayIndex = 0;
    
    CTAnnotationModel* model = [annotationModel objectAtIndex:arrayIndex];
    
    while (YES) {
        if (jsonIndex == [jsonString length]) {
            break;
        }
        
        NSString* s = [jsonString substringWithRange:NSMakeRange(jsonIndex, 1)];
        
        jsonIndex++;
        
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
            
            if ([classType isEqualToString:@"realServiceCode"] || [classType isEqualToString:@"validate"]) {
                arrayIndex--;
                if (arrayIndex< [annotationModel count]) {
                    model = [annotationModel objectAtIndex:arrayIndex];
                }
            }
            
            if (classType.length>0 && ![classType isEqualToString:model.fieldName_]) {
                for (int i=0; i<[annotationModel count]; i++) {
                    CTAnnotationModel* tempModel = [annotationModel objectAtIndex:i];
                    if ([tempModel.fieldName_ isEqualToString:classType]) {
                        arrayIndex = i;
                        model = tempModel;
                        break;
                    }
                }
            }
            
            if ([s compare:@"{"] == NSOrderedSame) {//对象类型
                if (classType.length==0) {
                    classType = NSStringFromClass(typeOfClass);
                }
                else{
                    classType = [model getServiceModelType];
                }
                
                id class = [self inductClass:jsonString className:classType];
                
#ifdef BUG_LOG 
                CLog(@"CTSerializeObject class %@",classType);
#endif
                
                if (!object) {
                    self.jsonObject = class;
                }else{
                    [self performMethod:object key:className value:class];
                }
                
//                [class release];
            }else if ([s compare:@"\""] == NSOrderedSame) {//字符串类型
                NSString* value = [self inductString:jsonString];
                
                if ([model.parserType_ isEqualToString:@"NSData"] || model.serializeType_ == FLAG_ByteArray) {
#ifdef BUG_LOG
                    CLog(@"CTSerializeObject data %@ %@",classType,value);
#endif
                    NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];
                    if (object) {
                        [self performMethod:object key:className value:data];
                    }
                    else{
                        self.jsonObject = [[NSMutableData alloc] initWithData:data];
                    }
                }
                else{
#ifdef BUG_LOG
                    CLog(@"CTSerializeObject string %@ %@",classType,value);
#endif
                    if (object) {
                        [self performMethod:object key:classType value:value];
                    }
                    else{
                        self.jsonObject = [[NSMutableString alloc] initWithString:value];
                    }
                }
            }
            else if ([s compare:@"["] == NSOrderedSame){//数组类型，统一为NSMutableArray
                NSMutableArray* value = [self inductArray:jsonString model:model.fieldParmType_];
                
#ifdef BUG_LOG
                CLog(@"CTSerializeObject array %@ %@",classType,value);
#endif
                
                if (object) {
                    [self performMethod:object key:classType value:value];
                }else{
                    self.jsonObject = [[NSMutableArray alloc] initWithArray:value];
                }
                
//                [value release];
            }
            else{//int类型或bool类型
                
                intStart = YES;
                
                if([s compare:@"}"]==NSOrderedSame || [s compare:@"]"]==NSOrderedSame || [s compare:@","]==NSOrderedSame || [s compare:@" "]==NSOrderedSame || [s compare:@"\r"]==NSOrderedSame || [s compare:@"\n"]==NSOrderedSame)
                {
                    NSString* value = [jsonString substringWithRange:NSMakeRange(jsonIndex-intValueIndex-1, intValueIndex)];
                    NSString* temp = [value stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];//将所有数字清空
                    
                    if([value compare:@"true"] == NSOrderedSame || [value compare:@"false"] == NSOrderedSame)//bool类型
                    {
                        BOOL boolValue = [value boolValue];
                        
#ifdef BUG_LOG
                        CLog(@"CTSerializeObject boolValue %@ %c",classType,boolValue);
#endif
                        
                        [self performMethod:object key:classType value:(id)boolValue];
                    }
                    else if(temp.length > 0 && [temp compare:@"."] == NSOrderedSame)//double类型
                    {
                        NSNumber* doubleValue = [NSNumber numberWithDouble:[value doubleValue]];
                        
#ifdef BUG_LOG
                        CLog(@"CTSerializeObject double %@ %@",classType,doubleValue);
#endif
                        
                        [self performMethod:object key:classType value:doubleValue isDouble:YES];
                    }
                    else{//int类型
                        NSInteger integerValue = [value integerValue];
                        
#ifdef BUG_LOG
                        CLog(@"CTSerializeObject int %@ %d",classType,integerValue);
#endif
                        
                        [self performMethod:object key:classType value:(id)integerValue];
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
            arrayIndex++;
            if (arrayIndex< [annotationModel count]) {
                model = [annotationModel objectAtIndex:arrayIndex];
            }
        }
        else{
        }
    }
}

@end
