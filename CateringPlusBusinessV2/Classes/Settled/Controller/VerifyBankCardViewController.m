//
//  VerifyBankCardViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/6.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "VerifyBankCardViewController.h"
#import "SelectBankViewController.h"
#import "PrefixHeader.h"

@interface VerifyBankCardViewController ()<SelectBankDelegate>{
    NSDictionary *_bankInfo;//银行信息
}

@end

@implementation VerifyBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setTitle:@"验证银行卡"];
}

//选择银行卡
- (IBAction)selectBankClick:(id)sender {
    SelectBankViewController *selectBank = (SelectBankViewController *)[Public getStoryBoardByController:@"Settled" storyboardId:@"SelectBankViewController"];;
    selectBank.delegate = self;
    [self.navigationController pushViewController:selectBank animated:YES];
}
//返回银行卡信息
-(void)selectBankResult:(NSDictionary *)dic{
    _bankInfo = dic;
    _bankTypeField.text = _bankInfo[@"bankIntro"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//发送验证码
- (IBAction)sendVerificationBtn:(id)sender {
    if (![self verification]) {
        return;
    }
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  _bankNumField.text,@"BankICardID",
                                  _bankInfo[@"bankType"],@"BankType",
                                  _bankInfo[@"lineNumber"],@"LineNumber",
                                  _bankInfo[@"bankIntro"],@"BankName",
                                  _phoneNumField.text,@"Phone",
                                  _nameField.text,@"Name",
                                  _iDCardField.text,@"IDCard",
                                  userInfo[@"id"],@"BusUserId",nil];
    
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/publics/public/validateBankCard"] parameters:[Public getParams:param] success:^(id responseObject) {
        NSLog(@"responseObject：%@",responseObject);
        if ([responseObject[@"success"] boolValue]) {

        }else{
            [Public alertWithType:MozAlertTypeError msg:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}
//下一步
- (IBAction)nextBtn:(id)sender {
    
}

//验证
-(Boolean)verification{
    if ([_bankTypeField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"请选择银行卡类型"];
        return false;
    }
    if ([_bankNumField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"卡号不能为空"];
        return false;
    }
    if ([_nameField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"姓名不能为空"];
        return false;
    }
    if ([_iDCardField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"身份证不能为空"];
        return false;
    }
    if (![Verification checkUserIdCard:_iDCardField.text]) {
        [Public alertWithType:MozAlertTypeError msg:@"身份证格式不正确"];
        return false;
    }
    if ([_phoneNumField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"手机号码不能为空"];
        return false;
    }
    if (![Verification checkTelNumber:_phoneNumField.text]) {
        [Public alertWithType:MozAlertTypeError msg:@"手机号码格式不正确"];
        return false;
    }
    return true;
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
