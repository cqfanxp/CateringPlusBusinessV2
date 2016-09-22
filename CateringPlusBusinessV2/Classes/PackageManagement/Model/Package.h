//
//  Package.h
//  CateringPlusBusinessV2  套餐
//
//  Created by 火爆私厨 on 16/9/12.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface Package : BaseObject

//套餐名称
@property(nonatomic,strong) NSString *packageName;
//首图
@property(nonatomic,strong) NSString *packageFirstMap;
//唯一标示
@property(nonatomic,strong) NSString *identifies;
//详情图
@property(nonatomic,strong) NSArray *accessories;
//套餐内容
@property(nonatomic,strong) NSArray *packageToSingleProducts;

//是否被选中
@property(nonatomic,assign) Boolean isSelect;
@end
