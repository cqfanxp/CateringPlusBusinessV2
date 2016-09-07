//
//  MapViewController.h
//  CateringPlusBusinessV2  高德地图
//
//  Created by 火爆私厨 on 16/9/5.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "PrefixHeader.h"
#import "POIAnnotation.h"
#import "MapPOIAddressCell.h"
#import "MTSearchBar.h"
#import "MapSelectResult.h"

@protocol MapViewDelegate <NSObject>

//选择的地址
-(void)selectAddress:(MapSelectResult *) mapSelectResult;

@end

@interface MapViewController : UIViewController<AMapLocationManagerDelegate,MAMapViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

//地图
@property(nonatomic,strong) MAMapView *mapView;

//定位
@property(nonatomic,strong) AMapLocationManager *locationManager;

//数据检索
@property(nonatomic,strong) AMapSearchAPI *search;

//当前位置数据
@property(nonatomic,strong) UITableView *currentTableView;

//搜索数据
@property(nonatomic,strong) UITableView *searchTableView;

//代理
@property(nonatomic,strong) id<MapViewDelegate> delegate;
@end
