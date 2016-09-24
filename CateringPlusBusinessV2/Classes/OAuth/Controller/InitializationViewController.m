//
//  InitializationViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/23.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "InitializationViewController.h"
#import "PrefixHeader.h"

@interface InitializationViewController ()<UIScrollViewDelegate>{
    UIPageControl *_pageControl;
    UIButton *_tryNowBtn;
    int _pageNumber;
}

@end

@implementation InitializationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self guidePages];
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
        
        UIViewController  *viewController = [Public getStoryBoardByController:@"OAuth" storyboardId:@"LoginViewController"];
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:navigation animated:NO completion:nil];
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
