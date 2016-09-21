//
//  SelectActivityPriceViewController.h
//  CateringPlusBusinessV2  选择活动价格
//
//  Created by 火爆私厨 on 16/9/18.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityPrice.h"

@interface SelectActivityPriceViewController : UIViewController

//满
@property (weak, nonatomic) IBOutlet UITextField *totalAmountField;
//减
@property (weak, nonatomic) IBOutlet UITextField *discountedPriceField;
//上线金额Switch
@property (weak, nonatomic) IBOutlet UISwitch *upperLimitSwitch;
//上线金额Field
@property (weak, nonatomic) IBOutlet UITextField *onlineMondyField;
//上线金额View
@property (weak, nonatomic) IBOutlet UIView *onlineMondyView;

@property(nonatomic,strong) ActivityPrice *activityProce;

@property(nonatomic,strong) void(^resultData)(ActivityPrice *item);
@end
