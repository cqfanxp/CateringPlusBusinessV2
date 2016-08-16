//
//  ImproveStoreInformationViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/11.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "ImproveStoreInformationViewController.h"
#import "MHActionSheet.h"
#import "MSSBrowseDefine.h"

@interface ImproveStoreInformationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIImageView *_storesImg;//门店图（添加）
    UIImageView *_surroundingsImg;//环境图（添加）
    
    float _imgHeight;//图片高度
    
    int _selectImgTag;//当前选择图片的tag
    
    //图片数据
    NSMutableArray *_storesList;//门店图
    NSMutableArray *_surroundingsList;//环境图
}

@end

@implementation ImproveStoreInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLayout];
    
    [self setTitle:@"完善门店信息"];
    
    //右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"开店手册" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

#pragma mark 初始化布局
-(void)initLayout{
    
    _imgHeight = _storesScroll.frame.size.height-10;
    
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

#pragma mark 下一步
- (IBAction)nextBtn:(id)sender {
    UIViewController *viewController = [Public getStoryBoardByController:@"Settled" storyboardId:@"SubmitQualificationViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];
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
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
}


#pragma mark - image picker delegte
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (_selectImgTag == 100) {
        [_storesImg removeFromSuperview];
        [_storesScroll addSubview:[self generateImg:image num:0]];
        [_storesList addObject:image];
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
