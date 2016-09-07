//
//  StoreManagementViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/19.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "StoreManagementViewController.h"
#import "StoreManagementCell.h"
#import "PrefixHeader.h"

@interface StoreManagementViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_dataResult;
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
    
    _TableView.dataSource = self;
    _TableView.delegate = self;
    _TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    }];
    _TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [_TableView.mj_header beginRefreshing];
}
//初始化数据
-(void)loadNewData{
    
    // 马上进入刷新状态
//    [_TableView.header beginRefreshing];
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  userInfo[@"id"],@"BusUserId",nil];
    
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/stores/store/getAllStoreList"] parameters:[Public getParams:param] success:^(id responseObject) {
        _dataResult = responseObject[@"result"];
        [_TableView reloadData];
        [_TableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        [_TableView.mj_header endRefreshing];
    }];
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
    
    NSDictionary *item = [_dataResult objectAtIndex:indexPath.row];
    
    StoreManagementCell *cell = [[StoreManagementCell alloc] cellWithTableView:tableView];
    cell.titleLabel.text = item[@"busName"];
    cell.addressLabel.text = item[@"storeAddress"];
    
    [cell.iconImgView sd_setImageWithURL:[NSURL URLWithString:[BASEURL stringByAppendingString:item[@"picture"]]] placeholderImage:[UIImage imageNamed:@"img_false"]];
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
    
}

//添加
-(void)addClick{
    
}

@end
