//
//  ChooseSingleProductViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/30.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "ChooseSingleProductViewController.h"
#import "ChooseSingleProduct_CommodityCell.h"
#import "ChooseSingleProduct_ShoppingCartCell.h"
#import "EditSingleProductViewController.h"
#import "PrefixHeader.h"
#import "Commodity.h"

#define ROUNDSIZE 22 //圆点大小

@interface ChooseSingleProductViewController ()<UITableViewDelegate,UITableViewDataSource>{
    CALayer  *_layer;
    NSMutableArray *_dataResult;//所有单品数据
    WKProgressHUD *_hud;
    
    NSMutableDictionary *_checkData;//已选数据
    
    //分页
    int _limit;//每页请求数量
    int _start;//开始行数
    int _total;//总行数
}
@property (nonatomic,strong) UIBezierPath *path;
@end

@implementation ChooseSingleProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setTitle:@"选择单品"];
    
    _commodityTableView.delegate = self;
    _commodityTableView.dataSource = self;
    _commodityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _commodityTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh:)];
    _commodityTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreDropDown:)];
    
    _shoppingCartTableView.delegate = self;
    _shoppingCartTableView.dataSource = self;
    _shoppingCartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shoopingViewClick)];
    _shoppingView.userInteractionEnabled = YES;
    [_shoppingView addGestureRecognizer:tapGesture];
    
    //右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStyleDone target:self action:@selector(addClick)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    _shoppingView.hidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_shoppingChileView setFrame:CGRectMake(0, screen_height, screen_width,_shoppingChileView.layer.bounds.size.height)];
    });
    
    //初始化
    _limit = 20;
    _start = 0;
    _dataResult = [[NSMutableArray alloc] init];
    _checkData = [[NSMutableDictionary alloc] init];
    
    //加载已选数据
    if (_modifyCheckData) {
        for (Commodity *item in _modifyCheckData) {
            _checkData[item.identifies] = item;
        }
    }
    
    //更新购物栏
    [self updateShoppingColumn];
    //加载数据
    [self loadNewData:nil];
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
    [_commodityTableView.mj_header endRefreshing];
    [_commodityTableView.mj_footer endRefreshing];
}

