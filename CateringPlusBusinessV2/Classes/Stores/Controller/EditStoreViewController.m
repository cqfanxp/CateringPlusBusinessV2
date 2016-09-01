//
//  EditStoreViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/1.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "EditStoreViewController.h"

@interface EditStoreViewController ()

@end

@implementation EditStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setTitle:@"编辑门店"];
}

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
