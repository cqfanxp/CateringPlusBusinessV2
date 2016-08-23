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
//    
//    NSMutableDictionary *input = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"admin",@"UserName",
//                         @"123456",@"password",nil];
//    NSString *result = [Public paramsMd5:input];
//    [input setObject:result forKey:@"sign"];
//    
////    NSDictionary *parame = [[NSDictionary alloc] initWithObjectsAndKeys:
////                            @"10111003",@"PackageState",
////                            @"25398799-d975-4a47-9170-a61300a8080c",@"UserId",
////                            [NSNumber numberWithInt:20],@"Limit",
////                            [NSNumber numberWithInt:0],@"Start",
////                            nil];
//    
//    
//    [NetWorkUtil post:@"http://192.168.1.124/api/Test" parameters:input success:^(id responseObject) {
//        NSLog(@"----");
//    } failure:^(NSError *error) {
//        
//    }];
    
    
    //1。创建管理者对象
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"application/json",@"*/*"]];//设置相应内容类型
//    //2.上传文件
//        NSMutableDictionary *parame = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"admin",@"userName",
//                             @"123456",@"password",nil];
//        NSString *result = [Public paramsMd5:parame];
//        [parame setObject:result forKey:@"sign"];
//    
//    NSString *urlString = @"http://192.168.1.124/api/Test";
//    [manager POST:urlString parameters:parame constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        //上传文件参数
//        UIImage *iamge = [UIImage imageNamed:@"settledProcess"];
//        NSData *data = UIImagePNGRepresentation(iamge);
//        //这个就是参数
//        [formData appendPartWithFileData:data name:@"file" fileName:@"123.png" mimeType:@"image/png"];
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//        //打印下上传进度
//        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        //请求成功
//        NSLog(@"请求成功：%@",responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        //请求失败
//        NSLog(@"请求失败：%@",error);
//    }];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    UIViewController *viewController = [Public getStoryBoardByController:@"Activity" storyboardId:@"ActivityListViewController"];
    MainViewController *viewController = [[MainViewController alloc] init];
//    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    //设置UINavigationBar样式
    [[UINavigationBar appearance] setTintColor:RGB(51, 51, 51)];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
    
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(51,51,51), UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(102,102,102),UITextAttributeTextColor,nil]forState:UIControlStateNormal];

    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(51,51,51),UITextAttributeTextColor,nil]forState:UIControlStateSelected];
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