//初始化数据
-(void)loadNewData:(id)header{
    //判断网络
    if (![Public isNetWork]) {
        _commodityTableView.hidden = YES;
        self.imgInfoView.hidden = NO;
        [self.imgInfoView SetStatus:NoNetwork];
        return;
    }
    //判断是下拉刷新 还是第一次刷新
    if (header == nil) {
        _commodityTableView.hidden = YES;
        self.imgInfoView.hidden = YES;
    }else{
        _commodityTableView.hidden = NO;
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
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/packages/singleProduct/GetAllSingelProduct"] parameters:[Public getParams:param] success:^(id responseObject) {
        
        [self endRefresh];
        if (_hud) {
            [_hud dismiss:YES];
        }
        NSArray *tempArr = responseObject[@"result"];
        if ([tempArr count] == 0 && [_dataResult count] == 0) {
            self.imgInfoView.hidden = NO;
            _commodityTableView.hidden = YES;
            [self.imgInfoView SetStatus:NoData];
        }else{
            for (NSDictionary *dic in tempArr) {
                Commodity *tempModel = [[Commodity alloc] initWithDic:dic];
                tempModel.singleFirstMapPath = dic[@"singleFirstMap"];
                tempModel.identifies = dic[@"id"];
                
                [_dataResult addObject:tempModel];
            }
            _start += [tempArr count];
            _commodityTableView.hidden = NO;
            [_commodityTableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        
        self.imgInfoView.hidden = NO;
        _commodityTableView.hidden = YES;
        [self.imgInfoView SetStatus:ServesError];
        
        if (_hud) {
            [_hud dismiss:YES];
        }
        [self endRefresh];
    }];
}

//刷新
-(void)reloadClick{
    _start = 0;
    [self loadNewData:nil];
}

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _commodityTableView) {
        return [_dataResult count];
    }else{
        return [[_checkData allValues] count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _commodityTableView) {
        
        Commodity *item = [_dataResult objectAtIndex:indexPath.row];
        
        //判断是否已在已选中
        if (_checkData && [[_checkData allKeys] containsObject:item.identifies]) {
            item.number = ((Commodity *)_checkData[item.identifies]).number;
        }
        
        ChooseSingleProduct_CommodityCell *cell = [[ChooseSingleProduct_CommodityCell alloc] cellWithTableView:tableView];
        cell.nameLabel.text = item.singleName;
        cell.unitLabel.text = [NSString stringWithFormat:@"单位：%@",item.unit];
        [cell.singMapImgView sd_setImageWithURL:[NSURL URLWithString:[BASEURL stringByAppendingString:item.singleFirstMapPath]] placeholderImage:[UIImage imageNamed:@"img_false"]];
        
        //控件按钮是否显示
        if (item.number == 0) {
            cell.lessBtn.hidden = YES;
            cell.number.hidden = YES;
        }else{
            cell.lessBtn.hidden = NO;
            cell.number.hidden = NO;
            cell.number.text = [NSString stringWithFormat:@"%d",item.number];
        }
        
        cell.shopCartBlock = ^(UIButton *plusBtn){
            NSLog(@"item:%@",item.singleName);
            CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
            rect.origin.y = rect.origin.y - [tableView contentOffset].y;
            CGRect headRect = plusBtn.frame;
            //cell.y+button.y=登录当前按钮的y位置
            headRect.origin.y = rect.origin.y+headRect.origin.y;
            [self startAnimationWithRect:headRect Button:plusBtn];
            //处理数据
            [self updateCheckData:item type:@"add"];
            item.number += 1;
            [_commodityTableView reloadData];
        };
        
        cell.shopCancelBlock = ^(UIButton *btn){
            //处理数据
            [self updateCheckData:item type:@"delete"];
            item.number -= 1;
            [_commodityTableView reloadData];
        };
        return cell;
    }else{
        Commodity *item = [[_checkData allValues] objectAtIndex:indexPath.row];
        ChooseSingleProduct_ShoppingCartCell *cell = [[ChooseSingleProduct_ShoppingCartCell alloc] cellWithTableView:tableView];
        cell.nameLabel.text = item.singleName;
        cell.numberLabel.text = [NSString stringWithFormat:@"%d",item.number];
        
        cell.shopCartBlock = ^(UIButton *plusBtn){
            //处理数据
            [self updateData:item type:@"add"];
        };
        
        cell.shopCancelBlock = ^(UIButton *btn){
            //处理数据
            [self updateData:item type:@"delete"];
        };
        
        return cell;
    }

}
//更新已选数据
-(void)updateCheckData:(Commodity *) commodity type:(NSString *)type{
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifies == %@",commodity.identifies];
//    NSArray *filteredArray = [_checkData filteredArrayUsingPredicate:predicate];
    
    NSString *key = commodity.identifies;
    
    if ([type isEqualToString:@"add"]) {
        bool isContain = [[_checkData allKeys] containsObject:key];
        if (isContain) {
            Commodity *tempCommodity = _checkData[key];
            tempCommodity.number += 1;
        }else{
            Commodity *temp = [[Commodity alloc] init];
            temp.identifies = commodity.identifies;
            temp.singleName = commodity.singleName;
            temp.number = 1;
            _checkData[temp.identifies] = temp;
        }
    }else{
        Commodity *temp = _checkData[key];
        if (temp.number > 1) {
            temp.number -= 1;
        }else{
            [_checkData removeObjectForKey:key];
        }
    }
    
    [self updateShoppingColumn];
}
//更新
-(void)updateData:(Commodity *) commodity type:(NSString *)type{
    NSString *key = commodity.identifies;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifies == %@",key];
    Commodity *temp = [_dataResult filteredArrayUsingPredicate:predicate].firstObject;
    
    if ([type isEqualToString:@"add"]) {
        temp.number += 1;
        commodity.number += 1;
    }else{
        temp.number -= 1;
        if (commodity.number == 1) {
            [_checkData removeObjectForKey:key];
        }else{
            commodity.number -= 1;
        }
    }
    [_shoppingCartTableView reloadData];
    [_commodityTableView reloadData];
    [self updateShoppingColumn];
}

