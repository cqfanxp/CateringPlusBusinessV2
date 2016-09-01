//
//  TableGroupAttributes.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/29.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableGroupAttributes : NSObject
//总行数
@property(nonatomic,assign) NSInteger counts;
//当前条数
@property(nonatomic,assign) NSInteger row;
//是否第一条
@property(nonatomic,assign) Boolean isFirst;
//是否最后一条
@property(nonatomic,assign) Boolean isLast;

-(TableGroupAttributes *)initWithCounts:(NSInteger) counts row:(NSInteger) row;

+(TableGroupAttributes *)initWithCounts:(NSInteger) counts row:(NSInteger) row;
@end
