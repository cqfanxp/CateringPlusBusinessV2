//
//  ActivityUrlModel.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/19.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "ActivityUrlModel.h"

@implementation ActivityUrlModel

+(ActivityUrlModel *)initWithFindUrl:(NSString *)findUrl deleteUrl:(NSString *)deleteUrl{
    ActivityUrlModel *model = [ActivityUrlModel new];
    model.findUrl = findUrl;
    model.deleteUrl = deleteUrl;
    return model;
}
@end
