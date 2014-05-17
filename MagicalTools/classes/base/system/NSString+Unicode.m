//
//  NSString+Unicode.m
//  LuShiHelper
//
//  Created by Brian on 13-11-12.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "NSString+Unicode.h"

@implementation NSString (Unicode)

//- (NSString *) escapedUnicode
//{
//    NSLog(@"escapedUnicode start");
//    
//    NSMutableString *uniString = [ [ NSMutableString alloc ] init ];
//    UniChar *uniBuffer = (UniChar *) malloc ( sizeof(UniChar) * [ self length ] );
//    CFRange stringRange = CFRangeMake ( 0, [ self length ] );
//    
//    CFStringGetCharacters ( (CFStringRef)self, stringRange, uniBuffer );
//    
//    for ( int i = 0; i < [ self length ]; i++ ) {
//        if ( uniBuffer > 0x7e )
//            [ uniString appendFormat: @"\\u%04x", uniBuffer ];
//        else
//            [ uniString appendFormat: @"%c", uniBuffer ];
//    }
//    
//    free ( uniBuffer );
//    
//    NSString *retString = [ NSString stringWithString: uniString ];
//    
//    return retString;
//}

//- (NSString *) do1
//{
//    NSMutableString *uniString = [ [ NSMutableString alloc ] init ];
//    UniChar *uniBuffer = (UniChar *) malloc ( sizeof(UniChar) * [ self length ] );
//    CFRange stringRange = CFRangeMake ( 0, [ self length ] );
//    
//    CFStringGetCharacters ( (CFStringRef)self, stringRange, uniBuffer );
//    
//    for ( int i = 0; i < [ self length ]; i++ ) {
//        if ( uniBuffer > 0x7e )
//            [ uniString appendFormat: @"\\u%04x", uniBuffer ];
//        else
//            [ uniString appendFormat: @"%c", uniBuffer ];
//    }
//    
//    free ( uniBuffer );
//    
//    NSString *retString = [ NSString stringWithString: uniString ];
//    
//    return retString;
//}

//- (NSString *)replaceUnicode{
//    NSLog(@"replaceUnicode start");
//    
//    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
//    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
//    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
//    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString* error;
//    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
//                                                           mutabilityOption:NSPropertyListImmutable
//                                                                     format:NULL
//                                                           errorDescription:&error];
//    
//    if (error) {
//        NSLog(@"replaceUnicode error = [%@]",error);
//        return @"";
//    }
//    
//    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
//}

@end