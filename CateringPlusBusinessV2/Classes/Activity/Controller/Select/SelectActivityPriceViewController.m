//
//  SelectActivityPriceViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/18.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "SelectActivityPriceViewController.h"
#import "PrefixHeader.h"

@interface SelectActivityPriceViewController ()

@end

@implementation SelectActivityPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
//    //右侧按钮
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(determineClick)];
//    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self setTitle:@"活动价格"];
    
    [self initLayout];
}

-(void)initLayout{
    if (_activityProce) {
        _totalAmountField.text = [_activityProce.howFull stringValue];
        _discountedPriceField.text = [_activityProce.howLess stringValue];
        _onlineMondyField.text = [_activityProce.capAmount stringValue];
        
        [_upperLimitSwitch setOn:[_activityProce.type boolValue] animated:YES];
        
        _onlineMondyView.hidden = ![_activityProce.type boolValue];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//确定
//-(void)determineClick{
//    
//}

//显示或隐藏金额
- (IBAction)isHiddenPicer:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    _onlineMondyView.hidden = !isButtonOn;

}

- (IBAction)determineClick:(id)sender {
    [self.view endEditing:YES];
    if (![self verification]) {
        return;
    }
    ActivityPrice *item = [ActivityPrice initWithType:[NSNumber numberWithBool:_upperLimitSwitch.isOn]
                                              howFull:[NSNumber numberWithDouble:[_totalAmountField.text doubleValue]]
                                              howLess:[NSNumber numberWithDouble:[_discountedPriceField.text doubleValue]]
                                            capAmount:[NSNumber numberWithDouble:[_onlineMondyField.text floatValue]]];
    
    self.resultData(item);
    [self.navigationController popViewControllerAnimated:YES];
}

//验证
-(Boolean)verification{
    if ([_totalAmountField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"满金额不能为空"];
        return false;
    }
    if ([_discountedPriceField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"减金额不能为空"];
        return false;
    }
    if ([_upperLimitSwitch isOn] && [_onlineMondyField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"上限金额不能为空"];
        return false;
    }
    return true;
}

-(ActivityPrice *)activityProce{
    if (!_activityProce) {
        _activityProce = [[ActivityPrice alloc] init];
    }
    return _activityProce;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
