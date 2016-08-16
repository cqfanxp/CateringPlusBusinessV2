//
//  SettledProcessViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/15.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "SettledProcessViewController.h"

@interface SettledProcessViewController ()

@end

@implementation SettledProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"申请入驻流程"];
    
    //右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"开店手册" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark 立即入驻
- (IBAction)nextBtn:(id)sender {
    UIViewController *viewController = [Public getStoryBoardByController:@"Settled" storyboardId:@"SelectInnerProductViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];
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
