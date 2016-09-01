//
//  Activity_ButtonCell.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/29.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "Activity_ButtonCell.h"

@implementation Activity_ButtonCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"Activity_Button_Cell";
    Activity_ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([Activity_ButtonCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
