//
//  ScratchViewController.m
//  ALExampleTest
//
//  Created by yangming on 2018/7/19.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ScratchViewController.h"
#import "AZLScratchView.h"

@interface ScratchViewController ()

@property (nonatomic, strong) AZLScratchView *scratchView;

@end

@implementation ScratchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"laimg3@2x" ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imgPath];
    AZLScratchView *sv = [AZLScratchView scratchViewWithImage:image];
    [self.view addSubview:sv];
    self.scratchView = sv;
    self.scratchView.maxScratchRate = 0.6;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)reset:(id)sender {
    [self.scratchView resetScratch];
}
- (IBAction)showAll:(id)sender {
    [self.scratchView scratchAll];
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
