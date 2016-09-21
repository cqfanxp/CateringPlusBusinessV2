//
//  SelectHtmlTextViewController.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/17.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "ZSSRichTextEditor.h"

@interface SelectHtmlTextViewController : ZSSRichTextEditor

@property(nonatomic,strong) void(^resultData)(NSString *content);

@end
