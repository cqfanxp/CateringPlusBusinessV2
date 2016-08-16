//
//  ImproveStoreInformationViewController.h
//  CateringPlusBusinessV2  完善门店信息
//
//  Created by 火爆私厨 on 16/8/11.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"

@interface ImproveStoreInformationViewController : BaseViewController

#pragma mark 门店图
@property (weak, nonatomic) IBOutlet UIScrollView *storesScroll;

#pragma mark 环境图
@property (weak, nonatomic) IBOutlet UIScrollView *surroundingsScroll;
@end
