//
//  BaseUtil.h
//  LuShiHelper
//
//  Created by Brian on 13-11-8.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDefine.h"
#import "BaseDataSource.h"

BOOL isIphone5();

@interface BaseUtil : NSObject

+ (NSString*)getFileSavePath:(NSString*)fileName pos:(NSString*)pos isMatch:(BOOL)isMatch;
//+ (NSString*)getImageSaveName:(NSString*)url;
//+ (NSString*)getImageSavePathByURL:(NSString*)url;
//+ (NSString*)getImageSavePath;
+ (NSString*)stringFromMD5:(NSString*)string;

+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha;

+ (BOOL) fileExist:(NSString*)path;
+ (BOOL) createPath:(NSString*)path;

+ (NSString*) pathInDocument:(NSString*)fileName;
+ (NSString*) pathInCache:(NSString*)folderName fileName:(NSString*)fileName;

+ (NSString *)getIPAddress;
+(UIImage *)scaleImage:(UIImage *)_images multiple:(CGFloat)_multiple;

+(CGSize)sizeOfTextInFont:(NSString*)text width:(CGFloat)width height:(CGFloat)height font:(UIFont*)font;
+(float)getHeightByString:(NSString *)text font:(UIFont*)widthfont allwidth:(float)allwidth;
+(float)getWidthByString:(NSString *)text font:(UIFont*)widthfont allheight:(float)allheight;
@end
