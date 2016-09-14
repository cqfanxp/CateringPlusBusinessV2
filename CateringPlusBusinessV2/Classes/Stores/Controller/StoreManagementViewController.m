//
//  StoreManagementViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/19.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "StoreManagementViewController.h"
#import "StoreManagementCell.h"
#import "EditStoreViewController.h"
#import "Stoer.h"
#import "EntityHelper.h"

@interface StoreManagementViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_dataResult;
    WKProgressHUD *_hud;
}

@end

@implementation StoreManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStyleDone target:self action:@selector(addClick)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    _dataResult = [[NSMutableArray alloc] init];
    
    _TableView.dataSource = self;
    _TableView.delegate = self;
    _TableView.hidden = YES;
    _TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    }];
    _TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData:)];
    
    [self loadNewData:nil];
}
//初始化数据
-(void)loadNewData:(MJRefreshNormalHeader *)header{
    if ([Public isNetWork]) {
        _TableView.hidden = NO;
    }else{
        self.imgInfoView.hidden = NO;
    }
    [_dataResult removeAllObjects];
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  userInfo[@"id"],@"BusUserId",
                                  @"",@"busState",nil];
    if (header == nil) {
        _hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    }
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/stores/store/getAllStoreList"] parameters:[Public getParams:param] success:^(id responseObject) {
        
        [_TableView.mj_header endRefreshing];
        if (_hud) {
            [_hud dismiss:YES];
        }
        NSArray *tempArr = responseObject[@"result"];
        if ([tempArr count] == 0) {
            self.imgInfoView.hidden = NO;
            _TableView.hidden = YES;
            [self.imgInfoView SetStatus:NoData];
        }else{
            for (NSDictionary *dic in tempArr) {
                Stoer *tempStoer = [[Stoer alloc] initWithDic:dic];
                tempStoer.latitude = [dic[@"latitude"] floatValue];
                tempStoer.longitude = [dic[@"longitude"] floatValue];
                
                [_dataResult addObject:tempStoer];
            }
            [_TableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        
        self.imgInfoView.hidden = NO;
        _TableView.hidden = YES;
        [self.imgInfoView SetStatus:ServesError];
        
        if (_hud) {
            [_hud dismiss:YES];
        }
        [_TableView.mj_header endRefreshing];
    }];
}
//重新加载
-(void)reloadClick{
    self.imgInfoView.hidden = YES;
    _TableView.hidden = NO;
    [self loadNewData:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataResult count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Stoer *item = [_dataResult objectAtIndex:indexPath.row];
    
    StoreManagementCell *cell = [[StoreManagementCell alloc] cellWithTableView:tableView];
    
    cell.titleLabel.text = item.busName;
    cell.addressLabel.text = item.storeAddress;
    [cell.statusBtn setTitle:item.busStateValue forState:UIControlStateNormal];
    
    [cell.iconImgView sd_setImageWithURL:[NSURL URLWithString:[BASEURL stringByAppendingString:item.picture]] placeholderImage:[UIImage imageNamed:@"img_false"]];
    return cell;
}

#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

#pragma mark 选中行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Stoer *item = [_dataResult objectAtIndex:indexPath.row];
    EditStoreViewController *viewController = (EditStoreViewController *)[Public getStoryBoardByController:@"Stores" storyboardId:@"EditStoreViewController"];
    viewController.store = item;
    viewController.addSuccess = ^(Boolean success){
        self.imgInfoView.hidden = YES;
        _TableView.hidden = NO;
        [self loadNewData:nil];
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

//添加
-(void)addClick{
    EditStoreViewController *viewController = (EditStoreViewController *)[Public getStoryBoardByController:@"Stores" storyboardId:@"EditStoreViewController"];
    viewController.addSuccess = ^(Boolean success){
        self.imgInfoView.hidden = YES;
        _TableView.hidden = NO;
        [self loadNewData:nil];
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
