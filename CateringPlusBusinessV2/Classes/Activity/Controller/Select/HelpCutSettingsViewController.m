//
//  HelpCutSettingsViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/18.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "HelpCutSettingsViewController.h"
#import "HelpCutCell.h"
#import "HelpCutCellAddCell.h"
#import "PrefixHeader.h"
#import "HelpCutModel.h"

@interface HelpCutSettingsViewController ()<UITableViewDelegate,UITableViewDataSource>{
      NSMutableArray *_data;
}

@end

@implementation HelpCutSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"设置"];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(determineClick)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    if (_settingNumberActivities) {
        _data = [[NSMutableArray alloc] initWithArray:_settingNumberActivities];
        [_tableView reloadData];
    }else{
        _data = [[NSMutableArray alloc] init];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [_data count];
    }else{
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        HelpCutModel *item = [_data objectAtIndex:indexPath.row];
        
        HelpCutCell *cell = [[HelpCutCell alloc] cellWithTableView:tableView];
        cell.priceLabel.text = [NSString stringWithFormat:@"%@元",item.price];
        cell.numberPeopleLabel.text = [NSString stringWithFormat:@"%@人",item.peopleNumber];
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteHelpCut:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{
        HelpCutCellAddCell *cell = [[HelpCutCellAddCell alloc] cellWithTableView:tableView];
        [cell.addBtn addTarget:self action:@selector(addHelpCut:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }else{
        return 60;
    }
}

#pragma mark 选中行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
//确定
-(void)determineClick{
    if ([_data count] == 0) {
        [Public alertWithType:MozAlertTypeError msg:@"请设置人数和价格"];
        return;
    }
    self.resultData(_data);
    [self.navigationController popViewControllerAnimated:YES];
}

-(AddHelpCut *)addHelpCut{
    if (!_addHelpCut) {
        _addHelpCut = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AddHelpCut class]) owner:self options:nil].lastObject;
        _addHelpCut.frame = CGRectMake(0, 0, screen_width, screen_height);
        _addHelpCut.hidden = YES;
        _addHelpCut.resultData = ^(HelpCutModel *item){
            [_data addObject:item];
            [_tableView reloadData];
        };
        [self.view addSubview:_addHelpCut];

    }
    return _addHelpCut;
}

//添加
-(void)addHelpCut:(UIButton *)btn{
    self.addHelpCut.priceField.text = @"";
    self.addHelpCut.numberPeopleField.text = @"";
    self.addHelpCut.hidden = NO;
}
//删除
-(void)deleteHelpCut:(UIButton *)btn{
    HelpCutModel *item = [_data objectAtIndex:btn.tag];
    [_data removeObject:item];
    
    [_tableView reloadData];
}
@end
