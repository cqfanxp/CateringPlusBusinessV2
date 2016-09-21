//
//  ActivityDisplayField.h
//  CateringPlusBusinessV2  活动展示属性对象
//
//  Created by 火爆私厨 on 16/9/14.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface ActivityDisplayField : BaseObject

//label文字
@property(nonatomic,strong) NSString *labelText;

//类型 1、img  2、select    3、text
@property(nonatomic,strong) NSString *type;

//显示值
@property(nonatomic,strong) NSString *value;

//对应的键
@property(nonatomic,strong) NSString *key;

//提示文字
@property(nonatomic,strong) NSString *placeholder;

//选择框类型
//selectStores = 选择门店
//selectPackage = 选择套餐
//selectHtmlContent = html文本框
//selectMissionFight = 拼团选择人数价格
//selectStartAndEndTime = 选择开始时间和结束时间
//selectDate = 选择时间
//selectActivityPrice = 选择活动价格
@property(nonatomic,strong) NSString *selectType;

@end
