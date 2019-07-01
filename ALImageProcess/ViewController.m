//
//  ViewController.m
//  ALImageProcess
//
//  Created by yangming on 2019/5/31.
//  Copyright © 2019 AL. All rights reserved.
//

#import "ViewController.h"
#import "JumpVCModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupData];
}


//設置數據
- (void)setupData{
    self.dataArray = [[NSMutableArray alloc] init];
    
    
    
    {
        JumpVCModel *model = [[JumpVCModel alloc] init];
        model.title = @"图片测试";
        model.vcName = @"PicProcessViewController";
        [self.dataArray addObject:model];
    }
    
    {
        JumpVCModel *model = [[JumpVCModel alloc] init];
        model.title = @"取色";
        model.vcName = @"PickColorViewController";
        [self.dataArray addObject:model];
    }
    
    
    {
        JumpVCModel *model = [[JumpVCModel alloc] init];
        model.title = @"刮一刮";
        model.vcName = @"ScratchViewController";
        [self.dataArray addObject:model];
    }
    
    {
        JumpVCModel *model = [[JumpVCModel alloc] init];
        model.title = @"渐变色";
        model.vcName = @"GradientViewController";
        [self.dataArray addObject:model];
    }
    
    {
        JumpVCModel *model = [[JumpVCModel alloc] init];
        model.title = @"描边处理";
        model.vcName = @"BorderEffectViewController";
        [self.dataArray addObject:model];
    }
    
    {
        JumpVCModel *model = [[JumpVCModel alloc] init];
        model.title = @"图片浏览";
        model.vcName = @"PhotoBrowserViewController";
        [self.dataArray addObject:model];
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    JumpVCModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    JumpVCModel *model = self.dataArray[indexPath.row];
    if (model.viewController) {
        [self.navigationController pushViewController:model.viewController animated:YES];
    }else{
        id viewController = [[NSClassFromString(model.vcName) alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


@end
