//
//  ActivityListViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/22.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityListCell.h"

@interface ActivityListViewController ()<UITableViewDataSource,UITableViewDelegate>

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
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ActivityListCell *cell = [[ActivityListCell alloc] cellWithTableView:tableView text:@"美食"];;
    
    return cell;
}

#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

#pragma mark 选中行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
