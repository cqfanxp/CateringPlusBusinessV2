//
//  ActivityListViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/22.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityListCell.h"
#import "ActivityEditViewController.h"

@interface ActivityListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_dataResult;
    WKProgressHUD *_hud;
    
    //活动数据地址
    NSDictionary *_activityUrl;
    
    //分页
    int _limit;//每页请求数量
    int _start;//开始行数
    int _total;//总行数
}

@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setTitle:@"活动"];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _TableView.dataSource = self;
    _TableView.delegate = self;
    _TableView.hidden = YES;
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh:)];
    _TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreDropDown:)];
    
    //右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStyleDone target:self action:@selector(addActivity)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //初始化活动数据地址
    _activityUrl = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [ActivityUrlModel initWithFindUrl:@"/api/activities/customize/GetCustomizeList" deleteUrl:@"/api/activities/customize/deleteCustomize"],@"customEvents",//自定义活动
                                        [ActivityUrlModel initWithFindUrl:@"/api/activities/lessSpending/getLessSpendingList" deleteUrl:@"/api/activities/lessSpending/deleteLessSpending"],@"lessSpending",//消费满减
                                        [ActivityUrlModel initWithFindUrl:@"/api/activities/limitedPreferential/getLimitedPreferentialList" deleteUrl:@"/api/activities/limitedPreferential/deleteLimitedPreferential"],@"limitedTimeOffer",//限时优惠
                                        [ActivityUrlModel initWithFindUrl:@"/api/activities/arrivedCoupons/getArrivedCouponsList" deleteUrl:@"/api/activities/arrivedCoupons/deleteArrivedCoupons"],@"volumeDeductible",//抵扣券
                                        [ActivityUrlModel initWithFindUrl:@"/api/activities/coupons/getCouponsList" deleteUrl:@"/api/activities/coupons/deleteCoupons"],@"volumeDiscounts",//折扣劵
                                        [ActivityUrlModel initWithFindUrl:@"/api/activities/friendsHelp/getFriendsHelpList" deleteUrl:@"/api/activities/friendsHelp/deleteFriendsHelp"],@"helpCut",//好有帮帮砍
                                        [ActivityUrlModel initWithFindUrl:@"/api/activities/fightAlone/getFightAloneList" deleteUrl:@"/api/activities/fightAlone/deleteFightAlone"],@"fightAlone",nil];//拼单
    
    //初始化
    _limit = 10;
    _start = 0;
    _dataResult = [[NSMutableArray alloc] init];
    
    //初始化加载数据
    [self loadNewData:nil];
}

//下拉刷新
-(void)pullRefresh:(MJRefreshNormalHeader *)header{
    _start = 0;
    [self loadNewData:header];
}
//上拉更多
-(void)moreDropDown:(MJRefreshBackNormalFooter *)food{
    [self loadNewData:food];
}

/**
 *  停止刷新
 */
-(void)endRefresh{
    [_TableView.mj_header endRefreshing];
    [_TableView.mj_footer endRefreshing];
}
//初始化数据
-(void)loadNewData:(id)header{
    //判断网络
    if (![Public isNetWork]) {
        _TableView.hidden = YES;
        self.imgInfoView.hidden = NO;
        [self.imgInfoView SetStatus:NoNetwork];
        return;
    }
    //判断是下拉刷新 还是第一次刷新
    if (header == nil) {
        _TableView.hidden = YES;
        self.imgInfoView.hidden = YES;
    }else{
        _TableView.hidden = NO;
        self.imgInfoView.hidden = YES;
    }
    
    if (_start == 0) {
        [_dataResult removeAllObjects];
    }
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  userInfo[@"id"],@"BusUserId",
                                  [NSNumber numberWithInt:_limit],@"Limit",
                                  [NSNumber numberWithInt:_start],@"Start",nil];
    
    if (header == nil) {
        _hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    }
    ActivityUrlModel *activityUrlModel = [_activityUrl objectForKey:self.featuresData[@"plistName"]];
    
    [NetWorkUtil post:[BASEURL stringByAppendingString:activityUrlModel.findUrl] parameters:[Public getParams:param] success:^(id responseObject) {
        [self endRefresh];
        if (_hud) {
            [_hud dismiss:YES];
        }
        if ([responseObject[@"success"] boolValue]) {
            NSArray *tempArr = responseObject[@"result"];
            if ([tempArr count] == 0 && [_dataResult count] == 0) {
                self.imgInfoView.hidden = NO;
                _TableView.hidden = YES;
                [self.imgInfoView SetStatus:NoData];
            }else{
                for (NSDictionary *dic in tempArr) {
                    ActivityModel *temp = [[ActivityModel alloc] initWithDic:dic];
                    temp.identifies = dic[@"id"];
                    temp.useNumber = [dic[@"useNumber"] longValue];
                    [_dataResult addObject:temp];
                }
                _start += [tempArr count];
                _TableView.hidden = NO;
                [_TableView reloadData];
            }
        }else{
            NSLog(@"error:%@",responseObject[@"message"]);
            [self.imgInfoView SetStatus:ServesError];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        
        self.imgInfoView.hidden = NO;
        _TableView.hidden = YES;
        [self.imgInfoView SetStatus:ServesError];
        
        if (_hud) {
            [_hud dismiss:YES];
        }
        [self endRefresh];
    }];
}

