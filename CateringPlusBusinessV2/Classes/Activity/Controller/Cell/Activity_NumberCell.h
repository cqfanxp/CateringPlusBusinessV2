//
//  Activity_NumberCell.h
//  CateringPlusBusinessV2  活动数字输入Cell
//
//  Created by 火爆私厨 on 16/8/23.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableGroupAttributes.h"

@interface Activity_NumberCell : UITableViewCell
//
@property (weak, nonatomic) IBOutlet UILabel *labelText;
//
@property (weak, nonatomic) IBOutlet UITextField *valueText;

@property(nonatomic,strong) TableGroupAttributes *attributes;

- (instancetype)cellWithTableView:(UITableView *)tableView tableGroupAttributes:(TableGroupAttributes *) attributes;

@end
