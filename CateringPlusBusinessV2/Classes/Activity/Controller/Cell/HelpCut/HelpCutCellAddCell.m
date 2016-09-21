//
//  HelpCutCellAddCell.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/18.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "HelpCutCellAddCell.h"

@implementation HelpCutCellAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"HelpCutCellAdd_Cell";
    HelpCutCellAddCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HelpCutCellAddCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
