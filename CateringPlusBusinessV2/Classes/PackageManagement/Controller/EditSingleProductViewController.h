//
//  EditSingleProductViewController.h
//  CateringPlusBusinessV2  编辑单品
//
//  Created by 火爆私厨 on 16/8/31.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^addStoerSuccess)(Boolean success);

@interface EditSingleProductViewController : UIViewController

//图片
@property (weak, nonatomic) IBOutlet UIImageView *singleFirstMapImgView;
//单位
@property (weak, nonatomic) IBOutlet UITextField *unitField;
//名称
@property (weak, nonatomic) IBOutlet UITextField *singleNameField;

@property(nonatomic,strong) addStoerSuccess addSuccess;
@end
