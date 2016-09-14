//
//  SelectPackageViewController.h
//  CateringPlusBusinessV2  选择套餐
//
//  Created by 火爆私厨 on 16/9/13.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"
#import "FeaturesViewController.h"
#import "Package.h"

@interface SelectPackageViewController : FeaturesViewController

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) void(^resultData)(Package *package);
@end
