//
//  ImgInfoView.h
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/9.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NoNetwork,
    NoData,
    ServesError
}ImgInfo;

@interface ImgInfoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *reloadBtn;

-(void)SetStatus:(ImgInfo) imginfo;
@end
