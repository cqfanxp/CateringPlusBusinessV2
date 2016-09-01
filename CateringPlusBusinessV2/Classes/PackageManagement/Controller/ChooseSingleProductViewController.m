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
#import "PrefixHeader.h"

#define ROUNDSIZE 22 //圆点大小

@interface ChooseSingleProductViewController ()<UITableViewDelegate,UITableViewDataSource>{
    CALayer  *_layer;
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
    
    _shoppingCartTableView.delegate = self;
    _shoppingCartTableView.dataSource = self;
    _shoppingCartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shoopingViewClick)];
    _shoppingView.userInteractionEnabled = YES;
    [_shoppingView addGestureRecognizer:tapGesture];
}

#pragma mark 重写uitableview方法
#pragma mark 返回数据总数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _commodityTableView) {
        ChooseSingleProduct_CommodityCell *cell = [[ChooseSingleProduct_CommodityCell alloc] cellWithTableView:tableView];
        cell.shopCartBlock = ^(UIButton *plusBtn){
            CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
            rect.origin.y = rect.origin.y - [tableView contentOffset].y;
            CGRect headRect = plusBtn.frame;
            //cell.y+button.y=登录当前按钮的y位置
            headRect.origin.y = rect.origin.y+headRect.origin.y;
            [self startAnimationWithRect:headRect Button:plusBtn];
        };
        return cell;
    }else{
        ChooseSingleProduct_ShoppingCartCell *cell = [[ChooseSingleProduct_ShoppingCartCell alloc] cellWithTableView:tableView];
        return cell;
    }

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
    CGRect rect = _shoppingChileView.frame;
    if (rect.origin.y == screen_height-44) {
        _shoppingView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            _shoppingChileView.frame = CGRectMake(0, screen_height-200-44, screen_width,_shoppingChileView.layer.bounds.size.height);
            _shoppingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.21];
        } completion:^(BOOL finished) {
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
