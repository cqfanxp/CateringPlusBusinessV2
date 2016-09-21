//
//  AddHelpCut.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/19.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "AddHelpCut.h"

@implementation AddHelpCut


//取消
- (IBAction)cencelClick:(id)sender {
    self.hidden = YES;
    [self endEditing:YES];
}

//确定
- (IBAction)determineClick:(id)sender {
    [self endEditing:YES];
    if (![self verification]) {
        return;
    }
    HelpCutModel *model = [HelpCutModel new];
    model.price = [NSNumber numberWithDouble:[_priceField.text doubleValue]];
    model.peopleNumber = [NSNumber numberWithDouble:[_numberPeopleField.text intValue]];
    
    self.resultData(model);
    self.hidden = YES;
}
//验证
-(Boolean)verification{
    if ([_priceField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"价格不能为空"];
        return false;
    }
    if ([_numberPeopleField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"人数不能为空"];
        return false;
    }
    return true;
}
@end
