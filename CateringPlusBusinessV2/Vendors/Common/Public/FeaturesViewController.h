//
//  FeaturesViewController.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/22.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"

@interface FeaturesViewController : UIViewController

//功能数据
@property(nonatomic,strong) NSDictionary *featuresData;
//错误层
@property(nonatomic,strong) ImgInfoView *imgInfoView;
//重新加载
-(void)reloadClick;
@end
