//
//  SelectInnerProductCell.h
//  CateringPlusBusinessV2  选择品内Cell
//
//  Created by 火爆私厨 on 16/8/15.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectInnerProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *text;

- (instancetype)cellWithTableView:(UITableView *)tableView text:(NSString *)text;
@end
