//
//  NewPhoneNumberViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/1.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "NewPhoneNumberViewController.h"
#import "PrefixHeader.h"

@interface NewPhoneNumberViewController (){
    NSString *_phoneNumber;//手机号码
}

@end

@implementation NewPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"修改电话"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 获取验证码
- (IBAction)verificationCode:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    [self.view endEditing:YES];
    
    if ([_phoneNuberField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"手机号码不能为空"];
        return;
    }
    if (![Verification checkTelNumber:_phoneNuberField.text]) {
        [Public alertWithType:MozAlertTypeError msg:@"手机号码格式不正确"];
        return;
    }
    
    NSMutableDictionary *input = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  _phoneNuberField.text,@"PhoneNumber",
                                  @"SMS_10245454",@"smsTemlateId",nil];
    
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/businesses/business/sendValidateCode"] parameters:[Public getParams:input] success:^(id responseObject) {
        _phoneNumber = _phoneNuberField.text;
        [Public Countdown:btn];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
}

//验证
-(Boolean)verification{
    if ([_smsCodeField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"验证码不能空"];
        return false;
    }
    if(_phoneNumber == nil){
        [Public alertWithType:MozAlertTypeError msg:@"请先获取手机验证码"];
        return false;
    }
    return true;
}

//下一步
- (IBAction)nextClick:(id)sender {
    [self.view endEditing:YES];
    if (![self verification]) {
        return;
    }
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   _smsCodeField.text,@"validateCode",
                                   _phoneNumber,@"newPhone",
                                   userInfo[@"id"],@"busUserId",
                                   nil];
    
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/ourselves/mySelf/changePhone"] parameters:[Public getParams:params] success:^(id responseObject) {
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            //存储用户信息
            [Public setUserDefaultKey:USERINFO value:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                      userInfo[@"account"],@"account",
                                                      userInfo[@"password"],@"password",
                                                      userInfo[@"id"],@"id",
                                                      _phoneNumber,@"phone",nil]];
            
            [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -3)] animated:YES];
        }else{
            NSLog(@"message:%@",responseObject[@"message"]);
            [Public alertWithType:MozAlertTypeError msg:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [hud dismiss:YES];
        NSLog(@"error:%@",error);
        [Public alertWithType:MozAlertTypeError msg:[NSString stringWithFormat:@"%@",error]];
    }];
    
}
@end
