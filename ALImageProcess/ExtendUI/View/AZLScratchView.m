//
//  AZLScratchView.m
//  ALExampleTest
//
//  Created by yangming on 2018/7/19.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AZLScratchView.h"
#import <AZLExtend/UIImage+AZLProcess.h>


@interface AZLScratchView ()
{
    UIView *_scratchContentView;
    UIView *_scratchMaskView;
    
    UIBezierPath *_maskPath;
    CAShapeLayer *_maskLayer;
}


@end


@implementation AZLScratchView


+ (instancetype)scratchViewWithImage:(UIImage *)image{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height) image:image];
}


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image{
    UIImageView *contentImageView = [[UIImageView alloc] initWithImage:image];
    UIImage *maskImage = [image azl_imageFromMosaicLevel:16];
    UIImageView *maskImageView = [[UIImageView alloc] initWithImage:maskImage];
    return [self initWithFrame:frame contentView:contentImageView maskView:maskImageView];
}


- (instancetype)initWithFrame:(CGRect)frame contentView:(UIView *)contentView maskView:(UIView *)maskView{
    if (self = [super initWithFrame:frame]) {
        contentView.frame = self.bounds;
        maskView.frame = self.bounds;
        _scratchContentView = contentView;
        _scratchMaskView = maskView;
        [self setup];
    }
    return self;
}


- (void)setup{
    [self addSubview:_scratchMaskView];
    [self addSubview:_scratchContentView];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.lineWidth = 32;
    maskLayer.lineCap = kCALineCapRound;
    _scratchContentView.layer.mask = maskLayer;
    _maskLayer = maskLayer;
    
    _maskPath = [[UIBezierPath alloc] init];
    
    
    UIPanGestureRecognizer *scratchGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scratchGestureDidRec:)];
    [self addGestureRecognizer:scratchGesture];
}

- (void)scratchGestureDidRec:(UIPanGestureRecognizer *)gesture{
    if (_scratchContentView.layer.mask == nil) {
        return;
    }
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gesture locationInView:_scratchContentView];
        [_maskPath moveToPoint:point];
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        CGPoint point = [gesture locationInView:_scratchContentView];
        [_maskPath addLineToPoint:point];
        [_maskPath moveToPoint:point];
        
        _maskLayer.path = _maskPath.CGPath;
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        
        double rate = [self currentScratchedRate];
        
        if (_maxScratchRate > 0) {
            //計算已刮比例
            if (rate >= _maxScratchRate) {
                [self scratchAll];
                rate = 1;
            }
        }
        if (self.rateBlock) {
            self.rateBlock(rate);
        }
    }
}

- (void)resetScratch{
    [_maskPath removeAllPoints];
    _maskLayer.path = _maskPath.CGPath;
    _scratchContentView.layer.mask = _maskLayer;
}

- (void)scratchAll{
    _scratchContentView.layer.mask = nil;
}

- (void)setScratchWidth:(CGFloat)scratchWidth{
    _maskLayer.lineWidth = scratchWidth;
}

- (CGFloat)scratchWidth{
    return _maskLayer.lineWidth;
}

- (double)currentScratchedRate{
    if (_scratchContentView.layer.mask == nil) {
        return 1;
    }
    //生成圖片
    UIImage *image = [UIImage azl_imageFromView:_scratchContentView];
    //計算不透明比例(已刮的比例)
    double percent = [image azl_getNoAlphaPixelRate];
    return percent;
}


- (void)setMaxScratchRate:(double)maxScratchRate{
    if (maxScratchRate > 1) {
        _maxScratchRate = 1;
    }else if (maxScratchRate < 0){
        _maxScratchRate = 0;
    }else{
        _maxScratchRate = maxScratchRate;
    }
}

@end
