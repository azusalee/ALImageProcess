//
//  PhotoBrowserViewController.m
//  ALImageProcess
//
//  Created by yangming on 2019/6/28.
//  Copyright © 2019 AL. All rights reserved.
//

#import "PhotoBrowserViewController.h"
#import "UIImage+AZLProcess.h"

@interface PhotoBrowserViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"lenapicalpha" ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imgPath];
    self.imageView.image = image;
    //self.imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 2;
    self.scrollView.delegate = self;
    
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{

    if (scrollView.zoomScale <= 1) {
        self.imageView.center = CGPointMake(self.scrollView.bounds.size.width/2, self.scrollView.bounds.size.height/2);
    }
    NSLog(@"%f,%f", scrollView.contentSize.width, scrollView.contentSize.height);
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
