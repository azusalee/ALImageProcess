//
//  BorderEffectViewController.m
//  ALImageProcess
//
//  Created by yangming on 2019/6/20.
//  Copyright © 2019 AL. All rights reserved.
//

#import "BorderEffectViewController.h"
#import "UIImage+AZLProcess.h"

@interface BorderEffectViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation BorderEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"jpg"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imgPath];
    self.imageView.image = [image azl_sobelBorderImage];
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
