//
//  ActivityEditViewController.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/27.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"
#import "Activity_ImgCell.h"
#import "Activity_NumberCell.h"
#import "Activity_SelectCell.h"
#import "Activity_TextCell.h"
#import "TableGroupAttributes.h"
#import "Activity_ButtonCell.h"
#import "SelectStores.h"
#import "ActivityModel.h"
#import "Package.h"

@interface ActivityEditViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//plist文件名称
@property(nonatomic,strong) NSString *plistName;

//选择门店弹框
@property(nonatomic,strong) SelectStores *selectStoresView;

//活动对象
@property(nonatomic,strong) ActivityModel *activityModel;
@end
