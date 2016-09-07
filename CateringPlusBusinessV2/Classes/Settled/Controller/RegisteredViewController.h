//
//  RegisteredViewController.h
//  CateringPlusBusinessV2  注册
//
//  Created by 火爆私厨 on 16/8/11.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"

@interface RegisteredViewController : BaseViewController

//邀请码
@property (weak, nonatomic) IBOutlet UITextField *invitationCodeField;

//账号
@property (weak, nonatomic) IBOutlet UITextField *accountNumberField;

//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

//确认密码
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

//验证码
@property (weak, nonatomic) IBOutlet UITextField *codesField;

//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;

@end
