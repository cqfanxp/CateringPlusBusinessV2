//
//  Activity_ImgCell.h
//  CateringPlusBusinessV2  活动图片
//
//  Created by 火爆私厨 on 16/8/23.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Activity_ImgCell : UITableViewCell

- (instancetype)cellWithTableView:(UITableView *)tableView;

//活动图片
@property (weak, nonatomic) IBOutlet UIImageView *activityImgView;

@end
