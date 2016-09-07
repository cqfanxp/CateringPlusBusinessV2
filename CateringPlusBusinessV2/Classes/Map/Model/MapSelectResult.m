//
//  MapSelectResult.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/6.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "MapSelectResult.h"

@implementation MapSelectResult

-(MapSelectResult *)initResultWithName:(NSString *)name address:(NSString *)address latitude:(CGFloat)latitude longitude:(CGFloat)longitude district:(NSString *)district{
    
    if (self = [super init]) {
        self.name = name;
        self.address = address;
        self.latitude = latitude;
        self.longitude = longitude;
        self.district = district;
    }
    return self;
}
@end
