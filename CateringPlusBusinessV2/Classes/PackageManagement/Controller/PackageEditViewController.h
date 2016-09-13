//
//  PackageEditViewController.h
//  CateringPlusBusinessV2  编辑套餐
//
//  Created by 火爆私厨 on 16/8/22.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"
#import "Package.h"

@interface PackageEditViewController : UIViewController

//商品首图
@property (weak, nonatomic) IBOutlet UIImageView *firstMapImgView;
//详情图
@property (weak, nonatomic) IBOutlet UIScrollView *fIGDetailsScroll;
//经营品类
//@property (weak, nonatomic) IBOutlet UITextField *categoryField;
//套餐名称
@property (weak, nonatomic) IBOutlet UITextField *packageName;
//套餐内容
@property (weak, nonatomic) IBOutlet UITextField *packageContent;

//套餐信息
@property(nonatomic,strong) Package *package;

@property(nonatomic,strong) void(^saveSuccess)(Boolean success);
@end
