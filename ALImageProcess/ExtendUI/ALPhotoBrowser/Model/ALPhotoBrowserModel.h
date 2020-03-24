//
//  ALPhotoBrowserModel.h
//  ALImageProcess
//
//  Created by lizihong on 2020/3/4.
//  Copyright © 2020 AL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALPhotoBrowserModel : NSObject

/// 寬
@property (nonatomic, assign) double width;
/// 高
@property (nonatomic, assign) double height;

/// 小圖Image
@property (nonatomic, strong) UIImage *placeholdImage;
/// 大圖url
@property (nonatomic, strong) NSString *originUrlString;


// 以下屬性，編輯模式下有用
/// 是否原圖
@property (nonatomic, assign) BOOL isOrigin;


@end

NS_ASSUME_NONNULL_END
