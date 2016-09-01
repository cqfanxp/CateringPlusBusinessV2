//
//  ChooseSingleProductViewController.h
//  CateringPlusBusinessV2  选择单品
//
//  Created by 火爆私厨 on 16/8/30.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseSingleProductViewController : UIViewController

//商品TableView
@property (weak, nonatomic) IBOutlet UITableView *commodityTableView;

//已选TableView
@property (weak, nonatomic) IBOutlet UITableView *shoppingCartTableView;

//商品已选列表高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopingHeight;

//商品已选容器
@property (weak, nonatomic) IBOutlet UIView *shoppingView;

//商品已选容器(商品)
@property (weak, nonatomic) IBOutlet UIView *shoppingChileView;
@end
