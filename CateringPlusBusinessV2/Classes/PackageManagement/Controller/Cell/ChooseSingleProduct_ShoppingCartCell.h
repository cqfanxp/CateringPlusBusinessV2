//
//  ChooseSingleProduct_ShoppingCartCell.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/31.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"

@interface ChooseSingleProduct_ShoppingCartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//加
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;

//减
@property (weak, nonatomic) IBOutlet UIButton *lessBtn;

//数量
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

- (instancetype)cellWithTableView:(UITableView *)tableView;

//添加
@property(nonatomic,strong) void(^shopCartBlock)(UIButton *plusBtn);
//减少
@property(nonatomic,strong) void(^shopCancelBlock)(UIButton *plusBtn);
@end
