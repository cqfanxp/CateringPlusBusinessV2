//
//  SelectStores.h
//  CateringPlusBusinessV2  选择门店
//
//  Created by 火爆私厨 on 16/9/13.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"

@interface SelectStores : UIView<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSArray *selectData;

@property(nonatomic,strong) void(^resultData)(NSArray *data);
@end
