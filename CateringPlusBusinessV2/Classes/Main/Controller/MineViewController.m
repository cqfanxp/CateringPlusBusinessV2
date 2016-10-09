//
//  MineViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/18.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "MineViewController.h"
#import "PrefixHeader.h"
#import "NJKWebViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_appData;
}

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _toolTableView.delegate = self;
    _toolTableView.dataSource = self;
    
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark 初始化数据
-(void)initData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //获得所有应用数据
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mine_tool" ofType:@"plist"];
        _appData = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_toolTableView reloadData];
        });
    });
}

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_appData objectAtIndex:(section)] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_appData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"mineCellKey";
    
    NSDictionary *item = [[_appData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([item.allKeys containsObject:@"key"]) {
        //用户信息
        NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
        cell.textLabel.text = userInfo[@"account"];
    }else{
        cell.textLabel.text = item[@"name"];
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.font = [UIFont systemFontOfSize:20];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = RGB(51, 51, 51);
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    if ([item objectForKey:@"detail"]) {
        cell.detailTextLabel.text = item[@"detail"];
    }
//    if ([item objectForKey:@"icon"]) {
//        cell.imageView.image = [UIImage imageNamed:item[@"icon"]];
//        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    }
    
    return cell;
}

#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70;
    }else{
        return 44;
    }
}
#pragma mark 选中行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = [[_appData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSString *title = item[@"name"];
    
    if ([item.allKeys containsObject:@"controller"] && ![item[@"controller"] isEqualToString:@""]) {
        UIViewController *viewController = [Public getStoryBoardByController:@"SetUp" storyboardId:item[@"controller"]];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    if ([title isEqualToString:@"客服热线"]) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-0236903"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
    if ([title isEqualToString:@"推荐给朋友"]) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"参+：【互联网推广专家】——吃喝玩乐折扣大平台，帮所有入驻平台商家参谋，急商家所急！解商家所难！参+平台为商家推广宣传引流用户，实现马上盈利，持续盈利！现在入驻可享前3个月免费推广期！参+免费帮您建设专属自己的网店！"
                                         images:@[[UIImage imageNamed:@"logoShare.png"]]
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/App/AppAction/ShareApp",BASEURL]]
                                          title:@"参+【互联网推广专家】"
                                           type:SSDKContentTypeAuto];
        [Public share:shareParams];
    }
    
    if ([title isEqualToString:@"活动规则介绍"]) {
        NJKWebViewController *njkWeb = [[NJKWebViewController alloc] init];
        njkWeb.webTitle = @"活动规则介绍";
        njkWeb.url = [BASEURL stringByAppendingString:@"/App/AppAction/RuleIntroduction"];
        [self.navigationController pushViewController:njkWeb animated:YES];
    }
    
    if ([title isEqualToString:@"关于我们"]) {
        NJKWebViewController *njkWeb = [[NJKWebViewController alloc] init];
        njkWeb.webTitle = @"关于我们";
        njkWeb.url = [BASEURL stringByAppendingString:@"/App/AppAction/AboutUs"];
        [self.navigationController pushViewController:njkWeb animated:YES];
    }
    if ([title isEqualToString:@"退出登录"]) {
        //清除登录信息
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:USERINFO];
        
        UIViewController  *viewController = [Public getStoryBoardByController:@"OAuth" storyboardId:@"LoginViewController"];
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:navigation animated:NO completion:nil];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}

#pragma mark 设置尾部说明内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

@end
