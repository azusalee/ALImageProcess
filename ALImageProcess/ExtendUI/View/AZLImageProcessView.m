//
//  AZLImageProcessView.m
//  ALExampleTest
//
//  Created by yangming on 2018/7/17.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AZLImageProcessView.h"
#import "UIImage+AZLProcess.h"

typedef NS_ENUM(NSUInteger, AZLProcessGestureType) {
    AZLProcessGestureTypeNone,
    AZLProcessGestureTypeDrag,
    AZLProcessGestureTypeRotate,
    AZLProcessGestureTypeUpStretch,
    AZLProcessGestureTypeLeftStretch,
};

@interface AZLImageProcessView ()
{
    //當前手勢的類型
    AZLProcessGestureType _gestureType;
    
    //手勢開始時手指所在的位置
    CGPoint _beginPoint;
    //手勢開始時圖形變換
    CGAffineTransform _beginTrasnform;
    //手勢開始時圖形的中心
    CGPoint _beginCenter;
    //手勢開始時圖形Bounds
    CGRect _beginBounds;
    
    //是否垂直翻轉圖
    BOOL _isImageVerMirror;
    //是否水平翻轉圖
    BOOL _isImageHorMirror;
    
}


@property (nonatomic, strong, readwrite) UIImage *orgImg;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *controlView;

@property (nonatomic, strong) UIView *upStretchView;

@property (nonatomic, strong) UIView *leftStretchView;

@property (nonatomic, strong) UIView *rotateStretchView;


@end

@implementation AZLImageProcessView

static const CGFloat ControlItemWidth = 15;



+ (instancetype)processViewWithImage:(UIImage *)image{
    AZLImageProcessView *processView = [[self alloc] initWithFrame:CGRectMake(0, 0, image.size.width+ControlItemWidth/2, image.size.height+ControlItemWidth/2) andImage:image];
    
    return processView;
}

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image{

    if (self = [super initWithFrame:frame]) {
        _orgImg = image;
        [self setup];
    }
    return self;
}

- (void)setup{
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"AZLImageProcess" ofType:@"bundle"]];
    
    //設置圖片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ControlItemWidth/4, ControlItemWidth/4, self.bounds.size.width-ControlItemWidth/2, self.bounds.size.height-ControlItemWidth/2)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight /*| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin*/;
    imageView.image = _orgImg;
    [self addSubview:imageView];
    self.imageView = imageView;
    
    
    //操作視圖容器
    UIView *controlView = [[UIView alloc] initWithFrame:self.bounds];
    controlView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:controlView];
    self.controlView = controlView;
    self.controlView.layer.borderWidth = 0.5;
    self.controlView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //拖拉
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(azl_panGesutreDidRecognize:)];
    [controlView addGestureRecognizer:panGesture];
    
    
    //上拉伸
    UIImageView *upStretchView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-ControlItemWidth)/2, 0, ControlItemWidth, ControlItemWidth)];
    upStretchView.userInteractionEnabled = YES;
    upStretchView.image = [[UIImage alloc] initWithContentsOfFile:[bundle pathForResource:@"azlUDStr" ofType:@"png"]];
    upStretchView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    upStretchView.backgroundColor = [UIColor greenColor];
    [controlView addSubview:upStretchView];
    
    UIPanGestureRecognizer *upStretchGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(azl_upStretchGesutreDidRecognize:)];
    [upStretchView addGestureRecognizer:upStretchGesture];
    self.upStretchView = upStretchView;
    
    
    //左拉伸
    UIImageView *leftStretchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.bounds.size.height-ControlItemWidth)/2, ControlItemWidth, ControlItemWidth)];
    leftStretchView.userInteractionEnabled = YES;
    leftStretchView.image = [[UIImage alloc] initWithContentsOfFile:[bundle pathForResource:@"azlLRStr" ofType:@"png"]];
    leftStretchView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    leftStretchView.backgroundColor = [UIColor greenColor];
    [controlView addSubview:leftStretchView];
    
    UIPanGestureRecognizer *leftStretchGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(azl_leftStretchGesutreDidRecognize:)];
    [leftStretchView addGestureRecognizer:leftStretchGesture];
    
    self.leftStretchView = leftStretchView;
    
    
    
    //旋轉
    UIImageView *rotateView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-ControlItemWidth, self.bounds.size.height-ControlItemWidth, ControlItemWidth, ControlItemWidth)];
    rotateView.userInteractionEnabled = YES;
    rotateView.image = [[UIImage alloc] initWithContentsOfFile:[bundle pathForResource:@"azlRotate" ofType:@"png"]];
    rotateView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    rotateView.backgroundColor = [UIColor redColor];
    [controlView addSubview:rotateView];
    
    UIPanGestureRecognizer *rotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(azl_rotateGesutreDidRecognize:)];
    [rotateView addGestureRecognizer:rotateGesture];
    
    self.rotateStretchView = rotateView;
    
}


