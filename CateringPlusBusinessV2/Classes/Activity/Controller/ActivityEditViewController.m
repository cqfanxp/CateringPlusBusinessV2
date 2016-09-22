//
//  ActivityEditViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/27.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "ActivityEditViewController.h"
#import "ActivityDisplayField.h"
#import "SelectPackageViewController.h"
#import "SelectStartAndEndTimeViewController.h"
#import "SelectHtmlTextViewController.h"
#import "HcdDateTimePickerView.h"
#import "SelectActivityPriceViewController.h"
#import "HelpCutSettingsViewController.h"
#import "Stoer.h"
#import "HelpCutModel.h"

@interface ActivityEditViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>{
    NSMutableArray *_activityData;
    
    NSArray *_selectTypeArray;
    
    HcdDateTimePickerView * dateTimePickerView;
    
    //活动数据地址
    NSDictionary *_activityUrl;
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
    
    _activityData = [[NSMutableArray alloc] init];
    
    _selectTypeArray = [[NSArray alloc] initWithObjects:@"selectStores",@"selectPackage",@"selectHtmlContent",@"selectMissionFight",@"selectStartAndEndTime",@"selectActivityPrice",@"selectDate", nil];
    
    //初始化活动数据地址
    _activityUrl = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"/api/activities/customize/insertOrUpdateCustomize",@"customEvents",//自定义活动
                    @"/api/activities/lessSpending/insertOrUpdateLessSpending",@"lessSpending",//消费满减
                    @"/api/activities/limitedPreferential/insertOrUpdateLimitedPreferential",@"limitedTimeOffer",//限时优惠
                    @"/api/activities/arrivedCoupons/insertOrUpdateArrivedCouponsAsync",@"volumeDeductible",//抵扣券
                    @"/api/activities/coupons/insertOrUpdateCoupons",@"volumeDiscounts",//折扣劵
                    @"/api/activities/friendsHelp/insertOrUpdateFriendsHelp",@"helpCut",//好有帮帮砍
                    @"/api/activities/fightAlone/insertOrUpdateFightAlone",@"fightAlone",nil];//拼单
    
    //初始化字段数据
    [self initData];
}

//初始化数据
-(void)initData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:_plistName ofType:@"plist"];
        NSArray *tempArr = [[NSArray alloc] initWithContentsOfFile:path];
        
        for (NSArray *array in tempArr) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in array) {
                ActivityDisplayField *model = [[ActivityDisplayField alloc] initWithDic:dic];
                if (_activityModel &&model.key != nil) {
                    NSUInteger index = [_selectTypeArray indexOfObject:model.selectType];
                    

                    switch (index) {
                            case 0:{
                                NSMutableString *tempStoerStr = [[NSMutableString alloc] init];
                                for (NSDictionary *stoerDic in _activityModel.storeList) {
                                    [tempStoerStr appendFormat:@"%@  ",[stoerDic objectForKey:@"busName"]];
                                }
                                model.value = tempStoerStr;
                            }
                            break;
                            case 1:
                                model.value = _activityModel.packages[@"packageName"];
                            break;
                            case 2:{
                                    NSString *tempValue = [_activityModel valueForKey:model.key];
                                    if (![self isNull:tempValue]) {
                                        model.value = @"已添加";
                                    }
                            }
                            break;
                            case 3:{
                                if (_activityModel.fiendsHelpSpreads && [_activityModel.fiendsHelpSpreads count] > 0) {
                                    NSMutableArray *tempHelpCutArr = [[NSMutableArray alloc] init];
                                    for (NSDictionary *dic in _activityModel.fiendsHelpSpreads) {
                                        HelpCutModel *tempHelpCut = [HelpCutModel new];
                                        tempHelpCut.price = dic[@"price"];
                                        tempHelpCut.peopleNumber = dic[@"peopleNumber"];
                                        
                                        [tempHelpCutArr addObject:tempHelpCut];
                                    }
                                    _activityModel.settingNumberActivities = tempHelpCutArr;
                                    model.value = @"已添加";
                                }
                            }
                            break;
                            case 4:
                                model.value = [NSString stringWithFormat:@"%@ - %@",_activityModel.starTime,_activityModel.overTime];
                            break;
                            case 5:
                                if ([_activityModel.type boolValue]) {
                                    model.value = [NSString stringWithFormat:@"消费满%@减%@(上限%@元)",_activityModel.howFull,_activityModel.howLess,_activityModel.capAmount];
                                }else{
                                    model.value = [NSString stringWithFormat:@"消费满%@减%@",_activityModel.howFull,_activityModel.howLess];
                                }
                            break;
                        default:
                            model.value = [NSString stringWithFormat:@"%@",[_activityModel valueForKey:model.key]];
                            break;
                    }
                }
                [tempArray addObject:model];
            }
            [_activityData addObject:tempArray];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
