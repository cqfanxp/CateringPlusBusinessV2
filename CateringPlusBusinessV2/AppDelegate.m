//
//  AppDelegate.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/11.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "AppDelegate.h"
#import "PrefixHeader.h"

#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"

#import "MainViewController.h"
#import "MapViewController.h"
#import "SelectPackageViewController.h"
#import "SelectStartAndEndTimeViewController.h"
#import "SelectActivityPriceViewController.h"
#import "HelpCutSettingsViewController.h"
#import "InitializationViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化布局
    [self initLayout];
    //初始化Share
    [self initShare];
    
    return YES;
}

#pragma mark 初始化
-(void)initLayout{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    UIViewController *viewController = [Public getStoryBoardByController:@"OAuth" storyboardId:@"LoginViewController"];
//    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
//    MainViewController *viewController = [[MainViewController alloc] init];
//    HelpCutSettingsViewController *viewController = [[HelpCutSettingsViewController alloc] init];
//    SelectStartAndEndTimeViewController *viewController = [[SelectStartAndEndTimeViewController alloc] init];
    
    
    InitializationViewController *viewController = [[InitializationViewController alloc] init];
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    //设置UINavigationBar样式
    [[UINavigationBar appearance] setTintColor:RGB(51, 51, 51)];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
    
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(51,51,51), UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(102,102,102),NSForegroundColorAttributeName,nil]forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(51,51,51),NSForegroundColorAttributeName,nil]forState:UIControlStateSelected];
}

//初始化Share
-(void)initShare{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"1743c50c46740"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxf116b4b0011f2a04"
                                       appSecret:@"b164bd489b8bd63f528d1eadfbc78981"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105632087"
                                      appKey:@"IVubyuTWQl31OaOd"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
