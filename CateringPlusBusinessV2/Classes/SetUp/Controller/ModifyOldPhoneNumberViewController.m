//
//  ModifyOldPhoneNumberViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/1.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "ModifyOldPhoneNumberViewController.h"
#import "PrefixHeader.h"

@interface ModifyOldPhoneNumberViewController ()

@end

@implementation ModifyOldPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"修改电话"];
    
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    if (userInfo) {
        _phoneLabel.text = userInfo[@"phone"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark 获取验证码
- (IBAction)verificationCode:(id)sender {
    if ([_phoneLabel.text isEqualToString:@""]) {
        return;
    }
    UIButton *btn = (UIButton *)sender;
    
    NSMutableDictionary *input = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  _phoneLabel.text,@"PhoneNumber",
                                  @"SMS_10245454",@"smsTemlateId",nil];
    
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/businesses/business/sendValidateCode"] parameters:[Public getParams:input] success:^(id responseObject) {
        
        [Public Countdown:btn];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
}

//验证
-(Boolean)verification{
    if ([_SMSVerificationCode.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"验证码不能为空"];
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
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   _phoneLabel.text,@"oldPhone",
                                   _SMSVerificationCode.text,@"validateCode",
                                   nil];
    
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/ourselves/mySelf/validateOldPhone"] parameters:[Public getParams:params] success:^(id responseObject) {
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            UIViewController *viewcontroller = [Public getStoryBoardByController:@"SetUp" storyboardId:@"NewPhoneNumberViewController"];
            
            [self.navigationController pushViewController:viewcontroller animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
