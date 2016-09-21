//
//  HelpCutSettingsViewController.h
//  CateringPlusBusinessV2  帮帮砍设置
//
//  Created by 火爆私厨 on 16/9/18.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddHelpCut.h"

@interface HelpCutSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) AddHelpCut *addHelpCut;

@property(nonatomic,strong) void(^resultData)(NSArray *data);

@property(nonatomic,strong) NSArray *settingNumberActivities;
@end
