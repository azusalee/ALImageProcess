//
//  MyGradientView.m
//  ALImageProcess
//
//  Created by yangming on 2019/6/18.
//  Copyright © 2019 AL. All rights reserved.
//

#import "MyGradientView.h"

@implementation MyGradientView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *uipath = [[UIBezierPath alloc] init];
    [uipath moveToPoint:CGPointMake(10, 10)];
    [uipath addCurveToPoint:CGPointMake(10, 10) controlPoint1:CGPointMake(90, 150) controlPoint2:CGPointMake(250, 10)];
    
    CGPathRef path = uipath.CGPath;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 0.5, 1.0 };
    
    NSArray *colors = @[(__bridge id) [UIColor redColor].CGColor, (__bridge id) [UIColor blueColor].CGColor, (__bridge id) [UIColor greenColor].CGColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    CGFloat radius = MAX(pathRect.size.width / 2.0, pathRect.size.height / 2.0);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    
    CGContextDrawRadialGradient(context, gradient, center, 10, center,radius, 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
}


@end
