//
//  UIImage+Scale.h
//  CommonTools
//
//  Created by Brian on 14-1-21.
//  Copyright (c) 2014年 gm86. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Scale)

-(UIImage*)getSubImage:(CGRect)rect;
-(UIImage*)scaleToSize:(CGSize)size;

@end
