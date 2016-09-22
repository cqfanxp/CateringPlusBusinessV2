//
//  BusinessSchoolCell.h
//  CateringPlusBusinessV2  生意经Cell
//
//  Created by 火爆私厨 on 16/8/19.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessSchoolCell : UITableViewCell

//图片
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//摘要
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

//点赞
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

//分享
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

//点赞的次数
@property (weak, nonatomic) IBOutlet UILabel *shareNumberLabel;

//点赞图片
@property (weak, nonatomic) IBOutlet UIImageView *likeImgView;


- (instancetype)cellWithTableView:(UITableView *)tableView text:(NSString *)text;

@end
