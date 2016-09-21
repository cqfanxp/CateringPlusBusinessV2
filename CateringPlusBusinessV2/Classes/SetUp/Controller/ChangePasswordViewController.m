//
//  ChangePasswordViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/1.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "PrefixHeader.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"修改密码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//提交
- (IBAction)submitClick:(id)sender {
    [self.view endEditing:YES];
    if (![self verification]) {
        return;
    }
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   userInfo[@"id"],@"busUserId",
                                   _oldPasswordField.text,@"oldPassword",
                                   _pasdswordField.text,@"newPassword",
                                   _confirmPasswordField.text,@"confirmPassword",
                                   nil];
    
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/ourselves/mySelf/changePassword"] parameters:[Public getParams:params] success:^(id responseObject) {
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            [self.navigationController popViewControllerAnimated:YES];
            [Public alertWithType:MozAlertTypeSuccess msg:responseObject[@"message"]];
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

//验证
-(Boolean)verification{
    if ([_oldPasswordField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"旧密码不能为空"];
        return false;
    }
    if ([_pasdswordField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"新密码不能为空"];
        return false;
    }
    if (![Verification checkPassword:_pasdswordField.text]) {
        [Public alertWithType:MozAlertTypeError msg:@"密码必须是6-18位数字和字母"];
        return false;
    }
    if ([_confirmPasswordField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"请再次输入密码"];
        return false;
    }
    if (![_confirmPasswordField.text isEqualToString:_pasdswordField.text]) {
        [Public alertWithType:MozAlertTypeError msg:@"两次输入的密码不一致"];
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
