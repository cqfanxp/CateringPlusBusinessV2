//
//  SelectStartAndEndTimeViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/14.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "SelectStartAndEndTimeViewController.h"
#import "HcdDateTimePickerView.h"

@interface SelectStartAndEndTimeViewController (){
    HcdDateTimePickerView * dateTimePickerView;
}

@end

@implementation SelectStartAndEndTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"活动时间"];
    
    //右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(determineClick)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

//确定
-(void)determineClick{
    if (![self verification]) {
        return;
    }
    self.resultData(_startField.text,_endField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

//验证
-(Boolean)verification{
    if ([_startField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"请选择开始时间"];
        return false;
    }
    if ([_endField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"请选择结束时间"];
        return false;
    }
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//选择开始时间
- (IBAction)selectStartDateClick:(id)sender {
    [self selectDate:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] dateField:_startField];
}
//选择结束时间
- (IBAction)selectEndDateClick:(id)sender {
    [self selectDate:[[NSDate alloc]initWithTimeIntervalSinceNow:1000] dateField:_endField];
}

//选择时间
-(void)selectDate:(NSDate *)date dateField:(UITextField *)dateField{
    dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateHourMinuteMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]];
    dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
        NSLog(@"%@", datetimeStr);
        dateField.text = datetimeStr;
    };
    [self.view addSubview:dateTimePickerView];
    [dateTimePickerView showHcdDateTimePicker];
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
