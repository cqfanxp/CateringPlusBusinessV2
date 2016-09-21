//
//  FeedbackViewController.h
//  CateringPlusBusinessV2  意见反馈
//
//  Created by 火爆私厨 on 16/9/1.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *bgTextView;

//已经反馈内容
@property (weak, nonatomic) IBOutlet UITextView *adviceTextView;

//手机号码
@property (weak, nonatomic) IBOutlet UITextField *telephoneText;

@end
