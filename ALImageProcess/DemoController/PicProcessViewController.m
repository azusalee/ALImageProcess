//
//  PicProcessViewController.m
//  ALExampleTest
//
//  Created by yangming on 2018/6/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PicProcessViewController.h"
#import "UIImage+AZLProcess.h"
#import "AZLImageProcessView.h"


@interface PicProcessViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *xT;
@property (weak, nonatomic) IBOutlet UITextField *yT;
@property (weak, nonatomic) IBOutlet UITextField *wT;
@property (weak, nonatomic) IBOutlet UITextField *hT;
@property (weak, nonatomic) IBOutlet UITextField *blurTF;
@property (weak, nonatomic) IBOutlet UITextField *rotateTF;


@property (nonatomic, strong) UIImage *oriImage;
@property (strong, nonatomic) IBOutlet UIImageView *shotImageView;



@end

@implementation PicProcessViewController


- (UIImage *)oriImage{
    //if (_oriImage == nil) {
        NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"laimg2@2x" ofType:@"jpeg"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imgPath];
    //UIImage *image = [UIImage imageNamed:@"laimg2@2x.jpeg"];
    return image;
        //_oriImage = image;
    //}
    //return _oriImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    self.shotImageView.frame = [UIScreen mainScreen].bounds;
    self.shotImageView.backgroundColor = [UIColor blackColor];
    
    AZLImageProcessView *processView = [AZLImageProcessView processViewWithImage:self.oriImage];
    
    [self.view addSubview:processView];
    
    
    [self drawHeart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//缩放
- (IBAction)ratioDidTap:(id)sender {
    double width = [self.wT.text doubleValue];
    double height = [self.hT.text doubleValue];
    
    CGSize newSize = CGSizeMake(width, height);
    
    
    self.imageView.image = [self.oriImage azl_imageFromSize:newSize];
    
}

//裁剪
- (IBAction)clipDidTap:(id)sender {
    double x = [self.xT.text doubleValue];
    double y = [self.yT.text doubleValue];
    double width = [self.wT.text doubleValue];
    double height = [self.hT.text doubleValue];
    
    CGRect clipRect = CGRectMake(x, y, width, height);
    self.imageView.image = [self.oriImage azl_imageClipFromRect:clipRect];
    
    
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.oriImage.CGImage, clipRect);
//    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
//
//    UIGraphicsBeginImageContext(smallBounds.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, smallBounds, subImageRef);
//    CGImageRelease(subImageRef);//自己创建出来的cgimage要释放，arc只会管理oc的对象
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//    
////    CGImageRef sourceImageRef = [self.oriImage CGImage];
////
////    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, clipRect);
////
////    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
////    CGImageRelease(newImageRef);//自己创建出来的cgimage要释放，arc只会管理oc的对象
//    
//    self.imageView.image = newImage;
}

- (IBAction)originDidTap:(id)sender {
    self.imageView.image = self.oriImage;
}
- (IBAction)blankDidTap:(id)sender {
    self.imageView.image = nil;
    self.oriImage = nil;
    
}

- (IBAction)shotImage:(id)sender {
    
    UIImage *img = [UIImage azl_imageFromView:self.view];
    
    self.shotImageView.image = img;
    
    [self.view addSubview:self.shotImageView];
    
}

