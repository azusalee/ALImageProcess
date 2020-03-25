//
//  ALPhotoBroserViewController.m
//  ALImageProcess
//
//  Created by lizihong on 2020/3/4.
//  Copyright © 2020 AL. All rights reserved.
//

#import "ALPhotoBrowserViewController.h"
#import "ALPhotoBrowserCollectionViewCell.h"

#import <SDWebImage/SDWebImage.h>
#import <AZLExtend/AZLExtend-umbrella.h>
#import "ALPhotoBrowserEditView.h"


@interface ALPhotoBrowserTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPresent;

@end

@implementation ALPhotoBrowserTransition

- (NSTimeInterval)duration{
    return 0.275;
}

- (void)presentTransitionWithContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    ALPhotoBrowserViewController *controller = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    ALPhotoBrowserModel *model = [controller getCurrentPhotoModel];
    CGRect rect = controller.fromRect;
    if (rect.size.width != 0 && rect.size.height != 0) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = model.placeholdImage;
        controller.view.alpha = 0;
        controller.photoCollectionView.hidden = YES;
        CGRect toRect = imageView.bounds;
        
        toRect.size.width = [UIScreen mainScreen].bounds.size.width;
        toRect.size.height = [UIScreen mainScreen].bounds.size.width*model.height/model.width;
        if (toRect.size.height > [UIScreen mainScreen].bounds.size.height) {
            toRect.size.height = [UIScreen mainScreen].bounds.size.height;
            toRect.size.width = [UIScreen mainScreen].bounds.size.height*model.width/model.height;
        }
        
        toRect.origin = CGPointMake(([UIScreen mainScreen].bounds.size.width-toRect.size.width)/2, ([UIScreen mainScreen].bounds.size.height-toRect.size.height)/2);
        //[controller.view addSubview:imageView];
        [transitionContext.containerView addSubview:controller.view];
        [transitionContext.containerView addSubview:imageView];
        [UIView animateWithDuration:[self duration] animations:^{
            imageView.frame = toRect;
            controller.view.alpha = 1;
        } completion:^(BOOL finished) {
            controller.photoCollectionView.hidden = NO;
            [imageView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    }else{
        controller.view.alpha = 0;
        [UIView animateWithDuration:[self duration] animations:^{
            controller.view.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        [transitionContext.containerView addSubview:controller.view];
    }
    
}

- (void)dismissTransitionWithContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    ALPhotoBrowserViewController *controller = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect rect = controller.fromRect;
    if (rect.size.width != 0 && rect.size.height != 0) {
        ALPhotoBrowserCollectionViewCell *cell = (ALPhotoBrowserCollectionViewCell*)[controller.photoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:controller.showingIndex inSection:0]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[cell.imageView convertRect:cell.imageView.bounds toView:[UIApplication sharedApplication].keyWindow]];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = cell.imageView.image;
        controller.view.alpha = 0;
        controller.photoCollectionView.hidden = YES;
        CGRect toRect = rect;
        
        controller.view.alpha = 1;
        [transitionContext.containerView addSubview:controller.view];
        [transitionContext.containerView addSubview:imageView];
        [UIView animateWithDuration:[self duration] animations:^{
            controller.view.alpha = 0;
            imageView.frame = toRect;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }else{
        controller.view.alpha = 1;
        [UIView animateWithDuration:[self duration] animations:^{
            controller.view.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        [transitionContext.containerView addSubview:controller.view];
    }
    
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;
{
    return [self duration];
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (self.isPresent) {
        [self presentTransitionWithContext:transitionContext];
    }else{
        [self dismissTransitionWithContext:transitionContext];
    }
}

@end


@interface ALPhotoBrowserViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate, ALPhotoBrowserEditViewDelegate, ALPhotoBrowserCollectionViewCellDelegate>


@property (nonatomic, strong) NSMutableArray<ALPhotoBrowserModel*> *dataArray;
@property (nonatomic, strong) ALPhotoBrowserEditView *editView;

@end

@implementation ALPhotoBrowserViewController

- (ALPhotoBrowserEditView *)editView{
    if (_editView == nil) {
        _editView = [[ALPhotoBrowserEditView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-60, self.view.bounds.size.width, 60)];
        _editView.delegate = self;
        _editView.originSelectLabel.text = @"原圖";
    }
    return _editView;
}

- (instancetype)init{
    if (self = [super init]) {
        _dataArray = [[NSMutableArray alloc] init];
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.transitioningDelegate = self;
    }
    return self;
}

- (ALPhotoBrowserModel *)getCurrentPhotoModel{
    return self.dataArray[self.showingIndex];
}

- (void)showWithPhotoModels:(NSArray<ALPhotoBrowserModel*> *)photoArray index:(NSInteger)index fromRect:(CGRect)fromRect{
    self.fromRect = fromRect;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:photoArray];
    self.showingIndex = index;
    
    [self azl_presentSelf];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    
    self.photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.photoCollectionView.contentInset = UIEdgeInsetsZero;
    self.photoCollectionView.backgroundColor = [UIColor clearColor];
    self.photoCollectionView.showsVerticalScrollIndicator = NO;
    self.photoCollectionView.showsHorizontalScrollIndicator = NO;
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.pagingEnabled = YES;
    self.photoCollectionView.frame = [UIScreen mainScreen].bounds;
    [self.photoCollectionView registerClass:[ALPhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"ALPhotoBroserCollectionViewCell"];
    [self.view addSubview:self.photoCollectionView];
    [self.photoCollectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width*self.showingIndex, 0)];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.mode == ALPhotoBrowserModeEdit) {
        [self showEditUI];
        [self updateEditUI];
    }
}

- (void)showEditUI{
    [self.view addSubview:self.editView];
    self.editView.hidden = NO;
}

- (void)updateEditUI{
    if (self.mode != ALPhotoBrowserModeEdit) {
        return;
    }
    ALPhotoBrowserModel *model = self.dataArray[self.showingIndex];
    self.editView.originSelectImageView.highlighted = model.isOrigin;
    
}

#pragma mark - Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger showingIndex = (scrollView.contentOffset.x/self.view.bounds.size.width)+0.5;
    if (self.showingIndex != showingIndex) {
        self.showingIndex = showingIndex;
        [self updateEditUI];
    }
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ALPhotoBrowserCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    ALPhotoBrowserModel *model = self.dataArray[indexPath.row];
    cell.originUrl = model.originUrlString;
    [cell.scrollView setZoomScale:1];
    [cell setImageWidth:model.width height:model.height];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.originUrlString] placeholderImage:model.placeholdImage];
    
    return cell;
}

- (void)alPhotoBrowserCollectionViewCellDidTap:(ALPhotoBrowserCollectionViewCell *)cell{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alPhotoBrowserEditViewDidTapOriginSelect:(ALPhotoBrowserEditView *)view{
    ALPhotoBrowserModel *model = self.dataArray[self.showingIndex];
    model.isOrigin = !model.isOrigin;
    [self updateEditUI];
}

#pragma mark - UIViewControllerTransitioningDelegate過場
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    ALPhotoBrowserTransition *transition = [[ALPhotoBrowserTransition alloc] init];
    transition.isPresent = YES;
    return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    ALPhotoBrowserTransition *transition = [[ALPhotoBrowserTransition alloc] init];
    transition.isPresent = NO;
    return transition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return nil;
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
