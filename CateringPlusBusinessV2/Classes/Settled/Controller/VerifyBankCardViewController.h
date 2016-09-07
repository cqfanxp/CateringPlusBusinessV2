//
//  VerifyBankCardViewController.h
//  CateringPlusBusinessV2  验证银行卡
//
//  Created by 火爆私厨 on 16/9/6.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyBankCardViewController : UIViewController

//银行类型
@property (weak, nonatomic) IBOutlet UITextField *bankTypeField;

//卡号
@property (weak, nonatomic) IBOutlet UITextField *bankNumField;

//姓名
@property (weak, nonatomic) IBOutlet UITextField *nameField;

//身份证
@property (weak, nonatomic) IBOutlet UITextField *iDCardField;

//手机号码
@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;

//验证码
@property (weak, nonatomic) IBOutlet UITextField *codesField;

@end
