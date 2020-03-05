//
//  ALPhotoBroserViewController.h
//  ALImageProcess
//
//  Created by lizihong on 2020/3/4.
//  Copyright © 2020 AL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALPhotoBrowserModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 这个类用到了第三方库SDWebImage
@interface ALPhotoBroserViewController : UIViewController

@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, assign) CGRect fromRect;
@property (nonatomic, assign) NSInteger showingIndex;

- (void)showWithPhotoModels:(NSArray<ALPhotoBrowserModel*> *)photoArray index:(NSInteger)index fromRect:(CGRect)fromRect;

- (ALPhotoBrowserModel *)getCurrentPhotoModel;

@end

NS_ASSUME_NONNULL_END
