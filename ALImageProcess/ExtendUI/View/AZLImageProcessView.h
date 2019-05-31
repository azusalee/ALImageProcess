//
//  AZLImageProcessView.h
//  ALExampleTest
//
//  Created by yangming on 2018/7/17.
//  Copyright © 2018年 Mac. All rights reserved.
//
//這是一個帶圖片處理效果的view，可以放大縮小，旋轉

#import <UIKit/UIKit.h>

@interface AZLImageProcessView : UIView


@property (nonatomic, strong, readonly) UIImage *orgImg;

//初始化
+ (instancetype)processViewWithImage:(UIImage*)image;
- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image;



//顯示操作控件
- (void)showControlView;
//隱藏操作控件
- (void)hideControlView;

@end
