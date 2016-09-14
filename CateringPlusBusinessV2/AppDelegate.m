//
//  AppDelegate.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/11.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "AppDelegate.h"
#import "PrefixHeader.h"

#import "MainViewController.h"
#import "MapViewController.h"
#import "SelectPackageViewController.h"
#import "SelectStartAndEndTimeViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化布局
    [self initLayout];
    
    return YES;
}

#pragma mark 初始化
-(void)initLayout{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *viewController = [Public getStoryBoardByController:@"Activity" storyboardId:@"ActivityEditViewController"];
//    MainViewController *viewController = [[MainViewController alloc] init];
//    MapViewController *viewController = [[MapViewController alloc] init];
//    SelectStartAndEndTimeViewController *viewController = [[SelectStartAndEndTimeViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
    
    //设置UINavigationBar样式
    [[UINavigationBar appearance] setTintColor:RGB(51, 51, 51)];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
    
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(51,51,51), UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(102,102,102),NSForegroundColorAttributeName,nil]forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(51,51,51),NSForegroundColorAttributeName,nil]forState:UIControlStateSelected];
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
