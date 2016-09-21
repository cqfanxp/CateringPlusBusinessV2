//
//  HelpCutCell.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/18.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpCutCell : UITableViewCell

- (instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberPeopleLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