- (IBAction)shotImageViewDidTap:(id)sender {
    [self.shotImageView removeFromSuperview];
}
- (IBAction)grayDidTap:(id)sender {
    self.imageView.image = self.oriImage.azl_grayImage;
}
- (IBAction)blurDidTap:(id)sender {
    
    CGFloat blur = [self.blurTF.text doubleValue];
    self.imageView.image = [self.oriImage azl_imageFromBoxBlur:blur];

    
    
}
- (IBAction)mosaicDidTap:(id)sender {
    self.imageView.image = [self.oriImage azl_imageFromMosaicLevel:6];
}
- (IBAction)rotateDidTap:(id)sender {
    CGFloat rotate = [self.rotateTF.text doubleValue];
    self.imageView.image = [self.oriImage azl_imageFromRotate:rotate];
}
- (IBAction)mirrorHorizonDidTap:(id)sender {
    self.imageView.image = self.oriImage.azl_imageFromMirrorHorizon;
}
- (IBAction)mirrorVerticalDidTap:(id)sender {
    self.imageView.image = self.oriImage.azl_imageFromMirrorVertical;
}
- (IBAction)circleClipDidTap:(id)sender {
    double x = [self.xT.text doubleValue];
    double y = [self.yT.text doubleValue];
    double width = [self.wT.text doubleValue];
    double height = [self.hT.text doubleValue];
    
    CGRect clipRect = CGRectMake(x, y, width, height);
    self.imageView.image = [self.oriImage azl_imageClipCircleFromRect:clipRect];
}

- (IBAction)filterDidTap:(id)sender {
    
    NSArray *filters = [UIImage azl_getEffectArray];
    
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"濾鏡"] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //添加取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionController addAction:cancelAction];
    
    for (NSString *string in filters) {
        
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:string style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.imageView.image = [self.oriImage azl_imageFromFilterName:string];
            
        }];
        [actionController addAction:action];
    }
    
    [self presentViewController:actionController animated:YES completion:nil];
    
}

- (void)drawHeart{
    CGFloat centerX = 150;
    CGFloat centerY = 150;
    CGFloat radius = 100;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    {
        CGFloat drawingPadding = 4.0;
        CGFloat curveRadius = floor((radius*2 - 2*drawingPadding) / 4.0);
        
        /// Creat path
        UIBezierPath *heartPath = path;
        
        /// Start at bottom heart tip
        CGFloat offsetX = centerX-radius;
        CGFloat offsetY = centerY-radius;
        CGPoint tipLocation = CGPointMake(floor(radius) + offsetX, radius*2 - drawingPadding + offsetY);
        [heartPath moveToPoint:tipLocation];
        
        /// Move to top left start of curve
        CGPoint topLeftCurveStart = CGPointMake(drawingPadding + offsetX, floor(radius*2 / 2.4) + offsetY);
        
        [heartPath addQuadCurveToPoint:topLeftCurveStart controlPoint:CGPointMake(topLeftCurveStart.x, topLeftCurveStart.y + curveRadius)];
        
        /// Create top left curve
        [heartPath addArcWithCenter:CGPointMake(topLeftCurveStart.x + curveRadius, topLeftCurveStart.y) radius:curveRadius startAngle:M_PI endAngle:0 clockwise:YES];
        
        /// Create top right curve
        CGPoint topRightCurveStart = CGPointMake(topLeftCurveStart.x + 2*curveRadius, topLeftCurveStart.y);
        [heartPath addArcWithCenter:CGPointMake(topRightCurveStart.x + curveRadius, topRightCurveStart.y) radius:curveRadius startAngle:M_PI endAngle:0 clockwise:YES];
        
        /// Final curve to bottom heart tip
        CGPoint topRightCurveEnd = CGPointMake(topLeftCurveStart.x + 4*curveRadius, topRightCurveStart.y);
        [heartPath addQuadCurveToPoint:tipLocation controlPoint:CGPointMake(topRightCurveEnd.x, topRightCurveEnd.y + curveRadius)];
        
    }
    
    
    //[path setLineWidth:5];
    //[[UIColor redColor] setStroke];
    //[path stroke];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 5;
    
    layer.strokeStart = 0;
    layer.strokeEnd = 0;
    
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    animate.duration = 4;
    animate.fromValue = @(0);
    animate.toValue = @(1);
    animate.fillMode = kCAFillModeForwards;
    animate.repeatCount = HUGE_VALF;
    
    
    [layer addAnimation:animate forKey:@"drawHeart"];
    
    [self.view.layer addSublayer:layer];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
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
