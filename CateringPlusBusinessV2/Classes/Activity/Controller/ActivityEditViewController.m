//
//  ActivityEditViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/27.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "ActivityEditViewController.h"

@interface ActivityEditViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSArray *_activityData;
}

@end

@implementation ActivityEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setTitle:@"新增"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //初始化字段数据
    [self initData];
}

//初始化数据
-(void)initData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSString *path = [[NSBundle mainBundle] pathForResource:_plistName ofType:@"plist"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"helpCut" ofType:@"plist"];
        _activityData = [[NSArray alloc] initWithContentsOfFile:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            self.selectStoresView.hidden = NO;
        });
    });
}

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_activityData objectAtIndex:section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_activityData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *itemData = [[_activityData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    TableGroupAttributes *attributes = [TableGroupAttributes initWithCounts:[[_activityData objectAtIndex:indexPath.section] count] row:indexPath.row];
    
    if ([itemData[@"type"] isEqualToString:@"img"]) {//图片ecc
        Activity_ImgCell *cell = [[Activity_ImgCell alloc] cellWithTableView:tableView];
        cell.activityImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapAddImgGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImgWay:)];
        [cell.activityImgView addGestureRecognizer:tapAddImgGesturRecognizer];
        
        return cell;
    }else if([itemData[@"type"] isEqualToString:@"select"]){//选择
        Activity_SelectCell *cell = [[Activity_SelectCell alloc] cellWithTableView:tableView tableGroupAttributes:attributes];
        cell.labelText.text = itemData[@"labelText"];
        cell.valueText.text = itemData[@"placeholder"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if([itemData[@"type"] isEqualToString:@"text"]){//文字输入
        Activity_TextCell *cell = [[Activity_TextCell alloc] cellWithTableView:tableView tableGroupAttributes:attributes];
        cell.labelText.text = itemData[@"labelText"];
        cell.valueText.placeholder = itemData[@"placeholder"];
        return cell;
    }else if([itemData[@"type"] isEqualToString:@"number"]){//数字输入
        Activity_NumberCell *cell = [[Activity_NumberCell alloc] cellWithTableView:tableView tableGroupAttributes:attributes];
        cell.labelText.text = itemData[@"labelText"];
        cell.valueText.placeholder = itemData[@"placeholder"];
        return cell;
    }else{
        Activity_ButtonCell *cell = [[Activity_ButtonCell alloc] cellWithTableView:tableView];
        return cell;
    }
    return nil;
}
#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *itemData = [[_activityData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([itemData[@"type"] isEqualToString:@"img"]) {//图片
        return 240;
    }
    if ([itemData[@"type"] isEqualToString:@"button"]) {//提交按钮
        return 120;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.00001;
    }
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //隐藏顶部的分割线
    UIView *headView = [[UIView alloc]init];
    
    headView.backgroundColor = [UIColor whiteColor];
    
    return headView;
}


#pragma mark 选中行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark 图片
//选择图片
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
            NSString *tempPath = responseObject[@"result"];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        [hud dismiss:YES];
    }];
}

#pragma mark 选择框
-(SelectStores *)selectStoresView{
    if (!_selectStoresView) {
        _selectStoresView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SelectStores class]) owner:self options:nil].lastObject;
        _selectStoresView.frame = CGRectMake(0, 0, screen_width, screen_height);
        _selectStoresView.hidden = YES;
        [self.view addSubview:_selectStoresView];
    }
    return _selectStoresView;
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
