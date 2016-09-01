//
//  Activity_TextCell.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/27.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "Activity_TextCell.h"
#import "PrefixHeader.h"

@implementation Activity_TextCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)cellWithTableView:(UITableView *)tableView tableGroupAttributes:(TableGroupAttributes *) attributes{
    static NSString *ID = @"Activity_Text_Cell";
    Activity_TextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([Activity_TextCell class]) owner:nil options:nil] lastObject];
    }
    cell.attributes = attributes;
    return cell;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    if (_attributes.isFirst) {
        //上分割线，
        CGContextSetStrokeColorWithColor(context, RGB(224, 224, 224).CGColor);
        CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width, 1));
    }else{
        //上分割线，
        CGContextSetStrokeColorWithColor(context, RGB(224, 224, 224).CGColor);
        CGContextStrokeRect(context, CGRectMake(13, -1, rect.size.width, 1));
    }
    
    if (_attributes.isLast) {
        //下分割线
        CGContextSetStrokeColorWithColor(context, RGB(224, 224, 224).CGColor);
        CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
    }
}

@end
