//
//  FeaturesViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/22.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "FeaturesViewController.h"

@implementation FeaturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(UIView *)imgInfoView{
    if (!_imgInfoView) {
        _imgInfoView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ImgInfoView class]) owner:self options:nil].lastObject;
        _imgInfoView.frame = CGRectMake(0, 0, screen_width, screen_height);
        _imgInfoView.hidden = YES;
        [_imgInfoView.reloadBtn addTarget:self action:@selector(reloadClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_imgInfoView];
    }
    return _imgInfoView;
}
//重新加载
-(void)reloadClick{
    
}
@end
