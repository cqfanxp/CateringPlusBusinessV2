//
//  LoginViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/11.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "PrefixHeader.h"

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
    if (IS_IPHONE_5) {
        [self updateHeaderConstraint:-105];
    }else{
        [self updateHeaderConstraint:-25];
    }
}

//隐藏键盘
-(void)keyboardWillHide{
    [self updateHeaderConstraint:30];
}
#pragma mark 申请入驻
- (IBAction)applicationSettled:(id)sender {
    //用户信息
//    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    
    //用户没注册前 按顺序  用户注册后跳到添加门店
//    if (!userInfo) {
    UIViewController *viewController = [Public getStoryBoardByController:@"Settled" storyboardId:@"SettledProcessViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
//    }else{
//        UIViewController *viewController = [Public getStoryBoardByController:@"Settled" storyboardId:@"ImproveStoreInformationViewController"];
//        [self.navigationController pushViewController:viewController animated:YES];
//    }
}

//修改头部logo约束
-(void)updateHeaderConstraint:(float) constant{
    _headerViewConstraintTop.constant = constant;
    //增加动画
    [UIView animateWithDuration:2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

//登录
- (IBAction)loginBtnClick:(id)sender {
    [self.view endEditing:YES];
    //判断网络
    if (![Public isNetWork]) {
        [Public alertWithType:MozAlertTypeError msg:@"请检查你的网络设置！"];
    }
    if (![self verification]) {
        return;
    }
    //当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   _accountField.text,@"account",
                                   _passwordField.text,@"password",
                                   [[UIDevice currentDevice].identifierForVendor UUIDString],@"uniqueIdentifier",
                                   [[UIDevice currentDevice] systemName],@"systemName",
                                   [[UIDevice currentDevice] systemVersion],@"systemVersion",
                                   timeString,@"timestamp",
                                   nil];
    
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/v2/businesses/business/userLogin"] parameters:[Public getParams:params] success:^(id responseObject) {
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            NSDictionary *result = responseObject[@"result"];
            //存储用户信息
            [Public setUserDefaultKey:USERINFO value:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                      result[@"account"],@"account",
                                                      _passwordField.text,@"password",
                                                      result[@"id"],@"id",
                                                      result[@"phone"],@"phone",nil]];
            //登录成功
            if ([result[@"loginState"] isEqualToString:@"10161001"]) {
                MainViewController *mainViwe = [[MainViewController alloc] init];
                [self presentViewController:mainViwe animated:YES completion:nil];
            }
            //登录失败
            if ([result[@"loginState"] isEqualToString:@"10161002"]) {
                [Public alertWithType:MozAlertTypeError msg:responseObject[@"message"]];
            }
            //没有提交资质
            if ([result[@"loginState"] isEqualToString:@"10161003"]) {
                UIViewController *viewController = [Public getStoryBoardByController:@"Settled" storyboardId:@"SubmitQualificationViewController"];
                
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }else{
            [Public alertWithType:MozAlertTypeError msg:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [hud dismiss:YES];
        [Public alertWithType:MozAlertTypeError msg:@"登录错误，请稍后再试"];
        NSLog(@"error:%@",[error.userInfo objectForKey:@"NSLocalizedDescription"]);
    }];

}

//验证
-(Boolean)verification{
    if ([_accountField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"请输入账号"];
        return false;
    }
    if ([_passwordField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"请输入密码"];
        return false;
    }
    return true;
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
