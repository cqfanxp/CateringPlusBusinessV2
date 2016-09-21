//
//  ActivityModel.h
//  CateringPlusBusinessV2  活动对象
//
//  Created by 火爆私厨 on 16/9/14.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "Package.h"

@interface ActivityModel : BaseObject

//活动id
@property(nonatomic,strong) NSString *identifies;
//活动图片
@property(nonatomic,strong) NSString *image;
//门店ids
@property(nonatomic,strong) NSString *storeIds;
//门店列表
@property(nonatomic,strong) NSArray *storeList;
//商户id
@property(nonatomic,strong) NSString *busUserId;
//活动主题
@property(nonatomic,strong) NSString *title;
//活动内容
@property(nonatomic,strong) NSString *content;
//有效期
@property(nonatomic,strong) NSString *limitTime;
//使用限制
@property(nonatomic,strong) NSString *limitations;
//已领次数
@property(nonatomic,assign) long useNumber;
//状态
@property(nonatomic,strong) NSString *stateValue;
//状态编号
@property(nonatomic,strong) NSString *state;
//活动开始时间
@property(nonatomic,strong) NSString *starTime;
//活动结束时间
@property(nonatomic,strong) NSString *overTime;
//优惠价格
@property(nonatomic,strong) NSNumber *price;
//套餐编号
@property(nonatomic,strong) NSString *packageId;
//套餐
@property(nonatomic,strong) NSDictionary *packages;
//折扣比例
@property(nonatomic,strong) NSNumber *discount;
//拼团人数
@property(nonatomic,strong) NSNumber *peoNumber;
//是否有上线
@property(nonatomic,strong) NSNumber *type;
//满
@property(nonatomic,strong) NSNumber *howFull;
//减
@property(nonatomic,strong) NSNumber *howLess;
//上线金额
@property(nonatomic,strong) NSNumber *capAmount;
//设置人数和价格
@property(nonatomic,strong) NSArray *fiendsHelpSpreads;
//设置活动人数(本地数据)
@property(nonatomic,strong) NSArray *settingNumberActivities;
@end
