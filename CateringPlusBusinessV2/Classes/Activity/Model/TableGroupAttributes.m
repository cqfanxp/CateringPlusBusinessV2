//
//  TableGroupAttributes.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/29.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "TableGroupAttributes.h"

@implementation TableGroupAttributes


-(TableGroupAttributes *)initWithCounts:(NSInteger) counts row:(NSInteger) row{
    if (self = [super init]) {
        self.counts = counts;
        self.row = row;
        if (row == 0) {
            _isFirst = YES;
        }
        if (row == counts-1) {
            _isLast = YES;
        }
    }
    return self;
}

+(TableGroupAttributes *)initWithCounts:(NSInteger) counts row:(NSInteger) row{
    return [[TableGroupAttributes alloc] initWithCounts:counts row:row];
}

@end
