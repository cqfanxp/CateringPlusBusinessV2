//
//  BusinessSchoolCell.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/19.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "BusinessSchoolCell.h"

@implementation BusinessSchoolCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)cellWithTableView:(UITableView *)tableView text:(NSString *)text{
    static NSString *ID = @"BusinessSchool_Cell";
    BusinessSchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BusinessSchoolCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
