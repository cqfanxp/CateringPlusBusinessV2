//
//  AppListCell.m
//  HotBusiness
//
//  Created by 火爆私厨 on 16/3/12.
//  Copyright © 2016年 火爆私厨. All rights reserved.
//

#import "AppListCell.h"

@implementation AppListCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    //取出cell，如果复用队列为空，系统自动创建
    AppListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AppListCell" forIndexPath:indexPath];
    
    return cell;
}

@end
