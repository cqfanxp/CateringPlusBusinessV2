//
//  PackageListViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/22.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "PackageListViewController.h"
#import "PackageListCell.h"
#import "PackageEditViewController.h"
#import "Package.h"

@interface PackageListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_dataResult;
    WKProgressHUD *_hud;
    
    //分页
    int _limit;//每页请求数量
    int _start;//开始行数
    int _total;//总行数
}

@end

@implementation PackageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setTitle:@"套餐管理"];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //初始化
    _limit = 10;
    _start = 0;
    _dataResult = [[NSMutableArray alloc] init];
    _dataResult = [[NSMutableArray alloc] init];
    
    _TableView.dataSource = self;
    _TableView.delegate = self;
    _TableView.hidden = YES;
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//    }];
    _TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh:)];
    _TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreDropDown:)];
    
    //右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStyleDone target:self action:@selector(addClick)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
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
    if ([Public isNetWork]) {
        _TableView.hidden = NO;
    }else{
        self.imgInfoView.hidden = NO;
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
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/packages/package/getPackageList"] parameters:[Public getParams:param] success:^(id responseObject) {
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
                    Package *temp = [[Package alloc] initWithDic:dic];
                    temp.identifies = dic[@"packageId"];
                    [_dataResult addObject:temp];
                }
                _start += [tempArr count];
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

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataResult count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Package *item = [_dataResult objectAtIndex:indexPath.row];
    
    PackageListCell *cell = [[PackageListCell alloc] cellWithTableView:tableView];
    cell.nameLabel.text = item.packageName;
    [cell.packageImgView sd_setImageWithURL:[NSURL URLWithString:[BASEURL stringByAppendingString:item.packageFirstMap]] placeholderImage:[UIImage imageNamed:@"img_false"]];
    
    cell.updateBtn.tag = indexPath.row;
    cell.deleteBtn.tag = indexPath.row;
    
    //注册事件
    [cell.updateBtn addTarget:self action:@selector(modifyData:) forControlEvents:UIControlEventTouchUpInside];
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

//添加套餐管理
-(void)addClick{
    PackageEditViewController *viewController = (PackageEditViewController *)[Public getStoryBoardByController:@"PackageManagement" storyboardId:@"PackageEditViewController"];
    viewController.saveSuccess = ^(Boolean success){
        self.imgInfoView.hidden = YES;
        _TableView.hidden = NO;
        [self loadNewData:nil];
    };
    [self.navigationController pushViewController:viewController animated:YES];
}
//修改数据
-(void)modifyData:(UIButton *)btn{
    Package *item = [_dataResult objectAtIndex:btn.tag];
    PackageEditViewController *viewController = (PackageEditViewController *)[Public getStoryBoardByController:@"PackageManagement" storyboardId:@"PackageEditViewController"];
    viewController.package = item;
    viewController.saveSuccess = ^(Boolean success){
        self.imgInfoView.hidden = YES;
        _TableView.hidden = NO;
        [self loadNewData:nil];
    };
    [self.navigationController pushViewController:viewController animated:YES];
}
//删除数据
-(void)deleteData:(UIButton *)btn{
    Package *item = [_dataResult objectAtIndex:btn.tag];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  item.identifies,@"packageId",nil];
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/packages/package/deletePackage"] parameters:[Public getParams:param] success:^(id responseObject) {
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
       [Public alertWithType:MozAlertTypeError msg:[NSString stringWithFormat:@"%@",error]];
    }];

    
}

//重新加载
-(void)reloadClick{
    self.imgInfoView.hidden = YES;
    _TableView.hidden = NO;
    [self loadNewData:nil];
}
@end