- (void)azl_printLog{
    NSLog(@"bounds:%@",NSStringFromCGRect(self.bounds));
    NSLog(@"frame:%@",NSStringFromCGRect(self.frame));
}

//識別到拖動手勢
- (void)azl_panGesutreDidRecognize:(UIPanGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _beginTrasnform = self.transform;
        _gestureType = AZLProcessGestureTypeDrag;
        
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        
        CGPoint transletPoint = [gesture translationInView:self];
        
        self.transform = CGAffineTransformTranslate(_beginTrasnform, transletPoint.x, transletPoint.y);
        
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        _gestureType = AZLProcessGestureTypeNone;
    }
    [self azl_printLog];
}


//識別到旋轉手勢
- (void)azl_rotateGesutreDidRecognize:(UIPanGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self hideAllControlItem];
        self.rotateStretchView.hidden = NO;
        CGPoint touchPoint = [gesture locationInView:[UIApplication sharedApplication].keyWindow];
        _beginTrasnform = self.transform;
        _gestureType = AZLProcessGestureTypeRotate;
        
        _beginPoint = touchPoint;
        _beginCenter = [self convertPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) toView:[UIApplication sharedApplication].keyWindow];
        _beginBounds = self.bounds;
        
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        
        CGPoint transletPoint = [gesture translationInView:[UIApplication sharedApplication].keyWindow];
        CGPoint touchPoint = CGPointMake(transletPoint.x+_beginPoint.x, transletPoint.y+_beginPoint.y);
        
        
        CGFloat a = sqrt((touchPoint.x-_beginPoint.x)*(touchPoint.x-_beginPoint.x)+(touchPoint.y-_beginPoint.y)*(touchPoint.y-_beginPoint.y));
        CGFloat b = sqrt((_beginCenter.x-_beginPoint.x)*(_beginCenter.x-_beginPoint.x)+(_beginCenter.y-_beginPoint.y)*(_beginCenter.y-_beginPoint.y));
        CGFloat c = sqrt((_beginCenter.x-touchPoint.x)*(_beginCenter.x-touchPoint.x)+(_beginCenter.y-touchPoint.y)*(_beginCenter.y-touchPoint.y));
        
        if (a > 0 && b > 0 && c > 0) {
            //根據三邊長計算角度
            CGFloat angle = acos((b*b+c*c-a*a)/(2*b*c));
            if (_beginPoint.x > _beginCenter.x) {
                if (touchPoint.y < (_beginPoint.y-_beginCenter.y)/(_beginPoint.x-_beginCenter.x)*(touchPoint.x-_beginCenter.x) + _beginCenter.y) {
                    angle = -angle;
                }
            }else{
                if (touchPoint.y > (_beginPoint.y-_beginCenter.y)/(_beginPoint.x-_beginCenter.x)*(touchPoint.x-_beginCenter.x) + _beginCenter.y) {
                    angle = -angle;
                }
            }
            
            //縮放比例
            CGFloat scale = c/b;
            
            CGAffineTransform transform = CGAffineTransformRotate(_beginTrasnform, angle);

            self.transform = transform;
            
            CGFloat width = _beginBounds.size.width*scale;
            CGFloat height = _beginBounds.size.height*scale;
            if (width < ControlItemWidth){
                width = ControlItemWidth;
            }
            if (height < ControlItemWidth){
                height = ControlItemWidth;
            }
            
            
            self.bounds = CGRectMake(0, 0, width, height);
            
        }
        
    }else if (gesture.state == UIGestureRecognizerStateEnded){
       
        _gestureType = AZLProcessGestureTypeNone;
        [self showAllControlItem];
    }
    [self azl_printLog];
}

