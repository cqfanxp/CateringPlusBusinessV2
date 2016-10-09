//
//  HomeViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/18.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "HomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PrefixHeader.h"
#import "AppListCell.h"
#import "QRCodeController.h"
#import "StoreManagementViewController.h"
#import "FeaturesViewController.h"

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    //应用数据
    NSMutableArray *_appData;
    //权限控制后的数据
    NSMutableArray *_comPetenceData;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    _appCollectionView.delegate = self;
    _appCollectionView.dataSource = self;
    
    //注册Cell
    [_appCollectionView registerNib:[UINib nibWithNibName:@"AppListCell" bundle:nil] forCellWithReuseIdentifier:@"AppListCell"];
    
    [self initData];
    
    //获取当天验证总数
    [self getOrderByValidateSuccess];
    
    //注册键盘消失的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark 初始化数据
-(void)initData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //获得所有应用数据
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"menu_app" ofType:@"plist"];
        _appData = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        _comPetenceData = _appData;
        
        //权限
        //        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //        NSDictionary *userInfo = [defaults objectForKey:USERINFO];
        //        for (NSDictionary *item in _appData) {
        //
        //            if ([item[@"Competence"] rangeOfString:userInfo[@"BussinessType"]].location != NSNotFound) {
        //                [_comPetenceData addObject:item];
        //            }
        //        }
        
        //排序
        [_comPetenceData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1[@"sequence"] floatValue] > [obj2[@"sequence"] floatValue];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_appCollectionView reloadData];
        });
    });
    
}

#pragma mark 扫描验证
- (IBAction)scanValidationClick:(id)sender {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusDenied){
        if (IS_VAILABLE_IOS8) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相机权限受限" message:@"请在iPhone的\"设置->隐私->相机\"选项中,允许\"自游邦\"访问您的相机." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([self canOpenSystemSettingView]) {
                    [self systemSettingView];
                }
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"相机权限受限" message:@"请在iPhone的\"设置->隐私->相机\"选项中,允许\"自游邦\"访问您的相机." delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
            [alert show];
        }
        
        return;
    }
    
    QRCodeController *qrcodeVC = [[QRCodeController alloc] init];
    qrcodeVC.view.alpha = 1;
    [qrcodeVC setDidReceiveBlock:^(NSString *result) {
//        [self submitVerification:result];
        [self VerificationCode:result];
    }];
    [self.navigationController pushViewController:qrcodeVC animated:YES];

}

/**
 *  是否可以打开设置页面
 *
 *  @return
 */
- (BOOL)canOpenSystemSettingView {
    if (IS_VAILABLE_IOS8) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

/**
 *  跳到系统设置页面
 */
- (void)systemSettingView {
    if (IS_VAILABLE_IOS8) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark 验证记录
- (IBAction)verificationRecordsClick:(id)sender {
    UIViewController *viewController = [Public getStoryBoardByController:@"Statistics" storyboardId:@"VerificationRecordsViewController"];

    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark 重写UICollectionView 方法
#pragma mark 返回每个分组的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_comPetenceData count];
}
//#pragma mark 返回分组数
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}

#pragma mark 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(screen_width/3-0.5, screen_width/3-12);
}

//#pragma mark 定义每个UICollectionView 的 分组margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}


#pragma mark 返回Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item  = [_comPetenceData objectAtIndex:indexPath.row];
    
    AppListCell *cell = [AppListCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.nameLabel.text = item[@"name"];
    cell.iconImg.image = [UIImage imageNamed:item[@"icon"]];
    return cell;
}

#pragma mark 选中 跳转
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item  = [_comPetenceData objectAtIndex:indexPath.row];
    
    if (item[@"isStoryboard"]) {
      FeaturesViewController *viewController = (FeaturesViewController *)[Public getStoryBoardByController:item[@"storyboard"] storyboardId:item[@"storyboardId"]];
      [viewController setTitle:item[@"name"]];
        viewController.featuresData = item;
      [self.navigationController pushViewController:viewController animated:YES];
    }
}

//查询用户当天验证订单的条数
-(void)getOrderByValidateSuccess{
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  userInfo[@"id"],@"BusUserId",nil];
    
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/orders/order/getOrderByValidateSuccess"] parameters:[Public getParams:param] success:^(id responseObject) {
        
        if ([responseObject[@"success"] boolValue]) {
            _tipLabel.text = [NSString stringWithFormat:@"提醒：今日已完成%@个订单验证",responseObject[@"result"]];
        }else{
            NSLog(@"message:%@",responseObject[@"message"]);
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

//键盘隐藏时
-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSString *code = _codeField.text;
    if (![code isEqualToString:@""]) {
        [self VerificationCode:code];
    }
}

//验证用户订单
-(void)VerificationCode:(NSString *)code{
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   code,@"code",
                                   userInfo[@"id"],@"busUserId",
                                   nil];
    
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/orders/order/validateOrder"] parameters:[Public getParams:params] success:^(id responseObject) {
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            [Public alertWithType:MozAlertTypeSuccess msg:responseObject[@"message"]];
            if (![_codeField.text isEqualToString:@""]) {
                _codeField.text = @"";
            }
        }else{
            NSLog(@"message:%@",responseObject[@"message"]);
            [Public alertWithType:MozAlertTypeError msg:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [hud dismiss:YES];
        NSLog(@"error:%@",error);
        [Public alertWithType:MozAlertTypeError msg:@"订单验证错误"];
    }];

}

@end
