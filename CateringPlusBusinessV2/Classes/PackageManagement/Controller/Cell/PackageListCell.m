//
//  PackageListCell.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/22.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "PackageListCell.h"

@implementation PackageListCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)cellWithTableView:(UITableView *)tableView text:(NSString *)text{
    static NSString *ID = @"PackageList_Cell";
    PackageListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PackageListCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
