//
//  ChooseSingleProduct_CommodityCell.h
//  CateringPlusBusinessV2  选择单品-商品Cell
//
//  Created by 火爆私厨 on 16/8/30.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"

@interface ChooseSingleProduct_CommodityCell : UITableViewCell

//加
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;

//减
@property (weak, nonatomic) IBOutlet UIButton *lessBtn;

//数量
@property (weak, nonatomic) IBOutlet UILabel *number;

- (instancetype)cellWithTableView:(UITableView *)tableView;


@property(nonatomic,strong) void(^shopCartBlock)(UIButton *plusBtn);
@end
