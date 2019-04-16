//
//  JBubbleTips+Calculate.h
//  JBubbleTips
//
//  Created by jams on 2019/4/8.
//  Copyright © 2019 jams. All rights reserved.
//

#import "JBubbleTips.h"

NS_ASSUME_NONNULL_BEGIN

@interface JBubbleTips()
@property (nonatomic, assign) CGSize bubbleSize;
@property (nonatomic, assign) CGPoint arrowPoint;
@end

@interface JBubbleTips (Calculate)

- (CGPoint)convertView:(UIView *)targetView containerView:(UIView *)containerView;

- (CGSize)bubbleSizeWithTargetPoint:(CGPoint)targetPoint inContainerView:(UIView *)containerView;

- (CGRect)bubbleFrameWithTargetPoint:(CGPoint)targetPoint inContainerView:(UIView *)containerView;

- (NSAttributedString *)generateAttributedString;

@end

NS_ASSUME_NONNULL_END
