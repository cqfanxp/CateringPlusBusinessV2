//
//  ImproveStoreInformationViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/11.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "ImproveStoreInformationViewController.h"
#import "SubmitQualificationViewController.h"
#import "MHActionSheet.h"
#import "MSSBrowseDefine.h"
#import "MapViewController.h"

@interface ImproveStoreInformationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,MapViewDelegate>{
    UIImageView *_storesImg;//门店图（添加）
    UIImageView *_surroundingsImg;//环境图（添加）
    
    float _imgHeight;//图片高度
    
    int _selectImgTag;//当前选择图片的tag
    
    NSInteger _tempBtnTag;//btn临时tag
    
    //图片数据
    NSMutableArray *_storesList;//门店图
    NSMutableArray *_surroundingsList;//环境图
    
    NSString *_storesPath;//门店首图服务器地址
    NSMutableDictionary *_surroundingsPath;//环境图服务器地址
    
    MapSelectResult *_mapSelectResult;//地址信息
}

@end

@implementation ImproveStoreInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLayout];
    
    [self setTitle:@"完善门店信息"];
    
    //右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"开店手册" style:UIBarButtonItemStyleDone target:self action:@selector(shopmanualBtnClick)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark 初始化布局
-(void)initLayout{
    
    _imgHeight = 77-10;
    
    _surroundingsPath = [[NSMutableDictionary alloc] init];
    
    //门店图
    _storesImg = [self getAddImgView:100 num:0];
    [_storesScroll addSubview:_storesImg];
    
    //环境图
    _surroundingsImg = [self getAddImgView:200 num:0];
    [_surroundingsScroll addSubview:_surroundingsImg];
    
    //初始化集合
    _storesList = [[NSMutableArray alloc] init];
    _surroundingsList = [[NSMutableArray alloc] init];
    
    
}
//上传图片
-(void)uploadImage:(NSData *)imageData type:(NSString *) type tempBtnTag:(NSInteger)tempBtnTag{
    
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/businesses/business/uplodStoreImage"] imageData:imageData parameters:[Public getParams:nil] success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"success"] boolValue]) {
            NSString *tempPath = responseObject[@"result"];
            if ([type isEqualToString:@"storesImg"]) {
                _storesPath = tempPath;
            }else{
                [_surroundingsPath setObject:tempPath forKey:[NSString stringWithFormat: @"%ld", (long)tempBtnTag]];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

#pragma mark 下一步
- (IBAction)nextBtn:(id)sender {
    if (![self verification]) {
        return;
    }
    
    //行业信息
    NSDictionary *categoryInfo = [Public getUserDefaultKey:CATEGORYINFO];
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    
    //环境图组装
    NSMutableString *tempEnvironmentMap = [[NSMutableString alloc] init];
    for (NSString *str in [_surroundingsPath allValues]) {
        [tempEnvironmentMap appendFormat:@"%@,",str];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   userInfo[@"id"],@"BusUserId",
                                   categoryInfo[@"id"],@"IndusId",
                                   _storeNameField.text,@"BusName",
                                   _phoneStoresField.text,@"MainPhone",
                                   _storeAddressField.text,@"StoreAddress",
                                   _storesPath,@"StoreFirstMap",
                                   tempEnvironmentMap,@"EnvironmentMap",
                                   [[NSDecimalNumber alloc] initWithFloat:_mapSelectResult.latitude],@"Latitude",
                                   [[NSDecimalNumber alloc] initWithFloat:_mapSelectResult.longitude],@"Longitude",
                                   _mapSelectResult.district,@"District",
                                   @"",@"BusinessArea",
                                   nil];
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/businesses/business/insertStore"] parameters:[Public getParams:params] success:^(id responseObject) {
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            //跳转到下一步
            SubmitQualificationViewController *viewController = (SubmitQualificationViewController *)[Public getStoryBoardByController:@"Settled" storyboardId:@"SubmitQualificationViewController"];
            viewController.storeId = responseObject[@"result"];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }else{
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
    if ([_phoneStoresField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"门店电话不能为空"];
        return false;
    }
    if ([_storeAddressField.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"门店地址不能为空"];
        return false;
    }
    if (_storesPath == nil) {
        [Public alertWithType:MozAlertTypeError msg:@"请上传门店首图"];
        return false;
    }
    if ([_surroundingsPath count] == 0) {
        [Public alertWithType:MozAlertTypeError msg:@"请上传环境图"];
        return false;
    }
    return true;
}

#pragma mark 获得添加图片按钮
-(UIImageView *)getAddImgView:(int)tag num:(int)num{
    UITapGestureRecognizer *tapAddImgGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImgWay:)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashedBox"]];
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
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            imagePickerController.modalPresentationStyle=UIModalPresentationCurrentContext;
        }
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
}


