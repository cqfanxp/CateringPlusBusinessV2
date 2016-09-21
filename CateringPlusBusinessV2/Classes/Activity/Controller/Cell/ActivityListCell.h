//
//  ActivityListCell.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/22.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"

@interface ActivityListCell : UITableViewCell

- (instancetype)cellWithTableView:(UITableView *)tableView;

//活动首图
@property (weak, nonatomic) IBOutlet UIImageView *firstMapImgView;

//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//已领次数
@property (weak, nonatomic) IBOutlet UILabel *useNumberLabel;

//状态
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

//修改按钮
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
