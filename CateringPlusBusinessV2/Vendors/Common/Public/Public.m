//
//  Public.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/15.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "Public.h"

//md5秘钥
#define KEY @"fca349fe-051d-475d-a45c-a61300e6a90c"

@implementation Public


#pragma mark 倒计时
+(void)Countdown:(UIButton *)btn{
    __block int timeout=59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btn setTitle:@"重新发送" forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [btn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}

#pragma mark 根据故事板和id获取UIViewController
+(UIViewController *)getStoryBoardByController:(NSString *)storyboard storyboardId:(NSString *)storyboardId{
    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    UIStoryboard *story = [UIStoryboard storyboardWithName:storyboard bundle:[NSBundle mainBundle]];
    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    UIViewController *controller = [story instantiateViewControllerWithIdentifier:storyboardId];
    
    return controller;
}

#pragma mark 根据参数加密
+(NSString *) paramsMd5:(NSDictionary *) params{
    NSString *paramStr = [self stitchingParameters:params];
    
    return [self md5:paramStr];
}

#pragma mark md5加密
+(NSString *) md5:(NSString *) inPutText{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

#pragma mark 参数拼接
+(NSString *)stitchingParameters:(NSDictionary *)dic{
    if (dic == nil) {
        return nil;
    }
    NSMutableString *str = [[NSMutableString alloc] init];
    
    for ( NSString *key in [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
        [str appendString:[NSString stringWithFormat:@"&%@=%@",key,dic[key]]];
    }
    [str appendString:KEY];
    return str;
}

+(NSDictionary *)getParams:(NSMutableDictionary *)params{
    NSMutableDictionary *input = params;
    if (input == nil) {
        input = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"CateringPlusBusinessV2",@"key",nil];

    }
    NSString *result = [Public paramsMd5:input];
    [input setObject:result forKey:@"sign"];
    return input;
}
//提示信息
+(void)alertWithType:(MozAlertType)type msg:(NSString *)msg{
    [MozTopAlertView showWithType:type text:msg doText:@"确定" doBlock:^{} parentView:Window];
}

//获取或设置NSUserDefaults值
+(void)setUserDefaultKey:(NSString *)key value:(nullable id)value{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+(id)getUserDefaultKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}
@end
