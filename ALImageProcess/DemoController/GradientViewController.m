//
//  GradientViewController.m
//  ALImageProcess
//
//  Created by yangming on 2019/6/18.
//  Copyright © 2019 AL. All rights reserved.
//

#import "GradientViewController.h"
#import "MyGradientView.h"

@interface GradientViewController ()
@property (weak, nonatomic) IBOutlet MyGradientView *gradientView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GradientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CAGradientLayer *graLayer = [[CAGradientLayer alloc] init];
    graLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    graLayer.colors = @[(__bridge id)[UIColor colorWithWhite:1 alpha:1].CGColor,
                        (__bridge id)[UIColor colorWithWhite:1 alpha:1].CGColor,
                        (__bridge id)[UIColor colorWithWhite:1 alpha:0.1].CGColor,
                        ];
    graLayer.locations = @[@(0), @(0.8), @(1)];
    self.containerView.layer.mask = graLayer;
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 1200);
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
