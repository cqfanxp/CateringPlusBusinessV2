//
//  PackageEditViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/22.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "PackageEditViewController.h"
#import "ChooseSingleProductViewController.h"
#import "WKProgressHUD.h"
#import "MSSBrowseModel.h"
#import "Commodity.h"

@interface PackageEditViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSMutableArray *_detailList;//详情图
    NSString *_firstMapPath;//首图网络地址
    
    float _imgHeight;//图片高度
    NSInteger _tempTag;//临时tag
    
    //套餐内容
    NSArray *_packageContents;
}

@end

@implementation PackageEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setTitle:@"编辑套餐"];
    
    [self initLayout];
    
    [self updateImage];
}

#pragma mark 初始化布局
-(void)initLayout{
    _imgHeight = _fIGDetailsScroll.frame.size.height-10;
    
    //商品首图
    UITapGestureRecognizer *tapAddImgGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImgWay:)];
    _firstMapImgView.tag = 100;
    _firstMapImgView.userInteractionEnabled = YES;
    [_firstMapImgView addGestureRecognizer:tapAddImgGesturRecognizer];
    
    //初始化集合
    _detailList = [[NSMutableArray alloc] init];
    
    if (_package != nil) {
        //加载首图
        _firstMapPath = _package.packageFirstMap;
        [_firstMapImgView sd_setImageWithURL:[NSURL URLWithString:[BASEURL stringByAppendingString:_firstMapPath]] placeholderImage:[UIImage imageNamed:@"img_false"]];
        
        _packageName.text = _package.packageName;
        
        //加载详情图
        for (NSDictionary *dic in _package.accessories) {
            [_detailList addObject:dic[@"filePath"]];
        }
        [self updateImage];
        
        //加载套餐内容
        NSMutableArray *tempPackageContent = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in _package.packageToSingleProducts) {
            Commodity *commodity = [[Commodity alloc] initWithDic:dic];
            commodity.identifies = dic[@"singleProductId"];
            commodity.number = [dic[@"singleNumber"] intValue];
            commodity.singleName = dic[@"singleName"];
            [tempPackageContent addObject:commodity];
        }
        _packageContents = tempPackageContent;
        [self setPackageContentValue];
    }
    
}

