//
//  MapPOIAddressCell.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/5.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableGroupAttributes.h"
#import "PrefixHeader.h"

@interface MapPOIAddressCell : UITableViewCell

- (instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *address;


@property(nonatomic,strong) TableGroupAttributes *attributes;
@end
