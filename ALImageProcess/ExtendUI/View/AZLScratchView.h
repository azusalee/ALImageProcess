//
//  AZLScratchView.h
//  ALExampleTest
//
//  Created by yangming on 2018/7/19.
//  Copyright © 2018年 Mac. All rights reserved.
//
//這是一個有刮一刮效果的視圖

#import <UIKit/UIKit.h>

typedef void(^AZLScratchViewBlock)(double rate);

@interface AZLScratchView : UIView

//0~1，當顯示大於等於這個比例會顯示全部(為0時沒有效果，默認0)
@property (nonatomic, assign) double maxScratchRate;
//每次用戶鬆開手指會回調(rate是當前已刮的比例，返回1代表已經全部顯示)
@property (nonatomic, copy) AZLScratchViewBlock rateBlock;

//初始化方法，會生成一張馬賽克圖片作為蒙層
+ (instancetype)scratchViewWithImage:(UIImage *)image;
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

/**
 生成刮一刮視圖

 @param frame 視圖的frame(建議大小與contentView一樣)
 @param contentView 內容視圖
 @param maskView 蒙層視圖
 @return view
 */
- (instancetype)initWithFrame:(CGRect)frame contentView:(UIView *)contentView maskView:(UIView *)maskView;


//設置刮的寬度
- (void)setScratchWidth:(CGFloat)scratchWidth;
//獲取刮的寬度
- (CGFloat)scratchWidth;

//重置
- (void)resetScratch;
//已刮的比例（返回0~1），這個方法比較耗性能，不建議頻繁調用
- (double)currentScratchedRate;
//展示原圖
- (void)scratchAll;

@end
