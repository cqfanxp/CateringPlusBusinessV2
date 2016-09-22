//
//  SelectStores.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/13.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "SelectStores.h"
#import "SelectStoresCell.h"
#import "Stoer.h"

@interface SelectStores(){
    NSMutableArray *_dataResult;
}

@end

@implementation SelectStores

-(void)awakeFromNib{
    [super awakeFromNib];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _dataResult = [[NSMutableArray alloc] init];
    
    [self loadNewData];
}

//初始化数据
-(void)loadNewData{
    //用户信息
    NSDictionary *userInfo = [Public getUserDefaultKey:USERINFO];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  userInfo[@"id"],@"BusUserId",
                                  @"10071004",@"busState",nil];
    
    WKProgressHUD *hud = [WKProgressHUD showInView:self withText:nil animated:YES];
    
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/stores/store/getAllStoreList"] parameters:[Public getParams:param] success:^(id responseObject) {
        
        [hud dismiss:YES];
        
        if ([responseObject[@"success"] boolValue]) {
            
            for (NSDictionary *dic in responseObject[@"result"]) {
                Stoer *tempStoer = [[Stoer alloc] initWithDic:dic];
                tempStoer.latitude = [dic[@"latitude"] floatValue];
                tempStoer.longitude = [dic[@"longitude"] floatValue];
                
                if (_selectData) {
                    for (NSDictionary *tempDic in _selectData) {
                        if ([tempDic[@"id"] isEqualToString:tempStoer.storeId]) {
                            tempStoer.isSelect = YES;
                            continue;
                        }
                    }
                }
                
                [_dataResult addObject:tempStoer];
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        
    }];
}

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataResult count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Stoer *item = [_dataResult objectAtIndex:indexPath.row];
    
    SelectStoresCell *cell = [[SelectStoresCell alloc] cellWithTableView:tableView];
    cell.busNameLabel.text = item.busName;
    cell.storeAddressLabel.text = item.storeAddress;
    
    
    
    if (item.isSelect) {
        [cell.statusImgView setImage:[UIImage imageNamed:@"yes_bule"]];
    }else{
        [cell.statusImgView setImage:[UIImage imageNamed:@"yes_gray"]];
    }
    
    [cell.storeFirstMapImgView sd_setImageWithURL:[NSURL URLWithString:[BASEURL stringByAppendingString:item.picture]] placeholderImage:[UIImage imageNamed:@"img_false"]];
    return cell;
}

#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark 选中行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Stoer *item = [_dataResult objectAtIndex:indexPath.row];
    
    item.isSelect = !item.isSelect;
    
    [_tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
//取消
- (IBAction)cencelClick:(id)sender {
    self.hidden = YES;
}

//确定
- (IBAction)determineClick:(id)sender {
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (Stoer *item in _dataResult) {
        if (item.isSelect) {
            [tempArr addObject:item];
        }
    }
    self.resultData(tempArr);
    self.hidden = YES;
}

@end
