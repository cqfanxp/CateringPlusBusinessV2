//
//  VerificationRecordsViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/1.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "VerificationRecordsViewController.h"
#import "VerificationRecordsCell.h"
#import "PrefixHeader.h"

@interface VerificationRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_dataResult;
    WKProgressHUD *_hud;
    
    //分页
    int _limit;//每页请求数量
    int _start;//开始行数
    int _total;//总行数
    
}

@end

@implementation VerificationRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"验证记录"];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh:)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreDropDown:)];
    
    //初始化
    _limit = 10;
    _start = 0;
    _dataResult = [[NSMutableArray alloc] init];
    
    //初始化加载数据
    [self loadNewData:nil];
}

//重新加载
-(void)reloadClick{
    _start = 0;
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
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}
//初始化数据
-(void)loadNewData:(id)header{
    //判断网络
    if (![Public isNetWork]) {
        _tableView.hidden = YES;
        self.imgInfoView.hidden = NO;
        [self.imgInfoView SetStatus:NoNetwork];
        return;
    }
    //判断是下拉刷新 还是第一次刷新
    if (header == nil) {
        _tableView.hidden = YES;
        self.imgInfoView.hidden = YES;
    }else{
        _tableView.hidden = NO;
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
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/orders/order/getValidateOrderRecordByTrue"] parameters:[Public getParams:param] success:^(id responseObject) {
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
                    [_dataResult addObject:dic];
                }
                _start += [tempArr count];
                _tableView.hidden = NO;
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

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataResult count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = [_dataResult objectAtIndex:indexPath.row];
    
    VerificationRecordsCell *cell = [[VerificationRecordsCell alloc] cellWithTableView:tableView];
    cell.numberLabel.text = [NSString stringWithFormat:@"编号：%@",item[@"orderNumber"]];
    cell.storesNameLabel.text = [NSString stringWithFormat:@"门店：%@",item[@"storeName"]];
    cell.activityNameLabel.text = item[@"activityName"];
    //时间处理
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH-mm"];
    NSDate *inputDate = [inputFormatter dateFromString:item[@"creationTime"]];
    
    [inputFormatter setDateFormat:@"yyyy.MM.dd"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [inputFormatter stringFromDate:inputDate];
    cell.timeLabel.text = currentDateStr;
    
    if ([item[@"activityType"] isEqualToString:@"10131001"]) {
        [cell.activityIconImgView setBackgroundColor:RGB(59, 212, 34)];
        [cell.activityIconImgView setTitle:@"抵" forState:UIControlStateNormal];
    }
    if ([item[@"activityType"] isEqualToString:@"10131002"]) {
        [cell.activityIconImgView setBackgroundColor:RGB(228, 77, 241)];
        [cell.activityIconImgView setTitle:@"折" forState:UIControlStateNormal];
    }
    if ([item[@"activityType"] isEqualToString:@"10131003"]) {
        [cell.activityIconImgView setBackgroundColor:RGB(45, 223, 208)];
        [cell.activityIconImgView setTitle:@"自" forState:UIControlStateNormal];
    }
    if ([item[@"activityType"] isEqualToString:@"10131004"]) {
        [cell.activityIconImgView setBackgroundColor:RGB(255, 66, 121)];
        [cell.activityIconImgView setTitle:@"拼" forState:UIControlStateNormal];
    }
    if ([item[@"activityType"] isEqualToString:@"10131005"]) {
        [cell.activityIconImgView setBackgroundColor:RGB(247, 135, 26)];
        [cell.activityIconImgView setTitle:@"砍" forState:UIControlStateNormal];
    }
    if ([item[@"activityType"] isEqualToString:@"10131006"]) {
        [cell.activityIconImgView setBackgroundColor:RGB(237, 114, 32)];
        [cell.activityIconImgView setTitle:@"减" forState:UIControlStateNormal];
    }
    if ([item[@"activityType"] isEqualToString:@"10131007"]) {
        [cell.activityIconImgView setBackgroundColor:RGB(227, 210, 26)];
        [cell.activityIconImgView setTitle:@"限" forState:UIControlStateNormal];
    }
    return cell;
}

#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

#pragma mark 选中行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
