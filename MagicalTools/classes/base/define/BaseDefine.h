//
//  BaseDefine.h
//  LuShiHelper
//
//  Created by Brian on 13-11-8.
//  Copyright (c) 2013年 zhongmei. All rights reserved.
//

#ifndef LuShiHelper_BaseDefine_h
#define LuShiHelper_BaseDefine_h

#pragma mark - 数值宏定义

//#define GM86

//#define fast_test

#define Navigation_Height 44
#define SendView_Height 68
#define AllSend_Height 45

#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define iOS7Higher ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7 ? YES : NO)

#define Max_Request_Count 4

//断点续传开关
#define breakpoint_resume 0
//图片下载线程池内线程总数
#define maxDownloadOperationCount 3
//图片读取本地线程池内线程总数
#define maxDiskOperationCount 3

#pragma mark - 字符宏定义

#define imageHost @""//@"http://10.10.10.18:8215/gm86app"
#define gameicon @""//@"http://img.ios114.com"
#define service_home @"http://m.whzm.cn:8215/gm86app/blog"
//http://192.168.102.56/gm86app/gm86app/blog
//http://10.10.10.18:8215/gm86app/blog
//http://m.whzm.cn:8215/gm86app/blog

#define numImaged(num) [UIImage imageNamed:[NSString stringWithFormat:@"img_%d.png",num]]

#define font_num [UIFont fontWithName:@"Optima-ExtraBlack" size:18]
#define font_num_small [UIFont fontWithName:@"Optima-ExtraBlack" size:9]

#define default_touxiang @"temp_touxiang.png"
#define default_jietu @"temp_jietu.png"

#define wifiConnct @"WIFI_Connect"

#define key_mySender @"key_mySender"

#define autoLogin_username @"autoLogin_username"
#define autoLogin_password @"autoLogin_password"
#define attGame @"gm86AttentionGameViewController_gm8614NewsModel_%@"

#define tip_clean @"清除缓存成功"
#define tip_error_login_username @"用户名格式不正确"

#pragma mark - 日志
//打印日志

#ifdef GM86
    #define TLog(format, ...)
#else
    #define TLog(format, ...) NSLog(format, ## __VA_ARGS__)
#endif

#define PrintRect(frame) TLog(@"X:%f,Y:%f,W:%f,H:%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height)

//序列化 打印日志
//#define BUG_LOG

#pragma mark - 方法宏定义
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef void (^loginSuccess)(void);
typedef void (^SenderSuccessMethod)(id sender);
typedef void (^SenderFailMethod)(id sender);

#endif
