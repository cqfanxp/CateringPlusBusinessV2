//
//  AppListCell.h
//  HotBusiness
//
//  Created by 火爆私厨 on 16/3/12.
//  Copyright © 2016年 火爆私厨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppListCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

/** 便利构造方法 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end
