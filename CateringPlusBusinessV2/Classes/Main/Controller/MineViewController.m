//
//  MineViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/18.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "MineViewController.h"
#import "PrefixHeader.h"

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
    cell.textLabel.text = item[@"name"];
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
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}

#pragma mark 设置尾部说明内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

@end
