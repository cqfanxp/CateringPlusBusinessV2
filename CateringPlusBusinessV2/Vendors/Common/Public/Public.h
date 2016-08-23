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

@interface Public : NSObject

#pragma mark 倒计时
+(void)Countdown:(UIButton *)btn;

#pragma mark 根据故事板和id获取UIViewController
+(UIViewController *)getStoryBoardByController:(NSString *)storyboard storyboardId:(NSString *)storyboardId;

#pragma mark 根据参数加密
+(NSString *) paramsMd5:(NSDictionary *) params;
@end
