//
//  ActivityPrice.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/18.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "ActivityPrice.h"

@implementation ActivityPrice

+(ActivityPrice *)initWithType:(NSNumber *)type howFull:(NSNumber *)howFull howLess:(NSNumber *)howLess capAmount:(NSNumber *)capAmount{
    ActivityPrice *item = [[ActivityPrice alloc] init];
    item.type = type;
    item.howFull = howFull;
    item.howLess = howLess;
    item.capAmount = capAmount;
    return item;
}
@end
