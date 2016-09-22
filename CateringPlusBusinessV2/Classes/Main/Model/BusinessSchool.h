//
//  BusinessSchool.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/22.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface BusinessSchool : BaseObject

@property(nonatomic,strong) NSString *identifies;

@property(nonatomic,strong) NSString *summary;

@property(nonatomic,strong) NSNumber *isLike;

@property(nonatomic,strong) NSString *creationTime;

@property(nonatomic,strong) NSString *title;

@property(nonatomic,strong) NSString *mapUrl;

@property(nonatomic,strong) NSNumber *likeNumber;
@end
