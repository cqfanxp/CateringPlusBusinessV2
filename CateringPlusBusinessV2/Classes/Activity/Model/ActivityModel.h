//
//  ActivityModel.h
//  CateringPlusBusinessV2  活动对象
//
//  Created by 火爆私厨 on 16/9/14.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface ActivityModel : BaseObject

//活动图片
@property(nonatomic,strong) NSString *image;

@property(nonatomic,strong) NSString *storeIds;

@end
