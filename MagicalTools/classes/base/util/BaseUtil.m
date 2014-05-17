//
//  BaseUtil.m
//  LuShiHelper
//
//  Created by Brian on 13-11-8.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import "BaseUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "BaseDefine.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
//#import 
BOOL isIphone5()
{
    if (((unsigned int)DEVICE_HEIGHT) == 568) { return YES; }
    else return NO;
}

@implementation BaseUtil

#pragma mark - 文件存储路径相关
+ (NSString*)getFileSavePath:(NSString*)fileName pos:(NSString*)pos isMatch:(BOOL)isMatch
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    if (pos.length != 0) {
        pos = [NSString stringWithFormat:@".%@",pos];
    }
    
    NSString* newPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"file/%@%@",fileName,pos]];
    
    if (!isMatch) {
        if (fileName.length!=0 && [BaseUtil fileExist:newPath]) {
            NSInteger index = 1;
            while (YES) {
                newPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"file/%@%d%@",fileName,index,pos]];
                if (![BaseUtil fileExist:newPath]) {
                    break;
                }else{
                    index++;
                }
            }
        }
    }
    
    return newPath;
}

#pragma mark - 图片存储路径相关
+ (NSString *) stringFromMD5:(NSString*)string
{
    if(self == nil || [string length] == 0)   {   return nil; }
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString* outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(unsigned int count = 0; count < CC_MD5_DIGEST_LENGTH; count++)
    {
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

#pragma mark - 颜色相关
+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha
{
    if(hexColor == nil)
    {
        return [UIColor clearColor];
    }
    
    if([hexColor hasPrefix:@"0x"] == YES ||[hexColor hasPrefix:@"0X"] == YES )
    {
        hexColor = [hexColor substringFromIndex:2];
    }
    
    if([hexColor hasPrefix:@"#"] == YES)
    {
        hexColor = [hexColor substringFromIndex:1];
    }
    
    if([hexColor length] != 6)
    {
        return [UIColor clearColor];
    }
    
    unsigned int red,green,blue;
    
	NSRange range;
	range.length = 2;
	
	range.location = 0;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
	
	range.location = 2;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
	
	range.location = 4;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
	
	return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:alpha];
}

#pragma mark - 文件相关

+ (BOOL) fileExist:(NSString*)path
{
    if (!path) {
        return NO;
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL) createPath:(NSString*)path
{
    return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (NSString*) pathInDocument:(NSString*)fileName
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* newPath = [path stringByAppendingPathComponent:fileName];
    
    return newPath;
}

+ (NSString*) pathInCache:(NSString*)folderName fileName:(NSString*)fileName
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    
    path = [path stringByAppendingPathComponent:appName];
    path = [path stringByAppendingPathComponent:folderName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSString* newPath = [path stringByAppendingPathComponent:fileName];
    
    return newPath;
}

#pragma mark - 获取ip地址
+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
+(UIImage *)scaleImage:(UIImage *)_images multiple:(CGFloat)_multiple
{
    UIImage *res_image = nil;
    if (_images) {
        res_image = [UIImage imageWithCGImage:_images.CGImage scale:_multiple orientation:UIImageOrientationUp];
    }
    return res_image;
}

+(CGSize)sizeOfTextInFont:(NSString*)text width:(CGFloat)width height:(CGFloat)height font:(UIFont*)font
{
    CGSize size = CGSizeMake(0, 0);
    
    if (iOS7Higher) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        
        size = [text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }else{
//        size = [text sizeWithFont:font];// forWidth:width lineBreakMode:NSLineBreakByWordWrapping
        size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, height) lineBreakMode:NSLineBreakByCharWrapping];// forWidth:width lineBreakMode:NSLineBreakByWordWrapping

    }
    
    size = CGSizeMake(size.width, ceilf(size.height));
    
    return size;
}

+(float)getHeightByString:(NSString *)text font:(UIFont*)widthfont allwidth:(float)allwidth{
    return ceilf([BaseUtil sizeOfTextInFont:text width:allwidth height:NSIntegerMax font:widthfont].height);
}
+(float)getWidthByString:(NSString *)text font:(UIFont*)widthfont allheight:(float)allheight{
    return ceilf([BaseUtil sizeOfTextInFont:text width:NSIntegerMax height:allheight font:widthfont].width);
}

@end
