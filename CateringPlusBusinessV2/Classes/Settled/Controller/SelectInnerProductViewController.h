//
//  SelectInnerProductViewController.h
//  CateringPlusBusinessV2  选择品内
//
//  Created by 火爆私厨 on 16/8/15.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.h"

typedef void(^innerProductResult)(NSDictionary *dic);

@interface SelectInnerProductViewController : BaseViewController

#pragma mark 品内
@property (weak, nonatomic) IBOutlet UITableView *innerProductTableView;

#pragma mark 子级
@property (weak, nonatomic) IBOutlet UITableView *childTableView;
//是否有返回值
@property(nonatomic,assign) Boolean isResult;
//返回值
@property(nonatomic,strong) innerProductResult result;
@end
