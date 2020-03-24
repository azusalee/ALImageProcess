//
//  ALPhotoBrowserEditView.m
//  ZeekIM
//
//  Created by lizihong on 2020/3/24.
//  Copyright © 2020 ks. All rights reserved.
//

#import "ALPhotoBrowserEditView.h"

@implementation ALPhotoBrowserEditView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.originSelectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.bounds.size.height/2-10, 20, 20)];
    self.originSelectImageView.image = [UIImage imageNamed:@"checkbox_off"];
    self.originSelectImageView.highlightedImage = [UIImage imageNamed:@"checkbox_on"];
    self.originSelectImageView.userInteractionEnabled = YES;
    [self addSubview:self.originSelectImageView];
    
    self.originSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, self.bounds.size.height/2-10, self.bounds.size.width-58, 20)];
    self.originSelectLabel.textColor = [UIColor whiteColor];
    self.originSelectLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.originSelectLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(originSelectDidTap:)];
    [self.originSelectImageView addGestureRecognizer:tapGesture];
    
}

- (void)originSelectDidTap:(UITapGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.delegate alPhotoBrowserEditViewDidTapOriginSelect:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
