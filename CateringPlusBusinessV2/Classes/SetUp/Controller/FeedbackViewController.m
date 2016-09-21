//
//  FeedbackViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/1.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "FeedbackViewController.h"
#import "PrefixHeader.h"

@interface FeedbackViewController ()<UITextViewDelegate>

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"意见反馈"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _adviceTextView.delegate = self;
    
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    if (userInfo) {
        _telephoneText.text = userInfo[@"phone"];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(![text isEqualToString:@""])
    {
        [_bgTextView setHidden:YES];
    }
    if([text isEqualToString:@""]&&range.length==1&&range.location==0){
        [_bgTextView setHidden:NO];
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


//验证
-(Boolean)verification{
    if ([_adviceTextView.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"请输入反馈意见"];
        return false;
    }
    if ([_telephoneText.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"请输入手机号码"];
        return false;
    }
    if (![Verification checkTelNumber:_telephoneText.text]) {
        [Public alertWithType:MozAlertTypeError msg:@"手机号码格式不正确"];
        return false;
    }
    return true;
}
//提交
- (IBAction)submitClick:(id)sender {
    [self.view endEditing:YES];
    if (![self verification]) {
        return;
    }
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   userInfo[@"id"],@"userId",
                                   _adviceTextView.text,@"advice",
                                   _telephoneText.text,@"telePhone",
                                   @"10111001",@"feedBackType",
                                   nil];

    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/ourselves/mySelf/insertFeedback"] parameters:[Public getParams:params] success:^(id responseObject) {
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            [self.navigationController popViewControllerAnimated:YES];
            [Public alertWithType:MozAlertTypeSuccess msg:@"我们会尽快处理你的意见"];
        }else{
            NSLog(@"message:%@",responseObject[@"message"]);
            [Public alertWithType:MozAlertTypeError msg:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [hud dismiss:YES];
        NSLog(@"error:%@",error);
        [Public alertWithType:MozAlertTypeError msg:[NSString stringWithFormat:@"%@",error]];
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
