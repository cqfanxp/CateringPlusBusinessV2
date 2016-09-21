//
//  SelectPackageViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/13.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "SelectPackageViewController.h"
#import "PackageEditViewController.h"
#import "SelectPackageCell.h"

@interface SelectPackageViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_dataResult;
    WKProgressHUD *_hud;
    
    //分页
    int _limit;//每页请求数量
    int _start;//开始行数
    int _total;//总行数
}

@end

@implementation SelectPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStyleDone target:self action:@selector(addClick)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self setTitle:@"选择套餐"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化
    _limit = 10;
    _start = 0;
    _dataResult = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.tableView];
    
    [self loadNewData:nil];
}

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataResult count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Package *item = [_dataResult objectAtIndex:indexPath.row];
    
    SelectPackageCell *cell = [[SelectPackageCell alloc] cellWithTableView:tableView];
    cell.packageNameLabel.text = item.packageName;
    [cell.packageFirstMapImgView sd_setImageWithURL:[NSURL URLWithString:[BASEURL stringByAppendingString:item.packageFirstMap]] placeholderImage:[UIImage imageNamed:@"img_false"]];

    return cell;
}

#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
#pragma mark 选中行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Package *item = [_dataResult objectAtIndex:indexPath.row];
    self.resultData(item);
    [self.navigationController popViewControllerAnimated:YES];
}

//添加套餐管理
-(void)addClick{
    PackageEditViewController *viewController = (PackageEditViewController *)[Public getStoryBoardByController:@"PackageManagement" storyboardId:@"PackageEditViewController"];
    viewController.saveSuccess = ^(Boolean success){
        self.imgInfoView.hidden = YES;
        _tableView.hidden = NO;
        _start = 0;
        [self loadNewData:nil];
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

//初始化tableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.hidden = YES;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh:)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreDropDown:)];
    }
    return _tableView;
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
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}
//初始化数据
-(void)loadNewData:(id)header{
    if ([Public isNetWork]) {
        _tableView.hidden = NO;
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
                _tableView.hidden = YES;
                [self.imgInfoView SetStatus:NoData];
            }else{
                for (NSDictionary *dic in tempArr) {
                    Package *temp = [[Package alloc] initWithDic:dic];
                    temp.identifies = dic[@"packageId"];
                    [_dataResult addObject:temp];
                }
                _start += [tempArr count];
                [_tableView reloadData];
            }
        }else{
            NSLog(@"error:%@",responseObject[@"message"]);
            [self.imgInfoView SetStatus:ServesError];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        
        self.imgInfoView.hidden = NO;
        _tableView.hidden = YES;
        [self.imgInfoView SetStatus:ServesError];
        
        if (_hud) {
            [_hud dismiss:YES];
        }
        [self endRefresh];
    }];
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
