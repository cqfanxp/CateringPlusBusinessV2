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

@end
