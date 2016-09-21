//
//  Activity_ButtonCell.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/29.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Activity_ButtonCell : UITableViewCell

- (instancetype)cellWithTableView:(UITableView *)tableView;

//提交
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end
