//
//  AddHelpCut.h
//  CateringPlusBusinessV2  添加人数和价格
//
//  Created by 火爆私厨 on 16/9/19.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpCutModel.h"
#import "PrefixHeader.h"

@interface AddHelpCut : UIView


@property (weak, nonatomic) IBOutlet UITextField *priceField;

@property (weak, nonatomic) IBOutlet UITextField *numberPeopleField;

@property(nonatomic,strong) void(^resultData)(HelpCutModel *helpCutModel);
@end
