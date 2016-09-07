//
//  SelectBankCell.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/6.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "SelectBankCell.h"

@implementation SelectBankCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"SelectBank_Cell";
    SelectBankCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SelectBankCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