#pragma mark - image picker delegte
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData *imgData = UIImagePNGRepresentation(image);
    
    if (_selectImgTag == 100) {
        [_storesImg removeFromSuperview];
        [_storesScroll addSubview:[self generateImg:image num:0]];
        [_storesList addObject:image];
        
        //上传图片
        [self uploadImage:imgData type:@"storesImg" tempBtnTag:_tempBtnTag];
    }else{
        int num = (int)[_surroundingsList count];
        [_surroundingsImg removeFromSuperview];
        [_surroundingsScroll addSubview:[self generateImg:image num:num]];
        [_surroundingsList addObject:image];
        num += 1;
        
        //环境图
        if (num < 3) {
            _surroundingsImg = [self getAddImgView:200 num:num];
            [_surroundingsScroll addSubview:_surroundingsImg];
        }
        //上传图片
        [self uploadImage:imgData type:@"surroundingsImg" tempBtnTag:_tempBtnTag];
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
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, -5, 30, 30)];
    closeBtn.tag = _selectImgTag+num+10;
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(cancelImg:) forControlEvents:UIControlEventTouchUpInside];
//    [closeBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [view addSubview:closeBtn];
    
    _tempBtnTag = closeBtn.tag;
    
    return view;
}
#pragma mark 取消图片
-(void)cancelImg:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    //门店图
    if (btn.tag<200) {
        _storesImg = [self getAddImgView:100 num:0];
        [_storesScroll addSubview:_storesImg];
        [_storesList removeAllObjects];
        [btn.superview removeFromSuperview];
        //清空门店首图
        _storesPath = nil;
    }else{
        //获得view中的所有控件（UIImageView、UIButton）
        NSArray *subViews = btn.superview.subviews;
        //查询Img并移送_surroundingsList集合中Img的数据
        for (UIView *view in subViews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [_surroundingsList removeObject:((UIImageView *)view).image];
            }
        }
        //移除环境图
        [btn.superview.superview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        int surroundCount = (int)[_surroundingsList count];
        //重新组装数据
        if (surroundCount>0) {
            _selectImgTag = 200;
            int num = 0;
            for (UIImage *img in _surroundingsList) {
                [_surroundingsScroll addSubview:[self generateImg:img num:num]];
                num++;
            }
        }
        //添加图片
        if (surroundCount < 3) {
            _surroundingsImg = [self getAddImgView:200 num:surroundCount];
            [_surroundingsScroll addSubview:_surroundingsImg];
        }
        //删除对应的环境图
        [_surroundingsPath removeObjectForKey:[NSString stringWithFormat: @"%ld", (long)btn.tag]];
    }
}

#pragma mark 点击图片预览
-(void)imgClickPreview:(UITapGestureRecognizer *)recognizer{
    int tag = (int)recognizer.view.tag;
    NSMutableArray *tempArr = _storesList;
    
    if (tag>200) {
        tag = tag-200-1;
        tempArr = _surroundingsList;
    }else{
        tag = tag-100-1;
    }
    
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    
    for (UIImage *img in tempArr) {
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImage = img;
        browseItem.smallImageView = (UIImageView *)recognizer.view;
        [browseItemArray addObject:browseItem];
    }
    
    [self picturePreview:browseItemArray currentIndex:tag];
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
//选择门店地址
- (IBAction)selectStoreAddress:(id)sender {
    MapViewController *mapView = [[MapViewController alloc] init];
    mapView.delegate = self;
    [self.navigationController pushViewController:mapView animated:YES];
}

-(void)selectAddress:(MapSelectResult *)mapSelectResult{
    _storeAddressField.text = mapSelectResult.address;
    _mapSelectResult = mapSelectResult;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//开店手册
-(void)shopmanualBtnClick{
    
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
