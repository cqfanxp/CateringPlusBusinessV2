//
//  StoreManagementCell.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/19.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreManagementCell : UITableViewCell

//图片
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//状态
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

- (instancetype)cellWithTableView:(UITableView *)tableView;

@end