//            self.selectStoresView.hidden = NO;
        });
    });
}

-(Boolean )isNull:(id)value{
    if (value && ![value isEqualToString:@""]) {
        return false;
    }
    return true;
}

//初始化ActivityModel对象
-(ActivityModel *)activityModel{
    if (!_activityModel) {
        _activityModel = [[ActivityModel alloc] init];
    }
    return _activityModel;
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
    ActivityDisplayField *itemData = [[_activityData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    TableGroupAttributes *attributes = [TableGroupAttributes initWithCounts:[[_activityData objectAtIndex:indexPath.section] count] row:indexPath.row];
    
    if ([itemData.type isEqualToString:@"img"]) {//图片ecc
        Activity_ImgCell *cell = [[Activity_ImgCell alloc] cellWithTableView:tableView];
        cell.activityImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapAddImgGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImgWay:)];
        [cell.activityImgView addGestureRecognizer:tapAddImgGesturRecognizer];
        
        if (itemData.value && ![itemData.value isEqualToString:@""]) {
            [cell.activityImgView sd_setImageWithURL:[NSURL URLWithString:[BASEURL stringByAppendingString:itemData.value]] placeholderImage:[UIImage imageNamed:@"img_false"]];
        }
        
        return cell;
    }else if([itemData.type isEqualToString:@"select"]){//选择
        Activity_SelectCell *cell = [[Activity_SelectCell alloc] cellWithTableView:tableView tableGroupAttributes:attributes];
        cell.labelText.text = itemData.labelText;
        if ([itemData.value isEqualToString:@""]) {
            cell.valueText.text = itemData.placeholder;
            cell.valueText.textColor = RGB(190, 190, 190);
        }else{
            cell.valueText.text = itemData.value;
            cell.valueText.textColor = RGB(51, 51, 51);
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
        return cell;
    }else if([itemData.type isEqualToString:@"text"]){//文字输入
        Activity_TextCell *cell = [[Activity_TextCell alloc] cellWithTableView:tableView tableGroupAttributes:attributes];
        cell.labelText.text = itemData.labelText;
        cell.valueText.delegate = self;
        cell.valueText.text = itemData.value;
        cell.valueText.placeholder = itemData.placeholder;
        return cell;
    }else if([itemData.type isEqualToString:@"number"]){//数字输入
        Activity_NumberCell *cell = [[Activity_NumberCell alloc] cellWithTableView:tableView tableGroupAttributes:attributes];
        cell.labelText.text = itemData.labelText;
        cell.valueText.delegate = self;
        cell.valueText.text = itemData.value;
        cell.valueText.placeholder = itemData.placeholder;
        return cell;
    }else{
        Activity_ButtonCell *cell = [[Activity_ButtonCell alloc] cellWithTableView:tableView];
        [cell.submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}
#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityDisplayField *itemData = [[_activityData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([itemData.type isEqualToString:@"img"]) {//图片
        return 240;
    }
    if ([itemData.type isEqualToString:@"button"]) {//提交按钮
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
    ActivityDisplayField *itemData = [[_activityData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //选择框
    if ([itemData.type isEqualToString:@"select"]) {
        //选择门店
        if ([itemData.selectType isEqualToString:@"selectStores"]) {
            self.selectStoresView.hidden = NO;
        }
        //选择套餐
        if ([itemData.selectType isEqualToString:@"selectPackage"]) {
            SelectPackageViewController *viewController = [[SelectPackageViewController alloc] init];
            viewController.selectData = self.activityModel.packageId;
            viewController.resultData = ^(Package *item){
                itemData.value = item.packageName;
                [self.activityModel setValue:item.identifies forKey:itemData.key];
                //刷新数据
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:viewController animated:YES];
        }
        //选择开始时间和结束时间
        if ([itemData.selectType isEqualToString:@"selectStartAndEndTime"]) {
            SelectStartAndEndTimeViewController *viewController = [[SelectStartAndEndTimeViewController alloc] init];
            viewController.startTime = self.activityModel.starTime;
            viewController.endTime = self.activityModel.overTime;
            
            viewController.resultData = ^(NSString *startTime,NSString *endTime){
                self.activityModel.starTime = startTime;
                self.activityModel.overTime = endTime;
                
                itemData.value = [NSString stringWithFormat:@"%@ - %@",startTime,endTime];
                //刷新数据
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:viewController animated:YES];
        }
        //选择时间
        if ([itemData.selectType isEqualToString:@"selectDate"]) {
            dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateHourMinuteMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]];
            dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
                NSLog(@"%@", datetimeStr);
                itemData.value = datetimeStr;
                [self.activityModel setValue:datetimeStr forKey:itemData.key];
                //刷新数据
                [_tableView reloadData];
            };
            [self.view addSubview:dateTimePickerView];
            [dateTimePickerView showHcdDateTimePicker];
        }
        //HTML内容
        if ([itemData.selectType isEqualToString:@"selectHtmlContent"]) {
            SelectHtmlTextViewController *viewController = [[SelectHtmlTextViewController alloc] init];
            [viewController setHTML:[self.activityModel valueForKey:itemData.key]];
            [viewController setTitle:itemData.labelText];
            viewController.resultData = ^(NSString *content){
                NSLog(@"content:%@",content);
                if (![content isEqualToString:@""]) {
                    itemData.value = @"已添加";
                }
                [self.activityModel setValue:content forKey:itemData.key];
                //刷新数据
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:viewController animated:YES];
        }
        //选择活动价格
        if ([itemData.selectType isEqualToString:@"selectActivityPrice"]) {
            SelectActivityPriceViewController *viewController = [[SelectActivityPriceViewController alloc] init];
            viewController.activityProce = [ActivityPrice initWithType:self.activityModel.type howFull:self.activityModel.howFull howLess:self.activityModel.howLess capAmount:self.activityModel.capAmount];
            
            viewController.resultData = ^(ActivityPrice *item){
                self.activityModel.type = item.type;
                self.activityModel.howFull = item.howFull;
                self.activityModel.howLess = item.howLess;
                self.activityModel.capAmount = item.capAmount;
                
                if ([item.type boolValue]) {
                    itemData.value = [NSString stringWithFormat:@"消费满%@减%@(上限%@元)",item.howFull,item.howLess,item.capAmount];
                }else{
                    itemData.value = [NSString stringWithFormat:@"消费满%@减%@",item.howFull,item.howLess];
                }
                //刷新数据
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:viewController animated:YES];
        }
        //选择人数价格    selectMissionFight
        if ([itemData.selectType isEqualToString:@"selectMissionFight"]) {
            HelpCutSettingsViewController *viewController = [[HelpCutSettingsViewController alloc] init];
            viewController.settingNumberActivities = self.activityModel.settingNumberActivities;
            
            viewController.resultData = ^(NSArray *data){
                itemData.value = @"已添加";
                self.activityModel.settingNumberActivities = data;
                //刷新数据
                [_tableView reloadData];
            };
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    
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
            self.activityModel.image = tempPath;
            ActivityDisplayField *model = [self getActivityByKey:@"image"];
            model.value = tempPath;
            
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        [hud dismiss:YES];
    }];
}

//根据key查询ActivityDisplayField
-(ActivityDisplayField *)getActivityByKey:(NSString *)key{
    
    for (NSArray *array in _activityData) {
        
        for (ActivityDisplayField *temp in array) {
            if ([temp.key isEqualToString:key]) {
                return  temp;
            }
        }
    }
    return nil;
}

#pragma mark 选择框
//选择门店信息
-(SelectStores *)selectStoresView{
    if (!_selectStoresView) {
        _selectStoresView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SelectStores class]) owner:self options:nil].lastObject;
        _selectStoresView.frame = CGRectMake(0, 0, screen_width, screen_height);
        _selectStoresView.hidden = YES;
        _selectStoresView.selectData = self.activityModel.storeList;
        
        _selectStoresView.resultData = ^(NSArray *data){
            NSMutableString *tempStr = [[NSMutableString alloc] init];
            NSMutableString *tempids = [[NSMutableString alloc] init];
            for (Stoer *item in data) {
                [tempStr appendFormat:@"%@  ",item.busName];
                [tempids appendFormat:@"%@,",item.storeId];
            }
            ActivityDisplayField *activityDisplayField = [self getActivityByKey:@"storeIds"];
            activityDisplayField.value = tempStr;
            [self.activityModel setValue:tempids forKey:@"storeIds"];
            [_tableView reloadData];
        };
        [self.view addSubview:_selectStoresView];
    }
    return _selectStoresView;
}

