//
//  EditStoreViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/1.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "EditStoreViewController.h"
#import "MapViewController.h"
#import "MSSBrowseDefine.h"
#import "PrefixHeader.h"
#import "SelectInnerProductViewController.h"
#import "XMRTimePiker.h"

@interface EditStoreViewController ()<MapViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XMRTimePikerDelegate>{
    //图片数据
    NSMutableArray *_storesList;//门店图
    NSMutableArray *_surroundingsList;//环境图
    
    //营业时间oneLeft,oneRight,towLeft,towRight
    NSString *_oneLeft;//开始小时
    NSString *_oneRight;//开始分钟
    NSString *_towLeft;//结算小时
    NSString *_towRight;//结算分钟
    
    float _imgHeight;//图片高度
    NSInteger _tempTag;//临时tag
}

@end

@implementation EditStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setTitle:@"编辑门店"];
    
    [self initLayout];
    
    //更新图片信息
    [self updateImage];
}
#pragma mark 初始化布局
-(void)initLayout{
    _imgHeight = _storesScroll.frame.size.height-10;
    
    //初始化集合
    _storesList = [[NSMutableArray alloc] init];
    _surroundingsList = [[NSMutableArray alloc] init];
    
    if (_store) {
        _storeNameField.text = _store.busName;
        _businessHoursField.text = [NSString stringWithFormat:@"%@ - %@",_store.hoursStart,_store.hoursOver];
        _mainPhoneField.text = _store.mainPhone;
        _otherPhoneField.text = _store.otherPhone;
        _storeAddressField.text = _store.storeAddress;
        _businessCategoryField.text = _store.industry;
        
        //加载门店首图
        [_storesList addObject:_store.picture];
        //加载环境图
        if (_store.accessory != nil) {
            for (NSDictionary *dic in _store.accessory) {
                [_surroundingsList addObject:dic[@"filePath"]];
            }
        }
    }
    
}

//更新图片信息
-(void)updateImage{
    [self removeChildView:_storesScroll];
    [self removeChildView:_surroundingsScroll];
    //门店图
    if ([_storesList count] ==0) {
        UIImageView *addStoresImg = [self generateAddImgView];
        addStoresImg.frame = CGRectMake(12, 10, _imgHeight, _imgHeight);
        addStoresImg.tag = 100;
        [_storesScroll addSubview:addStoresImg];
    }else{
        UIView *storesView = [self generateDeleteImg:CGRectMake(12, 0, _imgHeight, _imgHeight) imgStr:[BASEURL stringByAppendingString:[_storesList objectAtIndex:0]]];
        storesView.tag = 101;
        [_storesScroll addSubview:storesView];
    }
    //环境图
    if ([_surroundingsList count] ==0) {
        UIImageView *addSurroundingsImg = [self generateAddImgView];
        addSurroundingsImg.frame = CGRectMake(12, 10, _imgHeight, _imgHeight);
        addSurroundingsImg.tag = 200;
        [_surroundingsScroll addSubview:addSurroundingsImg];
    }else{
        int imgCount = (int)[_surroundingsList count];
        
        for (int i=0; i<imgCount; i++) {
            float imgX = 0;
            if (i==0) {
                imgX = 12;
            }else{
                imgX = _imgHeight*i+(i+1)*12;
            }
            UIView *surroundingsView = [self generateDeleteImg:CGRectMake(imgX, 0, _imgHeight, _imgHeight) imgStr:[BASEURL stringByAppendingString:[_surroundingsList objectAtIndex:i]]];
            surroundingsView.tag = 201+i;
            [_surroundingsScroll addSubview:surroundingsView];
        }
        if (imgCount < 3) {
            UIImageView *addSurroundingsImg = [self generateAddImgView];
            addSurroundingsImg.frame = CGRectMake(_imgHeight*imgCount+(imgCount+1)*12, 10, _imgHeight, _imgHeight);
            addSurroundingsImg.tag = 200;
            [_surroundingsScroll addSubview:addSurroundingsImg];
        }
    }
}

