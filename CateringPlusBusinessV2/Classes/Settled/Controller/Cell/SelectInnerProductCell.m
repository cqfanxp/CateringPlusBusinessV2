//
//  SelectInnerProductCell.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/15.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "SelectInnerProductCell.h"
#import "PrefixHeader.h"

@implementation SelectInnerProductCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)cellWithTableView:(UITableView *)tableView text:(NSString *)text{
    static NSString *ID = @"selectInnerProduct_Cell";
    SelectInnerProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SelectInnerProductCell class]) owner:nil options:nil] lastObject];
    }
    cell.text.text = text;
    return cell;
}

@end
