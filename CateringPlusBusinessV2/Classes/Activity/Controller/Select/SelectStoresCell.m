//
//  SelectStoresCell.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/13.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "SelectStoresCell.h"

@implementation SelectStoresCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"SelectStores_Cell";
    SelectStoresCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SelectStoresCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
