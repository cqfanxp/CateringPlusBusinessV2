//
//  ImgInfoView.m
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/9/9.
//  Copyright © 2016年 餐+. All rights reserved.
//

#import "ImgInfoView.h"

@implementation ImgInfoView

////无网络
//-(void)setNoNetwork{
//    self.titleLabel.text = @"网络请求失败";
//    self.contentLabel.text = @"请检查你的网络";
//    self.iconImgView.image = [UIImage imageNamed:@"internet"];
//}
////无数据
//-(void)setNoData{
//    self.titleLabel.text = @"木有数据";
//    self.contentLabel.text = @"还木有数据";
//    self.iconImgView.image = [UIImage imageNamed:@"data"];
//}
////服务器错误
//-(void)setServesError{
//    self.titleLabel.text = @"服务器错误";
//    self.contentLabel.text = @"请稍后再试";
//    self.iconImgView.image = [UIImage imageNamed:@"load_fail"];
//}
//设置当前状态
-(void)SetStatus:(ImgInfo) imginfo{
    switch (imginfo) {
        case NoNetwork://无网络
            self.titleLabel.text = @"网络请求失败";
            self.contentLabel.text = @"请检查你的网络";
            self.iconImgView.image = [UIImage imageNamed:@"internet"];
            self.reloadBtn.hidden = NO;
            break;
        case NoData://无数据
            self.titleLabel.text = @"木有数据";
            self.contentLabel.text = @"还木有数据";
            self.iconImgView.image = [UIImage imageNamed:@"data"];
            self.reloadBtn.hidden = YES;
            break;
        default://服务器错误
            self.titleLabel.text = @"服务器错误";
            self.contentLabel.text = @"请稍后再试";
            self.iconImgView.image = [UIImage imageNamed:@"load_fail"];
            self.reloadBtn.hidden = NO;
            break;
    }
}
@end
