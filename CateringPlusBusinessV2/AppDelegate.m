//
//  AppDelegate.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/11.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "AppDelegate.h"
#import "PrefixHeader.h"

#import "NetWorkUtil.h"

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
    
    
    
//    NSString *str = @"@UserName=admin@Password=123456fca349fe-051d-475d-a45c-a61300e6a90c";
    
    NSMutableDictionary *parame = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"admin",@"userName",
                         @"123456",@"password",nil];
    NSString *result = [Public paramsMd5:parame];
    [parame setObject:result forKey:@"sign"];
    
//    NSDictionary *parame = [[NSDictionary alloc] initWithObjectsAndKeys:
//                            @"10111003",@"PackageState",
//                            @"25398799-d975-4a47-9170-a61300a8080c",@"UserId",
//                            [NSNumber numberWithInt:20],@"Limit",
//                            [NSNumber numberWithInt:0],@"Start",
//                            nil];
    
    [NetWorkUtil post:@"http://192.168.1.124/api/Test" parameters:parame success:^(id responseObject) {
        NSLog(@"----");
    } failure:^(NSError *error) {
        
    }];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *viewController = [Public getStoryBoardByController:@"OAuth" storyboardId:@"LoginViewController"];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
    
    //设置UINavigationBar样式
    [[UINavigationBar appearance] setTintColor:RGB(51, 51, 51)];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
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
