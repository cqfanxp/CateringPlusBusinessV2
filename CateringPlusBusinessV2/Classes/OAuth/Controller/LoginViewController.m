//
//  LoginViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/11.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //注册键盘事件
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //键盘隐藏时
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillHide)
                          name:UIKeyboardWillHideNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillShow)
                          name:UIKeyboardWillShowNotification
                        object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 联系客服
- (IBAction)contactCustomerService:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-0236903"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark 点击view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //结束编辑
    [self.view endEditing:YES];
}
#pragma mark 忘记密码
- (IBAction)forgetPwd:(id)sender {
    UIViewController *viewController = [Public getStoryBoardByController:@"OAuth" storyboardId:@"ForgotPasswordViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

//显示键盘
-(void)keyboardWillShow{
    [self updateHeaderConstraint:0];
}

//隐藏键盘
-(void)keyboardWillHide{
    [self updateHeaderConstraint:30];
}
#pragma mark 申请入驻
- (IBAction)applicationSettled:(id)sender {
    UIViewController *viewController = [Public getStoryBoardByController:@"Settled" storyboardId:@"SettledProcessViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

//修改头部logo约束
-(void)updateHeaderConstraint:(float) constant{
    _headerViewConstraintTop.constant = constant;
    //增加动画
    [UIView animateWithDuration:2 animations:^{
        [self.view layoutIfNeeded];
    }];
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