//初始化CALayer
-(void)startAnimationWithRect:(CGRect)rect Button:(UIButton *)button
{
    if (!_layer) {
        _layer = [CALayer layer];
        _layer.backgroundColor = RGB(249, 215, 38).CGColor;
        
        _layer.bounds = CGRectMake(0, 0, ROUNDSIZE, ROUNDSIZE);
        [_layer setCornerRadius:ROUNDSIZE/2];
        _layer.masksToBounds = YES;
        //导航64
        _layer.position = CGPointMake(button.center.x, CGRectGetMidY(rect));
        [self.view.layer addSublayer:_layer];
        
        //动画路径
        self.path = [UIBezierPath bezierPath];
        [_path moveToPoint:_layer.position];
        [_path addQuadCurveToPoint:CGPointMake(40, screen_height-100) controlPoint:CGPointMake(screen_width/2, rect.origin.y-80)];
    }
    [self groupAnimation];
}
//创建动画组
-(void)groupAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.duration = 0.5f;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    [_layer addAnimation:animation forKey:@"animation"];
}

//动画执行完成
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (anim == [_layer animationForKey:@"animation"]) {
        [_layer removeFromSuperlayer];
        _layer = nil;
    }
}
#pragma mark 设置每行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _commodityTableView) {
        return 70;
    }else{
        return 50;
    }
}

#pragma mark 选中行事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark 点击购物车
- (IBAction)shopingBtnClick:(id)sender {
    if (_shoppingView.isHidden) {
        if ([_checkData count] == 0) {
            return;
        }
        [UIView animateWithDuration:0.5 animations:^{
            _shoppingView.hidden = NO;
            _shoppingChileView.frame = CGRectMake(0, screen_height-300-44, screen_width,_shoppingChileView.layer.bounds.size.height);
            _shoppingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.21];
        } completion:^(BOOL finished) {
            [_shoppingCartTableView reloadData];
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            _shoppingChileView.frame = CGRectMake(0, screen_height-44, screen_width,_shoppingChileView.layer.bounds.size.height);
            _shoppingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        } completion:^(BOOL finished) {
            _shoppingView.hidden = YES;
        }];
    }
}


#pragma mark 点击已添加的商品列表容器
-(void)shoopingViewClick{
    [UIView animateWithDuration:0.5 animations:^{
        _shoppingChileView.frame = CGRectMake(0, screen_height-44, screen_width,_shoppingChileView.layer.bounds.size.height);
        _shoppingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        _shoppingView.hidden = YES;
    }];
}

//添加单品
-(void)addClick{
    EditSingleProductViewController *viewController = (EditSingleProductViewController *)[Public getStoryBoardByController:@"PackageManagement" storyboardId:@"EditSingleProductViewController"];
    viewController.addSuccess = ^(Boolean success){
        [self reloadClick];
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//更新购物栏信息
-(void)updateShoppingColumn{
    _shoppingInfo.text = [NSString stringWithFormat:@"已选择%lu款",(unsigned long)[_checkData count]];
}
//清空
- (IBAction)clearShoppingClick:(id)sender {
    [_checkData removeAllObjects];
    [self updateShoppingColumn];
    
    //还原所有数据
    for (Commodity *item in _dataResult) {
        item.number = 0;
    }
    [_commodityTableView reloadData];
    
    [UIView animateWithDuration:0.5 animations:^{
        _shoppingChileView.frame = CGRectMake(0, screen_height-44, screen_width,_shoppingChileView.layer.bounds.size.height);
        _shoppingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        _shoppingView.hidden = YES;
    }];
}
//提交数据
- (IBAction)submitClick:(id)sender {
    if ([_checkData count] > 0) {
        self.resultDataBlock([_checkData allValues]);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [Public alertWithType:MozAlertTypeError msg:@"未选择任何商品"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
