//
//  MyListViewController.m
//  ALImageProcess
//
//  Created by yangming on 2019/7/29.
//  Copyright © 2019 AL. All rights reserved.
//

#import "MyListViewController.h"
#import <AZLExtend/UIImage+AZLProcess.h>

@interface MyListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *shotImageView;

@end

@implementation MyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    headView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headView;
    self.tableView.backgroundColor = [UIColor whiteColor];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return 20;
}

- (IBAction)shotDidTap:(id)sender {
//    UIImage *image = [UIImage azl_imageFromScrollView:self.tableView];
//    self.shotImageView.image = image;
//    self.shotImageView.hidden = NO;
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.shotImageView.hidden = YES;
//    });
}

@end