//重新加载
-(void)reloadClick{
    _start = 0;
    [self loadNewData:nil];
}

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataResult count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityModel *item = [_dataResult objectAtIndex:indexPath.row];
    
    ActivityListCell *cell = [[ActivityListCell alloc] cellWithTableView:tableView];;
    cell.titleLabel.text = item.title;
    cell.stateLabel.text = item.stateValue;
    
    cell.useNumberLabel.text = [NSString stringWithFormat:@"已领：%ld次",item.useNumber];
    [cell.firstMapImgView sd_setImageWithURL:[NSURL URLWithString:[BASEURL stringByAppendingString:item.image]] placeholderImage:[UIImage imageNamed:@"img_false"]];
    
    //修改
    cell.modifyBtn.tag = indexPath.row;
    [cell.modifyBtn addTarget:self action:@selector(modifyData:) forControlEvents:UIControlEventTouchUpInside];
    //删除
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteData:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

#pragma mark 选中行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//添加活动
-(void)addActivity{
    ActivityEditViewController *activityEdit = (ActivityEditViewController *)[Public getStoryBoardByController:@"Activity" storyboardId:@"ActivityEditViewController"];
    activityEdit.plistName =self.featuresData[@"plistName"];
    activityEdit.saveSuccess = ^(Boolean success){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadClick];
        });
    };
    [self.navigationController pushViewController:activityEdit animated:YES];
}
//修改活动数据
-(void)modifyData:(UIButton *)btn{
    ActivityModel *item = [_dataResult objectAtIndex:btn.tag];
    ActivityEditViewController *activityEdit = (ActivityEditViewController *)[Public getStoryBoardByController:@"Activity" storyboardId:@"ActivityEditViewController"];
    activityEdit.plistName =self.featuresData[@"plistName"];
    activityEdit.activityModel = item;
    activityEdit.saveSuccess = ^(Boolean success){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadClick];
        });
    };
    [self.navigationController pushViewController:activityEdit animated:YES];
    
}
//删除活动
-(void)deleteData:(UIButton *)btn{
    ActivityModel *item = [_dataResult objectAtIndex:btn.tag];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString *plistName = self.featuresData[@"plistName"];
    
    //定义活动
    if ([plistName isEqualToString:@"customEvents"]) {
        params[@"customizeId"] = item.identifies;
    }
    //消费满减
    if ([plistName isEqualToString:@"lessSpending"]) {
        params[@"lessSpendingId"] = item.identifies;
    }
    //限时优惠
    if ([plistName isEqualToString:@"limitedTimeOffer"]) {
        params[@"limitedPreferentialId"] = item.identifies;
    }
    //抵扣券
    if ([plistName isEqualToString:@"volumeDeductible"]) {
        params[@"arrivedCouponsId"] = item.identifies;
    }
    //折扣劵
    if ([plistName isEqualToString:@"volumeDiscounts"]) {
        params[@"couponsId"] = item.identifies;
    }
    //拼团
    if ([plistName isEqualToString:@"fightAlone"]) {
        params[@"fightAloneId"] = item.identifies;
    }
    //帮帮砍
    if ([plistName isEqualToString:@"helpCut"]) {
        params[@"friendsHelpId"] = item.identifies;
    }
    
    ActivityUrlModel *activityUrlModel = [_activityUrl objectForKey:self.featuresData[@"plistName"]];
    
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    
    [NetWorkUtil post:[BASEURL stringByAppendingString:activityUrlModel.deleteUrl] parameters:[Public getParams:params] success:^(id responseObject) {
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            [Public alertWithType:MozAlertTypeSuccess msg:responseObject[@"message"]];
            [_dataResult removeObject:item];
            [_TableView reloadData];
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
