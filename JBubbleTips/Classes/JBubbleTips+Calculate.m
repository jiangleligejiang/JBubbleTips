//
//  JBubbleTips+Calculate.m
//  JBubbleTips
//
//  Created by jams on 2019/4/8.
//  Copyright © 2019 jams. All rights reserved.
//

#import "JBubbleTips+Calculate.h"
#import "UIView+JUtils.h"
#import "objc/runtime.h"
@implementation JBubbleTips (Calculate)

#pragma mark - calculate method
- (CGPoint)convertView:(UIView *)targetView containerView:(UIView *)containerView {
    if (targetView == nil || containerView == nil) {
        return CGPointZero;
    }
    if (targetView.width <= 0 || targetView.height <= 0) {
        return CGPointZero;
    }
    if (containerView.width <= 0 || containerView.height <= 0) {
        return CGPointZero;
    }
    
    CGPoint originPoint = CGPointZero;
    switch (self.direction) {
        case JBubbleTipsDirectionUp:{
            originPoint = CGPointMake(targetView.width / 2, targetView.height);
        }
            break;
        case JBubbleTipsDirectionDown: {
            originPoint = CGPointMake(targetView.width / 2, 0);
        }
            break;
        case JBubbleTipsDirectionLeft: {
            originPoint = CGPointMake(targetView.width, targetView.height / 2);
        }
            break;
        case JBubbleTipsDirectionRight: {
            originPoint = CGPointMake(0, targetView.height / 2);
        }
            break;
    }
    return [targetView convertPoint:originPoint toView:containerView];
}

- (CGSize)bubbleSizeWithTargetPoint:(CGPoint)targetPoint inContainerView:(UIView *)containerView {
    CGSize bubbleSize = CGSizeZero;
    switch (self.style) {
        case JBubbleTipsStyleText:{
            CGFloat maxContentWidth,maxContentHeight;
            switch (self.direction) {
                case JBubbleTipsDirectionUp:{
                    maxContentWidth = containerView.width - 2 * self.slidePadding - self.bubbleContentInsets.left - self.bubbleContentInsets.right;
                    maxContentHeight = containerView.height - targetPoint.y - self.pointerSize - self.pointerMargin - self.bubbleContentInsets.top - self.bubbleContentInsets.bottom;
                }
                    break;
                case JBubbleTipsDirectionDown: {
                    maxContentWidth = containerView.width - 2 *self.slidePadding - self.bubbleContentInsets.left - self.bubbleContentInsets.right;
                    maxContentHeight = targetPoint.y - self.pointerSize - self.pointerMargin - self.bubbleContentInsets.top - self.bubbleContentInsets.bottom;
                }
                    break;
                case JBubbleTipsDirectionLeft: {
                    maxContentWidth = containerView.width - targetPoint.x - self.slidePadding - self.pointerSize - self.pointerMargin - self.bubbleContentInsets.left - self.bubbleContentInsets.right;
                    maxContentHeight = containerView.height - 2 * self.slidePadding - self.bubbleContentInsets.top - self.bubbleContentInsets.bottom;
                }
                    break;
                case JBubbleTipsDirectionRight: {
                    maxContentWidth = targetPoint.x - self.slidePadding - self.pointerSize - self.pointerMargin - self.bubbleContentInsets.left - self.bubbleContentInsets.right;
                    maxContentHeight = containerView.height - 2 * self.slidePadding - self.bubbleContentInsets.top - self.bubbleContentInsets.bottom;
                }
                    break;
            }
            maxContentWidth = MIN(maxContentWidth, self.maxTextWidth);
            NSAttributedString *content = [self generateAttributedString];
            CGRect contentRect = [content boundingRectWithSize:CGSizeMake(maxContentWidth, maxContentHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            CGFloat bubbleWidth = contentRect.size.width + self.bubbleContentInsets.left + self.bubbleContentInsets.right;
            CGFloat bubbleHeight = contentRect.size.height + self.bubbleContentInsets.top + self.bubbleContentInsets.bottom;
            bubbleSize = CGSizeMake(bubbleWidth, bubbleHeight);
        }
            break;
            
        case JBubbleTipsStyleCustom:
            if (self.customView && self.customView.width != 0 && self.customView.height != 0) {
                CGFloat width = self.customView.width + self.bubbleContentInsets.left + self.bubbleContentInsets.right;
                CGFloat height = self.customView.height + self.bubbleContentInsets.top + self.bubbleContentInsets.bottom;
                bubbleSize = CGSizeMake(width, height);
            }
            break;
    }
    return bubbleSize;
}

- (NSAttributedString *)generateAttributedString {
    if (self.attributedString) {
        return [self.attributedString copy];
    } else {
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle alloc] init];
        textStyle.alignment = self.textAlignment;
        textStyle.lineSpacing = self.lineSpacing;
        NSDictionary *attributes = @{NSFontAttributeName : self.textFont, NSForegroundColorAttributeName : self.textColor, NSParagraphStyleAttributeName : textStyle};
            
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:self.text];
        [content addAttributes:attributes range:NSMakeRange(0, self.text.length)];
        return [content copy];
    }
}