//識別到上下拉伸
- (void)azl_upStretchGesutreDidRecognize:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self hideAllControlItem];
        self.upStretchView.hidden = NO;
        _beginTrasnform = self.transform;
        _gestureType = AZLProcessGestureTypeUpStretch;
        
        _beginPoint = [self convertPoint:CGPointMake(self.bounds.size.width/2, 0) toView:[UIApplication sharedApplication].keyWindow];
        _beginCenter = [self convertPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) toView:[UIApplication sharedApplication].keyWindow];
        _beginBounds = self.bounds;
        
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        CGPoint transletPoint = [gesture translationInView:[UIApplication sharedApplication].keyWindow];
        CGPoint touchPoint = CGPointMake(transletPoint.x+_beginPoint.x, transletPoint.y+_beginPoint.y);

        CGFloat a = sqrt((touchPoint.x-_beginPoint.x)*(touchPoint.x-_beginPoint.x)+(touchPoint.y-_beginPoint.y)*(touchPoint.y-_beginPoint.y));
        CGFloat b = sqrt((_beginCenter.x-_beginPoint.x)*(_beginCenter.x-_beginPoint.x)+(_beginCenter.y-_beginPoint.y)*(_beginCenter.y-_beginPoint.y));
        CGFloat c = sqrt((_beginCenter.x-touchPoint.x)*(_beginCenter.x-touchPoint.x)+(_beginCenter.y-touchPoint.y)*(_beginCenter.y-touchPoint.y));

        if (a > 0 && b > 0 && c > 0) {
            
            CGFloat scale = (-a*a+b*b+c*c)/(2*b)/b;
            
            scale = 1-(1-scale)/2;
            
            if ((scale < 0 && _isImageVerMirror == NO) || (scale > 0 && _isImageVerMirror == YES)) {
                self.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
            }else{
                self.imageView.transform = CGAffineTransformIdentity;
            }
            self.transform = CGAffineTransformTranslate(_beginTrasnform, 0, -_beginBounds.size.height*(scale-1)/2);
            scale = fabs(scale);

            CGFloat height = _beginBounds.size.height*scale;
            if (height < ControlItemWidth){
                height = ControlItemWidth;
            }
            
            self.bounds = CGRectMake(0, 0, _beginBounds.size.width, height);
            
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        CGPoint transletPoint = [gesture translationInView:[UIApplication sharedApplication].keyWindow];
        CGPoint touchPoint = CGPointMake(transletPoint.x+_beginPoint.x, transletPoint.y+_beginPoint.y);
        
        CGFloat a = sqrt((touchPoint.x-_beginPoint.x)*(touchPoint.x-_beginPoint.x)+(touchPoint.y-_beginPoint.y)*(touchPoint.y-_beginPoint.y));
        CGFloat b = sqrt((_beginCenter.x-_beginPoint.x)*(_beginCenter.x-_beginPoint.x)+(_beginCenter.y-_beginPoint.y)*(_beginCenter.y-_beginPoint.y));
        CGFloat c = sqrt((_beginCenter.x-touchPoint.x)*(_beginCenter.x-touchPoint.x)+(_beginCenter.y-touchPoint.y)*(_beginCenter.y-touchPoint.y));
        
        if (a > 0 && b > 0 && c > 0) {
            
            CGFloat scale = (-a*a+b*b+c*c);
            
            if (scale < 0) {
                _isImageVerMirror = !_isImageVerMirror;
            }
        }
        _gestureType = AZLProcessGestureTypeNone;
        [self showAllControlItem];
    }
    [self azl_printLog];
}



