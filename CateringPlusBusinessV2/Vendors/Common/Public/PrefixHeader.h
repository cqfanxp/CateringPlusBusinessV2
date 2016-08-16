//
//  PrefixHeader.pch
//  CateringPlusBusinessV2
//
//  Created by 火爆私厨 on 16/8/15.
//  Copyright © 2016年 餐+. All rights reserved.
//

//**************调试和发布版本之间的设置*****************

#import "UINavigationItem+BackButton.h"
#import "BaseViewController.h"
#import "Public.h"

#ifdef DEBUG //调试模式--模拟器

#define HMLog(...) NSLog(__VA_ARGS__)  //公司自定义打印

#else //发布模式 RELEASE--真机

#define HMLog(...)  //发布版本下取消自定义打印，自定义打印不起作用

#endif

//**************所有objective-c文件共享的头文件*****************

#ifdef __OBJC__  //所有objective-c文件共享的头文件


// 2.获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)

#define navigationBarColor RGB(255, 255, 255)
#define separaterColor RGB(200, 199, 204)

// 4.屏幕大小尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

//重新设定view的Y值
#define setFrameY(view, newY) view.frame = CGRectMake(view.frame.origin.x, newY, view.frame.size.width, view.frame.size.height)
#define setFrameX(view, newX) view.frame = CGRectMake(newX, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
#define setFrameH(view, newH) view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, newH)


//取view的坐标及长宽
#define W(view)    view.frame.size.width
#define H(view)    view.frame.size.height
#define X(view)    view.frame.origin.x
#define Y(view)    view.frame.origin.y

//5.常用对象
#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)


#endif
