//
//  RegisteredViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/11.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "RegisteredViewController.h"


@interface RegisteredViewController ()

@end

@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"注册"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark 点击view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //结束编辑
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 立即注册
- (IBAction)submitRegistration:(id)sender {
    UIViewController *viewController = [Public getStoryBoardByController:@"Settled" storyboardId:@"ImproveStoreInformationViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}



#pragma mark 获取验证码
- (IBAction)verificationCode:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [Public Countdown:btn];
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