//識別到左右拉伸
- (void)azl_leftStretchGesutreDidRecognize:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self hideAllControlItem];
        self.leftStretchView.hidden = NO;
        
        _beginTrasnform = self.transform;
        _gestureType = AZLProcessGestureTypeLeftStretch;
        
        _beginPoint = [self convertPoint:CGPointMake(0, self.bounds.size.height/2) toView:[UIApplication sharedApplication].keyWindow];
        _beginCenter = [self convertPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) toView:[UIApplication sharedApplication].keyWindow];
        _beginBounds = self.bounds;
        
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        CGPoint transletPoint = [gesture translationInView:[UIApplication sharedApplication].keyWindow];
        CGPoint touchPoint = CGPointMake(transletPoint.x+_beginPoint.x, transletPoint.y+_beginPoint.y);
        
        CGFloat a = sqrt((touchPoint.x-_beginPoint.x)*(touchPoint.x-_beginPoint.x)+(touchPoint.y-_beginPoint.y)*(touchPoint.y-_beginPoint.y));
        CGFloat b = sqrt((_beginCenter.x-_beginPoint.x)*(_beginCenter.x-_beginPoint.x)+(_beginCenter.y-_beginPoint.y)*(_beginCenter.y-_beginPoint.y));
        CGFloat c = sqrt((_beginCenter.x-touchPoint.x)*(_beginCenter.x-touchPoint.x)+(_beginCenter.y-touchPoint.y)*(_beginCenter.y-touchPoint.y));
        
        if (a > 0 && b > 0 && c > 0) {
            
            CGFloat scale = (-a*a+b*b+c*c)/(2*b)/b;
            
            scale = 1-(1-scale)/2;
            
            if ((scale < 0 && _isImageHorMirror == NO) || (scale > 0 && _isImageHorMirror == YES)) {
                self.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, -1, 1);
            }else{
                self.imageView.transform = CGAffineTransformIdentity;
            }
            self.transform = CGAffineTransformTranslate(_beginTrasnform, -_beginBounds.size.width*(scale-1)/2, 0);
            scale = fabs(scale);
            
            CGFloat width = _beginBounds.size.width*scale;
            if (width < ControlItemWidth) {
                width = ControlItemWidth;
            }
            
            self.bounds = CGRectMake(0, 0, width, _beginBounds.size.height);
            
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        CGPoint transletPoint = [gesture translationInView:[UIApplication sharedApplication].keyWindow];
        CGPoint touchPoint = CGPointMake(transletPoint.x+_beginPoint.x, transletPoint.y+_beginPoint.y);
        
        CGFloat a = sqrt((touchPoint.x-_beginPoint.x)*(touchPoint.x-_beginPoint.x)+(touchPoint.y-_beginPoint.y)*(touchPoint.y-_beginPoint.y));
        CGFloat b = sqrt((_beginCenter.x-_beginPoint.x)*(_beginCenter.x-_beginPoint.x)+(_beginCenter.y-_beginPoint.y)*(_beginCenter.y-_beginPoint.y));
        CGFloat c = sqrt((_beginCenter.x-touchPoint.x)*(_beginCenter.x-touchPoint.x)+(_beginCenter.y-touchPoint.y)*(_beginCenter.y-touchPoint.y));
        
        if (a > 0 && b > 0 && c > 0) {
            
            CGFloat scale = (-a*a+b*b+c*c);
            
            if (scale < 0) {
                _isImageHorMirror = !_isImageHorMirror;
            }
        }
        _gestureType = AZLProcessGestureTypeNone;
        
        [self showAllControlItem];
    }
    
    [self azl_printLog];
}




- (void)showControlView{
    self.controlView.hidden = NO;
}

- (void)hideControlView{
    self.controlView.hidden = YES;
}

- (void)showAllControlItem{
    self.upStretchView.hidden = NO;
    self.leftStretchView.hidden = NO;
    self.rotateStretchView.hidden = NO;
}

- (void)hideAllControlItem{
    self.upStretchView.hidden = YES;
    self.leftStretchView.hidden = YES;
    self.rotateStretchView.hidden = YES;
}


@end
