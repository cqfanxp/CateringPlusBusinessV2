//
//  SettledProcessViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/15.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "SettledProcessViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "NJKWebViewController.h"

@interface SettledProcessViewController ()<UIWebViewDelegate>

@end

@implementation SettledProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"申请入驻流程"];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"开店手册" style:UIBarButtonItemStyleDone target:self action:@selector(shopmanualBtnClick)];
    [rightBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    _webView.delegate = self;
    
    [self initHtml];
    
    
}

//加载Html
-(void)initHtml{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
        NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_webView loadHTMLString:htmlCont baseURL:baseURL];
        });
    });
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"nowSettled"] = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *viewController = [Public getStoryBoardByController:@"Settled" storyboardId:@"SelectInnerProductViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        });
    };
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark 立即入驻
- (IBAction)nextBtn:(id)sender {
    UIViewController *viewController = [Public getStoryBoardByController:@"Settled" storyboardId:@"SelectInnerProductViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//开店手册
-(void)shopmanualBtnClick{
    NJKWebViewController *njkWeb = [[NJKWebViewController alloc] init];
    njkWeb.webTitle = @"开店手册";
    njkWeb.url = [BASEURL stringByAppendingString:@"/App/AppAction/OpenStore"];
    [self.navigationController pushViewController:njkWeb animated:YES];
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
