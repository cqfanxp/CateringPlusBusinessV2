//
//  ChangePasswordViewController.h
//  CateringPlusBusinessV2  修改密码
//
//  Created by 火爆私厨 on 16/9/1.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;

@property (weak, nonatomic) IBOutlet UITextField *pasdswordField;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@end
