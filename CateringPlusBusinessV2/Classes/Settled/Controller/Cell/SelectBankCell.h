//
//  SelectBankCell.h
//  CateringPlusBusinessV2  选择银行卡Cell
//
//  Created by 火爆私厨 on 16/9/6.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectBankCell : UITableViewCell

//图标
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

//名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (instancetype)cellWithTableView:(UITableView *)tableView;

@end