//Cell文本框值改变时  赋值给ActivityModel 对象
-(void)textFieldDidEndEditing:(UITextField *)textField{
    UITableViewCell *cell  = (UITableViewCell *)[[textField superview] superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    ActivityDisplayField *itemData = [[_activityData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    itemData.value = textField.text;
    
    [self.activityModel setValue:textField.text forKey:itemData.key];
}

//提交数据
-(void)submitClick{
    
    if (![self verification:_plistName]) {
        return;
    }
    
    NSMutableDictionary *params = [self getParams:_plistName];
    
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    
    NSString *urlStr = [BASEURL stringByAppendingString:[_activityUrl objectForKey:_plistName]];
    [NetWorkUtil post:urlStr parameters:[Public getParams:params] success:^(id responseObject) {
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            [self.navigationController popViewControllerAnimated:YES];
            [Public alertWithType:MozAlertTypeSuccess msg:responseObject[@"message"]];
            self.saveSuccess(YES);
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

//获取参数
-(NSMutableDictionary *)getParams:(NSString *)type{
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   userInfo[@"id"],@"busUserId",
                                   _activityModel.storeIds,@"storeIds",
                                   _activityModel.image,@"image",
                                   _activityModel.title,@"title",
                                   _activityModel.content,@"content",
                                   _activityModel.limitations,@"limitations",nil];
    
    if (!_activityModel.identifies) {
        _activityModel.identifies = @"";
    }
    //定义活动
    if ([type isEqualToString:@"customEvents"]) {
        params[@"customizeId"] = _activityModel.identifies;
        params[@"limitTime"] = _activityModel.limitTime;
    }
    //消费满减
    if ([type isEqualToString:@"lessSpending"]) {
        params[@"lessSpendingId"] = _activityModel.identifies;
        params[@"howFull"] = _activityModel.howLess;
        params[@"howLess"] = _activityModel.howLess;
        params[@"type"] = _activityModel.type;
        params[@"limitTime"] = _activityModel.limitTime;
        params[@"capAmount"] = _activityModel.capAmount;
    }
    //限时优惠
    if ([type isEqualToString:@"limitedTimeOffer"]) {
        params[@"limitedPreferentialId"] = _activityModel.identifies;
        params[@"packageId"] = _activityModel.packageId;
        params[@"price"] = _activityModel.price;//[[NSNumber alloc] initWithFloat:_activityModel.price];
        params[@"starTime"] = _activityModel.starTime;
        params[@"overTime"] = _activityModel.overTime;
    }
    //抵扣券
    if ([type isEqualToString:@"volumeDeductible"]) {
        params[@"arrivedCouponsId"] = _activityModel.identifies;
        params[@"price"] = _activityModel.price;//[[NSNumber alloc] initWithFloat:_activityModel.price];
        params[@"limitTime"] = _activityModel.limitTime;
    }
    //折扣劵
    if ([type isEqualToString:@"volumeDiscounts"]) {
        params[@"couponsId"] = _activityModel.identifies;
        params[@"discount"] = _activityModel.discount;//[[NSNumber alloc] initWithFloat:_activityModel.price];
        params[@"limitTime"] = _activityModel.limitTime;
    }
    //拼团
    if ([type isEqualToString:@"fightAlone"]) {
        params[@"fightAloneId"] = _activityModel.identifies;
        params[@"packageId"] = _activityModel.packageId;
        params[@"price"] = _activityModel.price;//[[NSNumber alloc] initWithFloat:_activityModel.price];
        params[@"starTime"] = _activityModel.starTime;
        params[@"overTime"] = _activityModel.overTime;
        params[@"peoNumber"] = _activityModel.peoNumber;
        params[@"limitTime"] = _activityModel.limitTime;
    }
    //帮帮砍
    if ([type isEqualToString:@"helpCut"]) {
        params[@"friendsHelpId"] = _activityModel.identifies;
        params[@"packageId"] = _activityModel.packageId;
        params[@"starTime"] = _activityModel.starTime;//[[NSNumber alloc] initWithFloat:_activityModel.price];
        params[@"overTime"] = _activityModel.overTime;
        params[@"limitTime"] = _activityModel.limitTime;
        //构建帮帮砍数据
        NSMutableArray *tempHelpCutArr = [[NSMutableArray alloc] init];
        for (HelpCutModel *item in _activityModel.settingNumberActivities) {
            NSDictionary *tempDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     item.peopleNumber,@"peopleNumber",
                                     item.price,@"price",nil];
            [tempHelpCutArr addObject:tempDic];
        }
        params[@"fiendsHelpSpreads"] = tempHelpCutArr;
    }
    return params;
}

//验证
-(Boolean)verification:(NSString *)type{
    
    if ([self isNull:self.activityModel.image]) {
        [Public alertWithType:MozAlertTypeError msg:@"首图不能为空"];
        return false;
    }
    if ([self isNull:self.activityModel.storeIds]) {
        [Public alertWithType:MozAlertTypeError msg:@"请选择参与活动的门店"];
        return false;
    }
    if ([self isNull:self.activityModel.title]) {
        [Public alertWithType:MozAlertTypeError msg:@"活动主题不能为空"];
        return false;
    }
    if ([self isNull:self.activityModel.content]) {
        [Public alertWithType:MozAlertTypeError msg:@"活动内容不能为空"];
        return false;
    }
    if ([self isNull:self.activityModel.limitations]) {
        [Public alertWithType:MozAlertTypeError msg:@"使用限制不能为空"];
        return false;
    }
    //定义活动
    if ([type isEqualToString:@"customEvents"]) {
        if ([self isNull:self.activityModel.limitTime]) {
            [Public alertWithType:MozAlertTypeError msg:@"请选择有效期"];
            return false;
        }
    }
    //消费满减
    if ([type isEqualToString:@"lessSpending"]) {
        if ([self isNull:self.activityModel.limitTime]) {
            [Public alertWithType:MozAlertTypeError msg:@"请选择有效期"];
            return false;
        }
        if ([self isNull:self.activityModel.howLess]) {
            [Public alertWithType:MozAlertTypeError msg:@"请设置活动价格"];
            return false;
        }
    }
    //限时优惠
    if ([type isEqualToString:@"limitedTimeOffer"]) {
        if ([self isNull:self.activityModel.packageId]) {
            [Public alertWithType:MozAlertTypeError msg:@"请选择套餐"];
            return false;
        }
        if ([self isNull:self.activityModel.price]) {
            [Public alertWithType:MozAlertTypeError msg:@"请输入优惠价格"];
            return false;
        }
        if ([self isNull:self.activityModel.starTime]) {
            [Public alertWithType:MozAlertTypeError msg:@"请设置活动时间"];
            return false;
        }
    }
    //抵扣券
    if ([type isEqualToString:@"volumeDeductible"]) {
        if ([self isNull:self.activityModel.price]) {
            [Public alertWithType:MozAlertTypeError msg:@"请输入抵扣面值"];
            return false;
        }
        if ([self isNull:self.activityModel.limitTime]) {
            [Public alertWithType:MozAlertTypeError msg:@"请选择有效期"];
            return false;
        }
    }
    //折扣劵
    if ([type isEqualToString:@"volumeDiscounts"]) {
        if ([self isNull:self.activityModel.discount]) {
            [Public alertWithType:MozAlertTypeError msg:@"请输入折扣比例"];
            return false;
        }
        if ([self isNull:self.activityModel.limitTime]) {
            [Public alertWithType:MozAlertTypeError msg:@"请选择有效期"];
            return false;
        }
    }
    //拼团
    if ([type isEqualToString:@"fightAlone"]) {
        if ([self isNull:self.activityModel.packageId]) {
            [Public alertWithType:MozAlertTypeError msg:@"请选择套餐"];
            return false;
        }
        if ([self isNull:self.activityModel.price]) {
            [Public alertWithType:MozAlertTypeError msg:@"请输入拼团价格"];
            return false;
        }
        if ([self isNull:self.activityModel.peoNumber]) {
            [Public alertWithType:MozAlertTypeError msg:@"请输入拼团人数"];
            return false;
        }
        if ([self isNull:self.activityModel.starTime]) {
            [Public alertWithType:MozAlertTypeError msg:@"请设置活动时间"];
            return false;
        }
        if ([self isNull:self.activityModel.limitTime]) {
            [Public alertWithType:MozAlertTypeError msg:@"请选择有效期"];
            return false;
        }
    }
    //帮帮砍
    if ([type isEqualToString:@"helpCut"]) {
        if ([self isNull:self.activityModel.packageId]) {
            [Public alertWithType:MozAlertTypeError msg:@"请选择套餐"];
            return false;
        }
        if (!self.activityModel.settingNumberActivities || [self.activityModel.settingNumberActivities count] == 0) {
            [Public alertWithType:MozAlertTypeError msg:@"请设置帮帮砍规则"];
            return false;
        }
        if ([self isNull:self.activityModel.starTime]) {
            [Public alertWithType:MozAlertTypeError msg:@"请设置活动时间"];
            return false;
        }
        if ([self isNull:self.activityModel.limitTime]) {
            [Public alertWithType:MozAlertTypeError msg:@"请选择有效期"];
            return false;
        }
        
    }
    return true;
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
