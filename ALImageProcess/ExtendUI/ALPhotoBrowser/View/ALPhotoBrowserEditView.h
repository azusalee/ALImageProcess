//
//  ALPhotoBrowserEditView.h
//  ZeekIM
//
//  Created by lizihong on 2020/3/24.
//  Copyright © 2020 ks. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ALPhotoBrowserEditView;
@protocol ALPhotoBrowserEditViewDelegate <NSObject>

- (void)alPhotoBrowserEditViewDidTapOriginSelect:(ALPhotoBrowserEditView *)view;

@end

@interface ALPhotoBrowserEditView : UIView

@property (nonatomic, strong) UIImageView *originSelectImageView;
@property (nonatomic, strong) UILabel *originSelectLabel;
@property (nonatomic, assign) id<ALPhotoBrowserEditViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
