//
//  SelectInnerProductViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/15.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "SelectInnerProductViewController.h"
#import "SelectInnerProductCell.h"

@interface SelectInnerProductViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SelectInnerProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"选择品内"];
    
    //右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"开店手册" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    _innerProductTableView.dataSource = self;
    _innerProductTableView.delegate = self;
    _innerProductTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _childTableView.dataSource = self;
    _childTableView.delegate = self;
    _childTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectInnerProductCell *cell = nil;
    
    if (tableView == _innerProductTableView) {
        cell = [[SelectInnerProductCell alloc] cellWithTableView:tableView text:@"美食"];
        cell.backgroundColor = RGB(240, 240, 240);
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGB(247, 247, 247);
        
    }else{
        cell = [[SelectInnerProductCell alloc] cellWithTableView:tableView text:@"火锅"];
        cell.backgroundColor = RGB(247, 247, 247);
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
#pragma mark 选中行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _childTableView) {
        UIViewController *viewController = [Public getStoryBoardByController:@"Settled" storyboardId:@"RegisteredViewController"];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
