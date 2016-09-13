//
//  Commodity.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/12.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface Commodity : BaseObject

//唯一标示
@property(nonatomic,strong) NSString *identifies;

//图片路径
@property(nonatomic,strong) NSString *singleFirstMapPath;
//单位
@property(nonatomic,strong) NSString *unit;
//商品名称
@property(nonatomic,strong) NSString *singleName;

//是否选中
@property(nonatomic,assign) Boolean isCheck;

//数量
@property(nonatomic,assign) int number;
@end
