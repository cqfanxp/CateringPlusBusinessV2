//
//  SelectBankViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/6.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "SelectBankViewController.h"
#import "SelectBankCell.h"
#import "PrefixHeader.h"

@interface SelectBankViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_dataResult;
}

@end

@implementation SelectBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self setTitle:@"选择银行"];
    
    [self initData];
}
//初始化数据
-(void)initData{
    
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/publics/public/getBankList"] parameters:[Public getParams:nil] success:^(id responseObject) {
        _dataResult = responseObject[@"result"];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[_dataResult objectAtIndex:section] objectForKey:@"bankList"] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataResult count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = [[[_dataResult objectAtIndex:indexPath.section] objectForKey:@"bankList"] objectAtIndex:indexPath.row];
    SelectBankCell *cell = [[SelectBankCell alloc] cellWithTableView:tableView];
    cell.nameLabel.text = item[@"bankIntro"];
    
    [cell.iconImgView sd_setImageWithURL:[NSURL URLWithString:[BASEURL stringByAppendingString:item[@"bankIcon"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
    return cell;
}

#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
#pragma mark 选中行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = [[[_dataResult objectAtIndex:indexPath.section] objectForKey:@"bankList"] objectAtIndex:indexPath.row];
    [self.delegate selectBankResult:item];
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

#pragma mark 设置尾部说明内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_dataResult objectAtIndex:section] objectForKey:@"title"];
}

@end
