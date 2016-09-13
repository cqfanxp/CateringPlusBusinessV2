//
//  XMRTimePiker.h
//  CateringPlusBusinessV2  时间选择器
//
//  Created by 火爆私厨 on 16/9/8.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMRTimePikerDelegate <NSObject>

- (void)XMSelectTimesViewSetOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight andTowLeft:(NSString *)towLeft andTowRight:(NSString *)towRight;

@end

@interface XMRTimePiker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,weak)id <XMRTimePikerDelegate> delegate;

-(void)showTime;

- (void)SetOldShowTimeOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight andTowLeft:(NSString *)towLeft andTowRight:(NSString *)towRight;

@end
