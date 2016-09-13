//
//  EntityHelper.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/9.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntityHelper : NSObject

//字典对象转为实体对象
+ (void) dictionaryToEntity:(NSDictionary *)dict entity:(NSObject*)entity;

//实体对象转为字典对象
+(NSDictionary *) entityToDictionary:(id)entity;

@end
