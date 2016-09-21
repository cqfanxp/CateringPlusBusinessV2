//
//  ActivityPrice.h
//  CateringPlusBusinessV2  活动价格
//
//  Created by 火爆私厨 on 16/9/18.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityPrice : NSObject

//是否有上线
@property(nonatomic,strong) NSNumber *type;
//满
@property(nonatomic,strong) NSNumber *howFull;
//减
@property(nonatomic,strong) NSNumber *howLess;
//上线金额
@property(nonatomic,strong) NSNumber *capAmount;

+(ActivityPrice *)initWithType:(NSNumber *)type howFull:(NSNumber *)howFull howLess:(NSNumber *)howLess capAmount:(NSNumber *)capAmount;

@end
