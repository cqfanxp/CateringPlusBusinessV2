//
//  InitializationViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/23.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "InitializationViewController.h"
#import "PrefixHeader.h"
#import "MainViewController.h"

@interface InitializationViewController ()<UIScrollViewDelegate>{
    UIPageControl *_pageControl;
    UIButton *_tryNowBtn;
    int _pageNumber;
    NSDictionary *_userInfo;
}

@end

@implementation InitializationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLayout];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        //加载启动页
        [self guidePages];
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //参数
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            _userInfo = [defaults objectForKey:USERINFO];
            
            if (_userInfo != nil) {
                [self verifyLogin];
            }else{
                [self skipLogin];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        });
    }
}


-(void)initLayout{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    imgView.image = [UIImage imageNamed:@"loadingImg"];
    [self.view addSubview:imgView];
}

#pragma mark 验证登录
-(void)verifyLogin{
    //判断网络
    if (![Public isNetWork]) {
        [self skipLogin];
    }
    //当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   _userInfo[@"account"],@"account",
                                   _userInfo[@"password"],@"password",
                                   [[UIDevice currentDevice].identifierForVendor UUIDString],@"uniqueIdentifier",
                                   [[UIDevice currentDevice] systemName],@"systemName",
                                   [[UIDevice currentDevice] systemVersion],@"systemVersion",
                                   timeString,@"timestamp",
                                   nil];
    
    [NetWorkUtil post:[BASEURL stringByAppendingString:@"/api/businesses/business/userLogin"] parameters:[Public getParams:params] success:^(id responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            MainViewController *mainViwe = [[MainViewController alloc] init];
            [self presentViewController:mainViwe animated:NO completion:nil];
        }else{
            [self skipLogin];
        }
    } failure:^(NSError *error) {
        [self skipLogin];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 引导页
-(void)guidePages{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    [scrollView setContentSize:CGSizeMake(screen_width*3, 0)];
    [scrollView setPagingEnabled:YES];//视图整页显示
    [scrollView setBounces:NO];
    scrollView.delegate = self;
    [scrollView setShowsHorizontalScrollIndicator:NO];
    
    for (int i=1; i<=3; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width*(i-1), 0, screen_width, screen_height)];
        [imageview setImage:[UIImage imageNamed:[NSString stringWithFormat:@"guidePages%d",i]]];
        //最后一张图片添加点击事件
        if (i==3) {
            imageview.userInteractionEnabled = YES;
//            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpTologin)];
//            [imageview addGestureRecognizer:singleTap];
        }
        [scrollView addSubview:imageview];
    }

    [self.view addSubview:scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, screen_height-60, screen_width, 60)];
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = RGB(153, 153, 153);
    _pageControl.currentPageIndicatorTintColor = RGB(249, 215, 38);
    [self.view addSubview:_pageControl];
    
    _tryNowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, screen_height-120, screen_width, 60)];
//    [_tryNowBtn setBackgroundColor:[UIColor redColor]];
    [_tryNowBtn addTarget:self action:@selector(tryNotClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tryNowBtn];
}

#pragma mark - UIScrollView的代理方法
#pragma mark 当scrollView正在滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width;
//        NSLog(@"%d", page);
    // 设置页码
    _pageControl.currentPage = _pageNumber;
}

-(void)tryNotClick{
    if (_pageNumber ==2) {
        [self skipLogin];
    }
}

//跳转到登录
-(void)skipLogin{
    UIViewController  *viewController = [Public getStoryBoardByController:@"OAuth" storyboardId:@"LoginViewController"];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigation animated:NO completion:nil];
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
