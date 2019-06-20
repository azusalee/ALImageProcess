//
//  PickColorViewController.m
//  ALExampleTest
//
//  Created by yangming on 2018/8/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PickColorViewController.h"
#import "UIImage+AZLProcess.h"

@interface PickColorViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@end

@implementation PickColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
//    
//    maskView.backgroundColor = [UIColor greenColor];
//    CAGradientLayer *graLayer = [[CAGradientLayer alloc] init];
//    graLayer.frame = CGRectMake(0, 0, 100, 50);
//    graLayer.colors = @[(id)[UIColor colorWithWhite:1 alpha:1].CGColor, (id)[UIColor colorWithWhite:1 alpha:0.1].CGColor];
//    graLayer.locations = @[@(0.8), @(1)];
//    
//    maskView.layer.mask = graLayer;
//    //[maskView.layer addSublayer:graLayer];
//    
//    [self.view addSubview:maskView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)imageDidTap:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self.imageView];
    
    UIImage *snapImage = [UIImage azl_imageFromView:self.imageView];
    
    UIColor *pickColor = [snapImage azl_colorFromPoint:touchPoint];
    
    self.colorView.backgroundColor = pickColor;
    
    
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
