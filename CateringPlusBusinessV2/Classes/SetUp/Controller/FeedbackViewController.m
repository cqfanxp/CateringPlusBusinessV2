//
//  FeedbackViewController.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/1.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"意见反馈"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _adviceTextView.delegate = self;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(![text isEqualToString:@""])
    {
        [_bgTextView setHidden:YES];
    }
    if([text isEqualToString:@""]&&range.length==1&&range.location==0){
        [_bgTextView setHidden:NO];
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
