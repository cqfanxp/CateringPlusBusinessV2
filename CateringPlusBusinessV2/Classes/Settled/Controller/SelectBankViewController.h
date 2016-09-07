//
//  SelectBankViewController.h
//  CateringPlusBusinessV2  选择银行
//
//  Created by 火爆私厨 on 16/9/6.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectBankDelegate <NSObject>

-(void)selectBankResult:(NSDictionary *)dic;

@end

@interface SelectBankViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) id<SelectBankDelegate> delegate;
@end
