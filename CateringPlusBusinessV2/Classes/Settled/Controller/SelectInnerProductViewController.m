//
//  SelectInnerProductViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/15.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "SelectInnerProductViewController.h"
#import "SelectInnerProductCell.h"
#import "PrefixHeader.h"
#import "NJKWebViewController.h"

@interface SelectInnerProductViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_dataResult;//result值
    NSArray *_dataChildeen;//子行业
}

@end

@implementation SelectInnerProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"选择品类"];
    
    //右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"开店手册" style:UIBarButtonItemStyleDone target:self action:@selector(shopmanualBtnClick)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    _innerProductTableView.dataSource = self;
    _innerProductTableView.delegate = self;
    _innerProductTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _childTableView.dataSource = self;
    _childTableView.delegate = self;
    _childTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initData];
}

//加载数据
-(void)initData{
    
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/businesses/business/getIndustry"] parameters:[Public getParams:nil] success:^(id responseObject) {
        _dataResult = responseObject[@"result"];
        [_innerProductTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _innerProductTableView) {
        return [_dataResult count];
    }else{
        return [_dataChildeen count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectInnerProductCell *cell = nil;
    
    if (tableView == _innerProductTableView) {
        NSDictionary *item = [_dataResult objectAtIndex:indexPath.row];
        cell = [[SelectInnerProductCell alloc] cellWithTableView:tableView text:item[@"name"]];
        cell.backgroundColor = RGB(240, 240, 240);
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGB(247, 247, 247);
        
    }else{
        NSDictionary *item = [_dataChildeen objectAtIndex:indexPath.row];
        cell = [[SelectInnerProductCell alloc] cellWithTableView:tableView text:item[@"name"]];
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
        //保存选中的行业
        NSDictionary *selectData = [_dataChildeen objectAtIndex:indexPath.row];
        
        if (_isResult) {
            _result(selectData);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [Public setUserDefaultKey:CATEGORYINFO value:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                          selectData[@"id"],@"id",
                                                          selectData[@"codeNumber"],@"codeNumber",
                                                          selectData[@"name"],@"name",nil]];
            UIViewController *viewController = [Public getStoryBoardByController:@"Settled" storyboardId:@"RegisteredViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }else{
        NSDictionary *item = [_dataResult objectAtIndex:indexPath.row];
        _dataChildeen = item[@"children"];
        [_childTableView reloadData];
    }
}

//开店手册
-(void)shopmanualBtnClick{
    NJKWebViewController *njkWeb = [[NJKWebViewController alloc] init];
    njkWeb.webTitle = @"开店手册";
    njkWeb.url = [BASEURL stringByAppendingString:@"/App/AppAction/OpenStore"];
    [self.navigationController pushViewController:njkWeb animated:YES];
}
@end
