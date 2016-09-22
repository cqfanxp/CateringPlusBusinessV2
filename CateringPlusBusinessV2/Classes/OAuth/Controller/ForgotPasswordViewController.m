//
//  ForgotPasswordViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/15.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController (){
    NSString *_phoneNumber;//手机号码
}

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"找回密码"];
    
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

#pragma mark 获取验证码
- (IBAction)verificationCode:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    [self.view endEditing:YES];
    
    if ([_phoneNumberField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"手机号码不能为空"];
        return;
    }
    if (![Verification checkTelNumber:_phoneNumberField.text]) {
        [Public alertWithType:MozAlertTypeError msg:@"手机号码格式不正确"];
        return;
    }
    
    NSMutableDictionary *input = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  _phoneNumberField.text,@"PhoneNumber",
                                  @"SMS_10245454",@"smsTemlateId",nil];
    
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/businesses/business/sendValidateCode"] parameters:[Public getParams:input] success:^(id responseObject) {
        _phoneNumber = _phoneNumberField.text;
        [Public Countdown:btn];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

//提交
- (IBAction)submitClick:(id)sender {
    if (![self verification]) {
        return;
    }
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                   _accountNumberField.text,@"Account",
//                                   _passwordField.text,@"Password",
//                                   _confirmPasswordField.text,@"ConfirmPassword",
//                                   _phoneNumber,@"PhoneNumber",
//                                   _codesField.text,@"UserCode",
//                                   nil];
//    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
//    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/businesses/business/register"] parameters:[Public getParams:params] success:^(id responseObject) {
//        [hud dismiss:YES];
//        if ([responseObject[@"success"] boolValue]) {
//            NSDictionary *result = responseObject[@"result"];
//            //存储用户信息
//            [Public setUserDefaultKey:USERINFO value:[[NSDictionary alloc] initWithObjectsAndKeys:
//                                                      result[@"account"],@"account",
//                                                      _passwordField.text,@"password",
//                                                      result[@"id"],@"id",
//                                                      result[@"phone"],@"phone",nil]];
//            //存储用户验证信息
//            [Public setUserDefaultKey:USERVERIFICATIONINFO value:[[NSDictionary alloc] initWithObjectsAndKeys:params[@"Account"],@"account",
//                                                                  params[@"Password"],@"password", nil]];
//            //跳转到下一步
//            UIViewController *viewController = [Public getStoryBoardByController:@"Settled" storyboardId:@"ImproveStoreInformationViewController"];
//            [self.navigationController pushViewController:viewController animated:YES];
//        }else{
//            [Public alertWithType:MozAlertTypeError msg:responseObject[@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [hud dismiss:YES];
//        NSLog(@"error:%@",error);
//    }];
}

//验证
-(Boolean)verification{
    
    if ([_codesField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"验证码不能空"];
        return false;
    }
    if(_phoneNumber == nil){
        [Public alertWithType:MozAlertTypeError msg:@"请先获取手机验证码"];
        return false;
    }
    if ([_passwordField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"密码不能为空"];
        return false;
    }
    if (![Verification checkPassword:_passwordField.text]) {
        [Public alertWithType:MozAlertTypeError msg:@"密码必须是6-18位数字和字母"];
        return false;
    }
    return true;
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