//更新详情图片信息
-(void)updateImage{
    [self removeChildView:_fIGDetailsScroll];

    if ([_detailList count] ==0) {
        UIImageView *addSurroundingsImg = [self generateAddImgView];
        addSurroundingsImg.frame = CGRectMake(12, 10, _imgHeight, _imgHeight-10);
        addSurroundingsImg.tag = 200;
        [_fIGDetailsScroll addSubview:addSurroundingsImg];
    }else{
        int imgCount = (int)[_detailList count];
        
        for (int i=0; i<imgCount; i++) {
            float imgX = 0;
            if (i==0) {
                imgX = 12;
            }else{
                imgX = _imgHeight*i+(i+1)*12;
            }
            UIView *surroundingsView = [self generateDeleteImg:CGRectMake(imgX, 0, _imgHeight, _imgHeight-10) imgStr:[BASEURL stringByAppendingString:[_detailList objectAtIndex:i]]];
            surroundingsView.tag = 201+i;
            [_fIGDetailsScroll addSubview:surroundingsView];
        }
        if (imgCount < 3) {
            UIImageView *addSurroundingsImg = [self generateAddImgView];
            addSurroundingsImg.frame = CGRectMake(_imgHeight*imgCount+(imgCount+1)*12, 10, _imgHeight, _imgHeight-10);
            addSurroundingsImg.tag = 200;
            [_fIGDetailsScroll addSubview:addSurroundingsImg];
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
                [_firstMapImgView sd_setImageWithURL:[NSURL URLWithString:[BASEURL stringByAppendingString:tempPath]] placeholderImage:[UIImage imageNamed:@"img_false"]];
                _firstMapPath = tempPath;
            }else{
                [_detailList addObject:tempPath];
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
        [_detailList removeObjectAtIndex:index];
    }else{
//        [_storesList removeObjectAtIndex:index];
    }
    [self updateImage];
}

//点击图片预览
-(void)imgClickPreview:(UITapGestureRecognizer *)recognizer{
    [self.view endEditing:YES];
    int tag = (int)recognizer.view.superview.tag;
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
//    if (tag > 200) {
//        tag = tag-200-1;
//        for (NSString *urlStr in _surroundingsList) {
//            [tempArr addObject:urlStr];
//        }
//    }else{
//        tag = tag-100-1;
//        for (NSString *urlStr in _storesList) {
//            [tempArr addObject:urlStr];
//        }
//    }
//    
//    
//    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
//    
//    for (UIImage *img in tempArr) {
//        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
//        browseItem.bigImage = img;
//        browseItem.smallImageView = (UIImageView *)recognizer.view;
//        [browseItemArray addObject:browseItem];
//    }
//    //    MSSBrowseLocalViewController *bvc = [[MSSBrowseLocalViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:tag];
//    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:tag];
//    [bvc showBrowseViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//验证
-(Boolean)verification{
    if (_firstMapPath == nil) {
        [Public alertWithType:MozAlertTypeError msg:@"首图不能为空"];
        return false;
    }
    if ([_detailList count] == 0) {
        [Public alertWithType:MozAlertTypeError msg:@"请选择详情图"];
        return false;
    }
    if ([_packageName.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"套餐名称不能为空"];
        return false;
    }
    if ([_packageContent.text isEqualToString:@""]) {
        [Public alertWithType:MozAlertTypeError msg:@"请选择套餐内容"];
        return false;
    }
    return true;
}

//选择套餐内容
- (IBAction)packageContentClick:(id)sender {
    ChooseSingleProductViewController *viewController = (ChooseSingleProductViewController *)[Public getStoryBoardByController:@"PackageManagement" storyboardId:@"ChooseSingleProductViewController"];
    viewController.modifyCheckData = _packageContents;
    viewController.resultDataBlock = ^(NSArray *data){
        _packageContents = data;
        [self setPackageContentValue];
    };
    [self.navigationController pushViewController:viewController animated:YES];

}

//设置套餐内容
-(void)setPackageContentValue{
    if (_packageContents) {
        NSMutableString *tempStr = [[NSMutableString alloc] init];
        for (Commodity *item in _packageContents) {
            [tempStr appendString:item.singleName];
            [tempStr appendString:@"  "];
        }
        _packageContent.text = tempStr;
    }
}
//提交数据
- (IBAction)submitClick:(id)sender {
    [self.view endEditing:YES];
    if (![self verification]) {
        return;
    }
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    
    //详情图组装
    NSMutableString *tempEnvironmentMap = [[NSMutableString alloc] init];
    for (NSString *str in _detailList) {
        [tempEnvironmentMap appendFormat:@"%@,",str];
    }
    //套餐内容
    NSMutableArray *packageContentArr = [[NSMutableArray alloc] init];
    for (Commodity *item in _packageContents) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             item.identifies,@"singleProductId",
                             [[NSNumber alloc] initWithInt:item.number],@"singleNumber", nil];
        [packageContentArr addObject:dic];
    }
    NSString *packageId = @"";
    
    if (_package != nil && _package.identifies != nil) {
        packageId = _package.identifies;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   _firstMapPath,@"packageFirstMap",
                                   tempEnvironmentMap,@"packageImage",
                                   _packageName.text,@"packageName",
                                   packageContentArr,@"packageToSingleProducts",
                                   userInfo[@"id"],@"busUserId",
                                   packageId,@"packageId",
                                   nil];
    
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/packages/package/insertOrUpdatePackageList"] parameters:[Public getParams:params] success:^(id responseObject) {
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            self.saveSuccess(YES);
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

@end
