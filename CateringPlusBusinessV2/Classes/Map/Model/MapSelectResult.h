//
//  MapSelectResult.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/6.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MapSelectResult : NSObject
//名称
@property(nonatomic,strong) NSString *name;
//地址
@property(nonatomic,strong) NSString *address;
 //!< 纬度（垂直方向）
@property (nonatomic, assign) CGFloat latitude;
//!< 经度（水平方向）
@property (nonatomic, assign) CGFloat longitude;
//所属区域
@property(nonatomic,strong) NSString *district;

-(MapSelectResult *)initResultWithName:(NSString *)name address:(NSString *)address latitude:(CGFloat)latitude longitude:(CGFloat)longitude district:(NSString *)district;
@end
