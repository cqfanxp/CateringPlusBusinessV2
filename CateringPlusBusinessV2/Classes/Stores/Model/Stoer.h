//
//  Stoer.h
//  CateringPlusBusinessV2  门店
//
//  Created by 火爆私厨 on 16/9/8.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseObject.h"

@interface Stoer : BaseObject
//门店id
@property(nonatomic,strong) NSString *storeId;
// 行业id
@property(nonatomic,strong) NSString *industryId;
//行业名称
@property(nonatomic,strong) NSString *industry;
// 商家用户id
@property(nonatomic,strong) NSString *busUserId;
// 商家名称
@property(nonatomic,strong) NSString *busName;
// 营业时间开始时间
@property(nonatomic,strong) NSString *hoursStart;
// 营业时间结束时间
@property(nonatomic,strong) NSString *hoursOver;
// 主要电话
@property(nonatomic,strong) NSString *mainPhone;
// 其他电话
@property(nonatomic,strong) NSString *otherPhone;
// 门店地址
@property(nonatomic,strong) NSString *storeAddress;
// 门店首图
@property(nonatomic,strong) NSString *storeFirstMap;
// 环境图
@property(nonatomic,strong) NSString *environmentMap;
// 纬度
@property(nonatomic,assign) CGFloat latitude;
// 经度
@property(nonatomic,assign) CGFloat longitude;
// 所属区域
@property(nonatomic,strong) NSString *district;
//附件
@property(nonatomic,strong) NSArray *accessory;
//状态（dic）
@property(nonatomic,strong) NSString *busStateDic;
//状态（str）
@property(nonatomic,strong) NSString *busStateValue;
//门店首图
@property(nonatomic,strong) NSString *picture;

//是否被选中
@property(nonatomic,assign) Boolean isSelect;
@end
