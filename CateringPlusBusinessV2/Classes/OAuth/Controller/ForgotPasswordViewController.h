//
//  ForgotPasswordViewController.h
//  CateringPlusBusinessV2  忘记密码
//
//  Created by 火爆私厨 on 16/8/15.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"

@interface ForgotPasswordViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;

@property (weak, nonatomic) IBOutlet UITextField *codesField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end
