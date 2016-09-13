//
//  SelectStores.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/13.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "SelectStores.h"
#import "SelectStoresCell.h"

@implementation SelectStores

-(void)awakeFromNib{
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectStoresCell *cell = [[SelectStoresCell alloc] cellWithTableView:tableView];;
    return cell;
}

#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark 选中行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
@end
