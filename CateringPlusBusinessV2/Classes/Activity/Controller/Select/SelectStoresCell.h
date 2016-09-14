//
//  SelectStoresCell.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/13.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectStoresCell : UITableViewCell

//门店首图
@property (weak, nonatomic) IBOutlet UIImageView *storeFirstMapImgView;

//门店名称
@property (weak, nonatomic) IBOutlet UILabel *busNameLabel;

//门店地址
@property (weak, nonatomic) IBOutlet UILabel *storeAddressLabel;

//状态
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;

- (instancetype)cellWithTableView:(UITableView *)tableView;

@end
