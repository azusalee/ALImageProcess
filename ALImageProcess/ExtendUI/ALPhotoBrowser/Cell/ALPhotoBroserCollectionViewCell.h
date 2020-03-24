//
//  ALPhotoBroserCollectionViewCell.h
//  ALImageProcess
//
//  Created by lizihong on 2020/3/4.
//  Copyright © 2020 AL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ALPhotoBroserCollectionViewCell;
@protocol ALPhotoBroserCollectionViewCellDelegate <NSObject>

- (void)alPhotoBroserCollectionViewCellDidTap:(ALPhotoBroserCollectionViewCell*)cell;

@end

@interface ALPhotoBroserCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *originUrl;
@property (nonatomic, weak) id<ALPhotoBroserCollectionViewCellDelegate> delegate;

- (void)setImageWidth:(CGFloat)width height:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
