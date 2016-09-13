//
//  EditSingleProductViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/31.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "EditSingleProductViewController.h"
#import "PrefixHeader.h"

@interface EditSingleProductViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSString *_singleImgPath;//图片服务器地址
}

@end

@implementation EditSingleProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setTitle:@"编辑单品"];
    
    [self initLayout];
}

-(void)initLayout{
    //商品首图
    UITapGestureRecognizer *tapAddImgGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImgWay:)];
    _singleFirstMapImgView.tag = 100;
    _singleFirstMapImgView.userInteractionEnabled = YES;
    [_singleFirstMapImgView addGestureRecognizer:tapAddImgGesturRecognizer];
}

#pragma mark 选择图片
-(void)selectImgWay:(UITapGestureRecognizer *)recognizer{
    [self.view endEditing:YES];
    MHActionSheet *actionSheet = nil;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        actionSheet = [[MHActionSheet alloc] initSheetWithTitle:nil style:MHSheetStyleDefault itemTitles:@[@"拍照",@"从相册选择"]];
    }
    else {
        actionSheet = [[MHActionSheet alloc] initSheetWithTitle:nil style:MHSheetStyleDefault itemTitles:@[@"从相册选择"]];
    }
    
    [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if ([title isEqualToString:@"拍照"]) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        if ([title isEqualToString:@"从相册选择"]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
}

//处理后的图片
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *imgData = UIImagePNGRepresentation(image);
    
    //上传图片
    [self uploadImage:imgData];
    
}
//上传图片
-(void)uploadImage:(NSData *)imageData{
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/businesses/business/uplodStoreImage"] imageData:imageData parameters:[Public getParams:nil] success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            _singleImgPath = responseObject[@"result"];
            [_singleFirstMapImgView sd_setImageWithURL:[NSURL URLWithString:[BASEURL stringByAppendingString:_singleImgPath]] placeholderImage:[UIImage imageNamed:@"img_false"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        [hud dismiss:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//保存
- (IBAction)saveClick:(id)sender {
    [self.view endEditing:YES];
    if (![self verification]) {
        return;
    }
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    
    if (_singleImgPath == nil) {
        _singleImgPath = @"";
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   userInfo[@"id"],@"busUserId",
                                   _singleImgPath,@"singleFirstMap",
                                   _unitField.text,@"unit",
                                   _singleNameField.text,@"singleName",
                                   nil];
    
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/packages/singleProduct/insertSingle"] parameters:[Public getParams:params] success:^(id responseObject) {
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            self.addSuccess(YES);
            [Public alertWithType:MozAlertTypeSuccess msg:responseObject[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
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
//验证
-(Boolean)verification{
    if ([_singleNameField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"单品名称不能为空"];
        return false;
    }
    if ([_unitField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"单位不能为空"];
        return false;
    }
    return true;
}
@end
