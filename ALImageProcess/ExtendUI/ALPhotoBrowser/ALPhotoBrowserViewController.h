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

typedef enum : NSUInteger {
    ALPhotoBrowserModeNormal = 0,
    ALPhotoBrowserModeEdit
} ALPhotoBrowserMode;

@interface ALPhotoBrowserViewController : UIViewController

@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, assign) CGRect fromRect;
@property (nonatomic, assign) NSInteger showingIndex;
@property (nonatomic, assign) ALPhotoBrowserMode mode;

- (void)showWithPhotoModels:(NSArray<ALPhotoBrowserModel*> *)photoArray index:(NSInteger)index fromRect:(CGRect)fromRect;

- (ALPhotoBrowserModel *)getCurrentPhotoModel;

@end

NS_ASSUME_NONNULL_END
