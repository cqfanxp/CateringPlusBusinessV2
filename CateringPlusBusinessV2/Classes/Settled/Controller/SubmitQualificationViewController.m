//
//  SubmitQualificationViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/13.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "SubmitQualificationViewController.h"
#import "MHActionSheet.h"
#import "MSSBrowseDefine.h"
#import "MainViewController.h"

@interface SubmitQualificationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIImageView *_businessLicenseImg;//营业执照（添加）
    UIImageView *_photoIDCardPositiveImg;//身份证正面（添加）
    UIImageView *_photoIDCardRearImg;//身份证背面（添加）
    
    float _imgHeight;//图片高度
    
    int _selectImgTag;//当前选择图片的tag
    
    //营业执照服务器图片路径
    NSString *_businessLicensePath;
    //身份证正面服务器图片路径
    NSString *_photoIDCardPositivePath;
    //身份证背面服务器图片路径
    NSString *_photoIDCardRearPath;
}

@end

@implementation SubmitQualificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self setTitle:@"提交资质"];
    
    //右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"开店手册" style:UIBarButtonItemStyleDone target:self action:@selector(shopmanualBtnClick)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self initLayout];
}

#pragma mark 初始化布局
-(void)initLayout{
    
    _imgHeight = 68-10;
    
    //营业执照图
    _businessLicenseImg = [self getAddImgView:100 num:0];
    [_businessLicenseView addSubview:_businessLicenseImg];
    
    //身份证正面图
    _photoIDCardPositiveImg = [self getAddImgView:200 num:0];
    [_photoIDCard addSubview:_photoIDCardPositiveImg];
    
    //身份证背面图
    _photoIDCardRearImg = [self getAddImgView:300 num:1];
    [_photoIDCard addSubview:_photoIDCardRearImg];
    
}

//上传图片
-(void)uploadImage:(NSData *)imageData type:(NSString *) type{
    
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/businesses/business/uplodStoreImage"] imageData:imageData parameters:[Public getParams:nil] success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"success"] boolValue]) {
            NSString *tempPath = responseObject[@"result"];
            if ([type isEqualToString:@"businessLincense"]) {
                _businessLicensePath = tempPath;
            }else if([type isEqualToString:@"photoIDCardPositive"]){
                _photoIDCardPositivePath = tempPath;
            }else{
                _photoIDCardRearPath = tempPath;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

#pragma mark 获得添加图片按钮
-(UIImageView *)getAddImgView:(int)tag num:(int)num{
    UITapGestureRecognizer *tapAddImgGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImgWay:)];
    
    NSString *imgName = @"dashedBox";
    if (tag == 200) {
        imgName = @"photoIDCardPositive";
    }
    if (tag == 300) {
        imgName = @"photoIDCardRear";
    }
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    imgView.frame = CGRectMake(num*15+_imgHeight*num+15, 10, _imgHeight, _imgHeight-10);
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:tapAddImgGesturRecognizer];
    imgView.tag = tag;
    return imgView;
}

#pragma mark 选择图片
-(void)selectImgWay:(UITapGestureRecognizer *)recognizer{
    [self.view endEditing:YES];
    MHActionSheet *actionSheet = nil;
    
    _selectImgTag = (int)recognizer.view.tag;
    
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
//        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
}

#pragma mark - image picker delegte
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *imgData = UIImagePNGRepresentation(image);
    
    if (_selectImgTag == 100) {
        [_businessLicenseImg removeFromSuperview];
        [_businessLicenseView addSubview:[self generateImg:image num:0]];
        [self uploadImage:imgData type:@"businessLincense"];
    }
    if (_selectImgTag == 200) {
        [_photoIDCardPositiveImg removeFromSuperview];
        [_photoIDCard addSubview:[self generateImg:image num:0]];
        [self uploadImage:imgData type:@"photoIDCardPositive"];
    }
    if (_selectImgTag == 300) {
        [_photoIDCardRearImg removeFromSuperview];
        [_photoIDCard addSubview:[self generateImg:image num:1]];
        [self uploadImage:imgData type:@"photoIDCardRear"];
    }
}

