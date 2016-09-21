//
//  Public.h
//  CateringPlusBusinessV2  公用方法
//
//  Created by 火爆私厨 on 16/8/15.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonCrypto/CommonDigest.h"
#import "MozTopAlertView.h"
#import "PrefixHeader.h"
#import "Reachability.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface Public : NSObject

#pragma mark 倒计时
+(void)Countdown:(UIButton *) btn;

#pragma mark 根据故事板和id获取UIViewController
+(UIViewController *)getStoryBoardByController:(NSString *)storyboard storyboardId:(NSString *)storyboardId;

#pragma mark 根据参数加密
+(NSString *) paramsMd5:(NSDictionary *) params;

#pragma mark 获取加密后的参数
+(NSDictionary *)getParams:(NSMutableDictionary *)params;

#pragma mark 提交框
+(void)alertWithType:(MozAlertType)type msg:(NSString *)msg;

//获取或设置NSUserDefaults值
+(void)setUserDefaultKey:(NSString *)key value:(nullable id)value;
+(id)getUserDefaultKey:(NSString *)key;

#pragma mark 网络状态
//是否有网络
+(Boolean)isNetWork;

//分享
+(void)share;
@end
