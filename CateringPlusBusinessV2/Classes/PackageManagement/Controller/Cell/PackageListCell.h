//
//  PackageListCell.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/22.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageListCell : UITableViewCell

- (instancetype)cellWithTableView:(UITableView *)tableView;

//套餐首图
@property (weak, nonatomic) IBOutlet UIImageView *packageImgView;

//套餐名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

//修改按钮
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@end
