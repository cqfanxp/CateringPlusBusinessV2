//
//  SelectPackageCell.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/13.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPackageCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *packageFirstMapImgView;

@property (weak, nonatomic) IBOutlet UILabel *packageNameLabel;

//状态
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;

//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (instancetype)cellWithTableView:(UITableView *)tableView;

@end