#pragma mark 生成带删除按钮的图片
-(UIView *)generateImg:(UIImage *)img num:(int)num{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(num*15+_imgHeight*num+15, 0, _imgHeight, _imgHeight-10)];
    
    UITapGestureRecognizer *tapPreviewImgGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClickPreview:)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake(0, 10, view.frame.size.width, view.frame.size.height);
    imgView.tag = _selectImgTag+num+1;
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:tapPreviewImgGesturRecognizer];
    [view addSubview:imgView];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, -5, 30, 30)];
    closeBtn.tag = _selectImgTag+num+10;
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(cancelImg:) forControlEvents:UIControlEventTouchUpInside];
    //    [closeBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [view addSubview:closeBtn];
    
    return view;
}

#pragma mark 取消图片
-(void)cancelImg:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    //营业执照
    if (btn.tag < 200) {
        _businessLicenseImg = [self getAddImgView:100 num:0];
        [_businessLicenseView addSubview:_businessLicenseImg];
        [btn.superview removeFromSuperview];
        
        _businessLicensePath = nil;
    }
    
    if (btn.tag > 200 && btn.tag < 300) {
        _photoIDCardPositiveImg = [self getAddImgView:200 num:0];
        [_photoIDCard addSubview:_photoIDCardPositiveImg];
        [btn.superview removeFromSuperview];
        
        _photoIDCardPositivePath = nil;
    }
    
    if (btn.tag > 300) {
        _photoIDCardRearImg = [self getAddImgView:300 num:1];
        [_photoIDCard addSubview:_photoIDCardRearImg];
        [btn.superview removeFromSuperview];
        
        _photoIDCardRearPath = nil;
    }
    
}

#pragma mark 点击图片预览
-(void)imgClickPreview:(UITapGestureRecognizer *)recognizer{
    NSMutableArray *browseItemArray = [[NSMutableArray alloc] init];
    UIImageView *imgView = (UIImageView *)recognizer.view;
    
    MSSBrowseModel *browseItem = [[MSSBrowseModel alloc] init];
    browseItem.bigImage = imgView.image;
    browseItem.smallImageView = imgView;
    [browseItemArray addObject:browseItem];
    
    [self picturePreview:browseItemArray currentIndex:0];
}

#pragma mark 图片预览
-(void)picturePreview:(NSMutableArray *)browseItemArray currentIndex:(int)currentIndex{
    MSSBrowseLocalViewController *bvc = [[MSSBrowseLocalViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:currentIndex];
    [bvc showBrowseViewController];
}

#pragma mark 点击view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //结束编辑
    [self.view endEditing:YES];
}

//开店手册
-(void)shopmanualBtnClick{
    
}

//提交审核
- (IBAction)checkBtnClick:(id)sender {
    if (![self verification]) {
        return;
    }
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   userInfo[@"id"],@"busUserId",
                                   _registrationNumberField.text,@"RegistrationNumber",
                                   _licenseNameField.text,@"LicenseName",
                                   _nameField.text,@"Name",
                                   _iDCardField.text,@"IDCard",
                                   _businessLicensePath,@"BusinessLicensePhoto",
                                   _photoIDCardPositivePath,@"HandheldID",
                                   _photoIDCardRearPath,@"HandheldIDC",
                                   _storeId,@"longStoreId",
                                   nil];
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/businesses/business/updateBusUserByUserId"] parameters:[Public getParams:params] success:^(id responseObject) {
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            MainViewController *mainViwe = [[MainViewController alloc] init];
            [self presentViewController:mainViwe animated:YES completion:nil];
        }else{
            [Public alertWithType:MozAlertTypeError msg:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [hud dismiss:YES];
        NSLog(@"error:%@",error);
    }];
}

//验证
-(Boolean)verification{
    if ([_registrationNumberField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"注册号不能为空"];
        return false;
    }
    if ([_licenseNameField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"执照名称不能为空"];
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
        [Public alertWithType:MozAlertTypeError msg:@"身份证号码格式不正确"];
        return false;
    }
    if (_businessLicensePath == nil) {
        [Public alertWithType:MozAlertTypeError msg:@"请上传营业执照"];
        return false;
    }
    if (_photoIDCardPositivePath == nil) {
        [Public alertWithType:MozAlertTypeError msg:@"请上传身份证正面图"];
        return false;
    }
    if (_photoIDCardRearPath == nil) {
        [Public alertWithType:MozAlertTypeError msg:@"请上传身份证背面图"];
        return false;
    }
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
