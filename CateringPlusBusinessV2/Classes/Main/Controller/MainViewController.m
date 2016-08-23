//
//  MainViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/18.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "MainViewController.h"
#import "PrefixHeader.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1.
    UIViewController *VC1 = [Public getStoryBoardByController:@"Main" storyboardId:@"HomeViewController"];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:VC1];
    //2.
    UIViewController *VC2 = [Public getStoryBoardByController:@"Main" storyboardId:@"BusinessSchoolViewController"];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:VC2];
    //3.
    UIViewController *VC3 = [Public getStoryBoardByController:@"Main" storyboardId:@"MineViewController"];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:VC3];
    
    VC1.title = @"主页";
    VC2.title = @"生意经";
    VC3.title = @"我的";
    
    NSArray *viewCtrs = @[nav1,nav2,nav3];
    
    [self setViewControllers:viewCtrs animated:YES];
    
    //6.
    UITabBar *tabbar = self.tabBar;
    UITabBarItem *item1 = [tabbar.items objectAtIndex:0];
    UITabBarItem *item2 = [tabbar.items objectAtIndex:1];
    UITabBarItem *item3 = [tabbar.items objectAtIndex:2];
    
    item1.selectedImage = [[UIImage imageNamed:@"home_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"home_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item2.selectedImage = [[UIImage imageNamed:@"business_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"business_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item3.selectedImage = [[UIImage imageNamed:@"mine_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"mine_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