//移除控件下的所有控件
-(void)removeChildView:(UIView *)view{
    
    for(UIView *childView in [view subviews])
    {
        [childView removeFromSuperview];
    }
}

#pragma mark 图片
//上传图片
-(void)uploadImage:(NSData *)imageData tempBtnTag:(NSInteger)tempTag{
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/businesses/business/uplodStoreImage"] imageData:imageData parameters:[Public getParams:nil] success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            NSString *tempPath = responseObject[@"result"];
            if (tempTag == 100) {
                [_storesList addObject:tempPath];
            }else{
                [_surroundingsList addObject:tempPath];
            }
            [self updateImage];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        [hud dismiss:YES];
    }];
}

//生成添加图片按钮
-(UIImageView *)generateAddImgView{
    UITapGestureRecognizer *tapAddImgGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImgWay:)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashedBox"]];
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:tapAddImgGesturRecognizer];
    
    return imgView;
}

//生成带删除按钮的图片
-(UIView *)generateDeleteImg:(CGRect)rect imgStr:(NSString *)imgStr{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    UITapGestureRecognizer *tapPreviewImgGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClickPreview:)];
    
    CGSize viewSize = view.bounds.size;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"img_false"]];
    imgView.userInteractionEnabled = YES;
    imgView.frame = CGRectMake(0, 10, viewSize.width, viewSize.height);
    [imgView addGestureRecognizer:tapPreviewImgGesturRecognizer];
    [view addSubview:imgView];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.frame = CGRectMake(viewSize.width-20, -3, 30, 30);
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(cancelImg:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeBtn];
    
    return view;
}

//选择图片
-(void)selectImgWay:(UITapGestureRecognizer *)recognizer{
    [self.view endEditing:YES];
    MHActionSheet *actionSheet = nil;
    _tempTag = (int)recognizer.view.tag;
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
    [self uploadImage:imgData tempBtnTag:_tempTag];
    
}


#pragma mark 取消图片
-(void)cancelImg:(id)sender{
    int tag = (int)((UIButton *)sender).superview.tag;
    int index = 0;
    //门店图
    if (tag > 200) {
        index = tag-200-1;
        [_surroundingsList removeObjectAtIndex:index];
    }else{
        [_storesList removeObjectAtIndex:index];
    }
    [self updateImage];
}

//点击图片预览
-(void)imgClickPreview:(UITapGestureRecognizer *)recognizer{
    [self.view endEditing:YES];
    int tag = (int)recognizer.view.superview.tag;
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
    if (tag > 200) {
        tag = tag-200-1;
        for (NSString *urlStr in _surroundingsList) {
            [tempArr addObject:urlStr];
        }
    }else{
        tag = tag-100-1;
        for (NSString *urlStr in _storesList) {
            [tempArr addObject:urlStr];
        }
    }
    
    
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    
    for (UIImage *img in tempArr) {
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImage = img;
        browseItem.smallImageView = (UIImageView *)recognizer.view;
        [browseItemArray addObject:browseItem];
    }
//    MSSBrowseLocalViewController *bvc = [[MSSBrowseLocalViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:tag];
     MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:tag];
    [bvc showBrowseViewController];
}



