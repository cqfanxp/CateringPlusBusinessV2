//
//  BusinessSchoolViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/18.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "BusinessSchoolViewController.h"
#import "BusinessSchoolCell.h"
#import "PrefixHeader.h"
#import "BusinessSchool.h"
#import "NJKWebViewController.h"

@interface BusinessSchoolViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_dataResult;
    WKProgressHUD *_hud;
    
    //分页
    int _limit;//每页请求数量
    int _start;//开始行数
    int _total;//总行数
}

@end

@implementation BusinessSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _TableView.dataSource = self;
    _TableView.delegate = self;
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh:)];
    _TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreDropDown:)];
    
    //初始化
    _limit = 10;
    _start = 0;
    _dataResult = [[NSMutableArray alloc] init];
    
    [self loadNewData:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]){
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
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
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/articles/article/getBusExperienceList"] parameters:[Public getParams:param] success:^(id responseObject) {
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
                    
                    BusinessSchool *temp = [[BusinessSchool alloc] initWithDic:dic];
                    temp.identifies = dic[@"id"];
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
    BusinessSchool *item = [_dataResult objectAtIndex:indexPath.row];
    
    BusinessSchoolCell *cell = [[BusinessSchoolCell alloc] cellWithTableView:tableView text:@"美食"];;
    cell.titleLabel.text = item.title;
    cell.summaryLabel.text = item.summary;
    cell.shareNumberLabel.text = [NSString stringWithFormat:@"%@",item.likeNumber];
    
    //时间处理
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH-mm"];
    NSDate *inputDate = [inputFormatter dateFromString:item.creationTime];
    
    [inputFormatter setDateFormat:@"MM.dd"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [inputFormatter stringFromDate:inputDate];
    cell.timeLabel.text = currentDateStr;
    
    
    if ([item.isLike boolValue]) {
        cell.likeImgView.image = [UIImage imageNamed:@"praise_black"];
    }else{
        cell.likeImgView.image = [UIImage imageNamed:@"praise"];
    }
    
    
    [cell.likeBtn addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    cell.likeBtn.tag = indexPath.row;
    [cell.shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    cell.shareBtn.tag = indexPath.row;
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[BASEURL stringByAppendingString:item.mapUrl]] placeholderImage:[UIImage imageNamed:@"img_false"]];
    return cell;
}

#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
#pragma mark 选中行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessSchool *item = [_dataResult objectAtIndex:indexPath.row];
    
    NJKWebViewController *njkWeb = [[NJKWebViewController alloc] init];
    njkWeb.webTitle = item.title;
    njkWeb.url = [NSString stringWithFormat:@"%@/App/AppAction/BusExperience/%@",BASEURL,item.identifies];
    [self.navigationController pushViewController:njkWeb animated:YES];
}

//分享
-(void)share:(UIButton *)btn{
    BusinessSchool *item = [_dataResult objectAtIndex:btn.tag];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:item.summary
//                                     images:@[[UIImage imageNamed:[BASEURL stringByAppendingString:item.mapUrl]]]
                                     images:@[[UIImage imageNamed:@"logoShare.png"]]
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/App/AppAction/BusExperience/%@",BASEURL,item.identifies]]
                                      title:item.title
                                       type:SSDKContentTypeAuto];
    [Public share:shareParams];
}

//点赞
-(void)like:(UIButton *)btn{
    BusinessSchool *item = [_dataResult objectAtIndex:btn.tag];
    if ([item.isLike boolValue]) {
        return;
    }
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   userInfo[@"id"],@"busUserId",
                                   item.identifies,@"articleId",
                                   nil];
    
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:nil animated:YES];
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/articles/article/likeArticle"] parameters:[Public getParams:params] success:^(id responseObject) {
        [hud dismiss:YES];
        if ([responseObject[@"success"] boolValue]) {
            item.isLike = [NSNumber numberWithBool:YES];
            item.likeNumber = [NSNumber numberWithInt:([item.likeNumber intValue]+1)];
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
