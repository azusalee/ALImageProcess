//
//  BorderEffectViewController.m
//  ALImageProcess
//
//  Created by yangming on 2019/6/20.
//  Copyright © 2019 AL. All rights reserved.
//

#import "BorderEffectViewController.h"
#import <AZLExtend/UIImage+AZLProcess.h>

@interface BorderEffectViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *myView;

@end

@implementation BorderEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"lenapicalpha" ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imgPath];
    self.imageView.image = [image azl_sobelBorderImage];
    
    UIImage *myimage = [UIImage azl_imageFromView:self.myView];
    NSData *imageData =  UIImagePNGRepresentation(myimage);
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    filePath = [filePath stringByAppendingPathComponent:@"sourceNum.png"];
    NSLog(@"%@", filePath);
    [imageData writeToFile:filePath atomically:YES];
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
