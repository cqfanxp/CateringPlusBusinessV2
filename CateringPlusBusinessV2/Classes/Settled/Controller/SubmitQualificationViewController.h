//
//  SubmitQualificationViewController.h
//  CateringPlusBusinessV2  提交资质
//
//  Created by 火爆私厨 on 16/8/13.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"

@interface SubmitQualificationViewController : BaseViewController

#pragma mark 营业执照容器
@property (weak, nonatomic) IBOutlet UIView *businessLicenseView;

#pragma mark 手持身份证照片容器
@property (weak, nonatomic) IBOutlet UIView *photoIDCard;

//注册号
@property (weak, nonatomic) IBOutlet UITextField *registrationNumberField;

//执照名称
@property (weak, nonatomic) IBOutlet UITextField *licenseNameField;

//姓名
@property (weak, nonatomic) IBOutlet UITextField *nameField;

//身份证
@property (weak, nonatomic) IBOutlet UITextField *iDCardField;

//门店编号
@property(nonatomic,strong) NSString *storeId;

@end