- (CGRect)bubbleFrameWithTargetPoint:(CGPoint)targetPoint inContainerView:(UIView *)containerView {
    CGRect bubbleFrame;
    CGFloat pointerX = targetPoint.x;
    CGFloat pointerY = targetPoint.y;
    switch (self.direction) {
        case JBubbleTipsDirectionUp:
        case JBubbleTipsDirectionDown:{
            CGFloat x_begin = pointerX - roundf(self.bubbleSize.width / 2);
            if (x_begin < self.slidePadding) {
                x_begin = self.slidePadding;
            }
            if (x_begin + self.bubbleSize.width + self.slidePadding > containerView.width) {
                x_begin = containerView.width - self.bubbleSize.width - self.slidePadding;
            }
            
            CGFloat x_pointer = pointerX;
            if (x_pointer - self.pointerSize - self.cornerRadius < x_begin) {
                x_pointer = x_begin + self.pointerSize + self.cornerRadius;
            }
            if (x_pointer + self.pointerSize + self.cornerRadius > x_begin + self.bubbleSize.width) {
                x_pointer = x_begin + self.bubbleSize.width - self.pointerSize - self.cornerRadius;
            }
            CGFloat fullHeight = self.bubbleSize.height + self.pointerSize;
            CGFloat y_begin;
            CGPoint arrowPoint;
            if (self.direction == JBubbleTipsDirectionUp) {
                y_begin = pointerY + self.pointerMargin;
                arrowPoint = CGPointMake(x_pointer - x_begin, 0);
            } else {
                y_begin = pointerY - fullHeight - self.pointerMargin;
                arrowPoint = CGPointMake(x_pointer - x_begin, fullHeight);
            }
            self.arrowPoint = arrowPoint;
            bubbleFrame = CGRectMake(x_begin + self.pointerOffset.x, y_begin + self.pointerOffset.y, self.bubbleSize.width, fullHeight);
        }
            break;
            
        case JBubbleTipsDirectionLeft:
        case JBubbleTipsDirectionRight: {
            CGFloat y_begin = pointerY - roundf(self.bubbleSize.height / 2);
            if (y_begin < self.slidePadding) {
                y_begin = self.slidePadding;
            }
            if (y_begin + self.bubbleSize.height + self.slidePadding > containerView.height) {
                y_begin = containerView.height - self.slidePadding - self.bubbleSize.height;
            }
            
            CGFloat y_pointer = pointerY;
            if (y_pointer - self.pointerSize - self.cornerRadius < y_begin) {
                y_pointer = y_begin + self.pointerSize + self.cornerRadius;
            }
            if (y_pointer + self.pointerSize + self.cornerRadius > y_begin + self.bubbleSize.height) {
                y_pointer = y_begin + self.bubbleSize.height - self.pointerSize - self.cornerRadius;
            }
            
            CGFloat fullWidth = self.bubbleSize.width + self.pointerSize;
            CGFloat x_begin;
            CGPoint arrowPoint;
            if (self.direction == JBubbleTipsDirectionLeft) {
                x_begin = pointerX + self.pointerMargin;
                arrowPoint = CGPointMake(0, y_pointer - y_begin);
            } else {
                x_begin = pointerX - self.pointerMargin - fullWidth;
                arrowPoint = CGPointMake(fullWidth, y_pointer - y_begin);
            }
            self.arrowPoint = arrowPoint;
            bubbleFrame = CGRectMake(x_begin + self.pointerOffset.x, y_begin + self.pointerOffset.y, fullWidth, self.bubbleSize.height);
        }
            break;
    }
    return bubbleFrame;
}

@end
