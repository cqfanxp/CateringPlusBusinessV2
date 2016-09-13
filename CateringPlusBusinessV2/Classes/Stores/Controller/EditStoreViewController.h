//
//  EditStoreViewController.h
//  CateringPlusBusinessV2  编辑门店信息
//
//  Created by 火爆私厨 on 16/9/1.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stoer.h"

typedef void(^addStoerSuccess)(Boolean success);

@interface EditStoreViewController : UIViewController

//门店数据
//@property(nonatomic,strong) NSDictionary *_storesData;

//门店名称
@property (weak, nonatomic) IBOutlet UITextField *storeNameField;

//经营品类
@property (weak, nonatomic) IBOutlet UITextField *businessCategoryField;

//经营时间
@property (weak, nonatomic) IBOutlet UITextField *businessHoursField;

//主要电话
@property (weak, nonatomic) IBOutlet UITextField *mainPhoneField;

//其它电话
@property (weak, nonatomic) IBOutlet UITextField *otherPhoneField;

//门店地址
@property (weak, nonatomic) IBOutlet UITextField *storeAddressField;

//门店图
@property (weak, nonatomic) IBOutlet UIScrollView *storesScroll;

//环境图
@property (weak, nonatomic) IBOutlet UIScrollView *surroundingsScroll;

@property(nonatomic,strong) Stoer *store;

@property(nonatomic,strong) addStoerSuccess addSuccess;
@end
