//
//  Activity_ImgCell.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/23.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "Activity_ImgCell.h"

@implementation Activity_ImgCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"Activity_Img_Cell";
    Activity_ImgCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([Activity_ImgCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

@end
