//
//  SelectStartAndEndTimeViewController.h
//  CateringPlusBusinessV2  选择开始时间和结束时间
//
//  Created by 火爆私厨 on 16/9/14.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"

@interface SelectStartAndEndTimeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *startField;

@property (weak, nonatomic) IBOutlet UITextField *endField;

@property(nonatomic,strong) void(^resultData)(NSString *startTime,NSString *endTime);
@end
