//
//  ActivityUrlModel.h
//  CateringPlusBusinessV2  活动操作地址
//
//  Created by 火爆私厨 on 16/9/19.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityUrlModel : NSObject

@property(nonatomic,strong) NSString *findUrl;

@property(nonatomic,strong) NSString *deleteUrl;

@property(nonatomic,strong) NSString *modifyUrl;

+(ActivityUrlModel *)initWithFindUrl:(NSString *)findUrl deleteUrl:(NSString *)deleteUrl;
@end