-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//选择品类
- (IBAction)selectProductClick:(id)sender {
    [self.view endEditing:YES];
    SelectInnerProductViewController *viewController = (SelectInnerProductViewController *)[Public getStoryBoardByController:@"Settled" storyboardId:@"SelectInnerProductViewController"];
    viewController.isResult = YES;
    viewController.result = ^(NSDictionary *dic){
        _businessCategoryField.text = dic[@"name"];
        self.store.industryId = dic[@"id"];
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

//经营时间
- (IBAction)businessHoursClick:(id)sender {
    [self.view endEditing:YES];
    XMRTimePiker *piker=[[XMRTimePiker alloc]init];
    piker.delegate=self;
    [piker showTime];
}

-(void)XMSelectTimesViewSetOneLeft:(NSString *)oneLeft andOneRight:(NSString *)oneRight andTowLeft:(NSString *)towLeft andTowRight:(NSString *)towRight{
    _oneLeft = oneLeft;
    _oneRight = oneRight;
    _towLeft = towLeft;
    _towRight = towRight;
    
    self.store.hoursStart = [NSString stringWithFormat:@"%@:%@",_oneLeft,_oneRight];
    self.store.hoursOver = [NSString stringWithFormat:@"%@:%@",_towLeft,_towRight];
    
    _businessHoursField.text = [NSString stringWithFormat:@"%@:%@-%@:%@",oneLeft,oneRight,towLeft,towRight];
}
//选择门店地址
- (IBAction)selectMapAddressClick:(id)sender {
    [self.view endEditing:YES];
    MapViewController *mapView = [[MapViewController alloc] init];
    mapView.delegate = self;
    [self.navigationController pushViewController:mapView animated:YES];
}
-(void)selectAddress:(MapSelectResult *)mapSelectResult{
    _storeAddressField.text = mapSelectResult.address;
    
    self.store.latitude = mapSelectResult.latitude;
    self.store.longitude = mapSelectResult.longitude;
    self.store.district = mapSelectResult.district;
}
//提交审核
- (IBAction)submitReviewClick:(id)sender {
    [self.view endEditing:YES];
    if (![self verification]) {
        return;
    }
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    
    //环境图组装
    NSMutableString *tempEnvironmentMap = [[NSMutableString alloc] init];
    for (NSString *str in _surroundingsList) {
        [tempEnvironmentMap appendFormat:@"%@,",str];
    }
    if (_store.storeId == nil) {
        _store.storeId = @"";
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   _store.storeId,@"storeId",
                                   @"",@"busState",
                                   userInfo[@"id"],@"busUserId",
                                   _store.industryId,@"industryId",
                                   _storeNameField.text,@"busName",
                                   _store.hoursStart,@"hoursStart",
                                   _store.hoursOver,@"hoursOver",
                                   _storeAddressField.text,@"storeAddress",
                                   [_storesList objectAtIndex:0],@"storeFirstMap",
                                   tempEnvironmentMap,@"environmentMap",
                                   [[NSDecimalNumber alloc] initWithFloat:_store.latitude],@"latitude",
                                   [[NSDecimalNumber alloc] initWithFloat:_store.longitude],@"longitude",
                                   _store.district,@"district",
                                   _mainPhoneField.text,@"mainPhone",
                                   _otherPhoneField.text,@"otherPhone",
                                   nil];
    if (_store.storeId == nil) {
        params[@"storeId"] = _store.storeId;
    }
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/stores/store/insertOrUpdateStoer"] parameters:[Public getParams:params] success:^(id responseObject) {
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            self.addSuccess(YES);
            [self.navigationController popViewControllerAnimated:YES];
            [Public alertWithType:MozAlertTypeSuccess msg:responseObject[@"message"]];
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
    if ([_storeNameField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"门店名称不能为空"];
        return false;
    }
    if ([_businessCategoryField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"请选择经营品类"];
        return false;
    }
    if ([_businessHoursField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"请选择经营时间"];
        return false;
    }
    if ([_mainPhoneField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"主要电话不能为空"];
        return false;
    }
    if ([_storeAddressField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"门店地址不能为空"];
        return false;
    }
    if ([_storesList count] == 0) {
        [Public alertWithType:MozAlertTypeError msg:@"请上传门店首图"];
        return false;
    }
    if ([_surroundingsList count] == 0) {
        [Public alertWithType:MozAlertTypeError msg:@"请上传环境图"];
        return false;
    }
    return true;
}

-(Stoer *)store{
    if (!_store) {
        _store = [[Stoer alloc] init];
    }
    return _store;
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
