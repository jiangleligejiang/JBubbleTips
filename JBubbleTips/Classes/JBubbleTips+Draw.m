//
//  JBubbleTips+Draw.m
//  JBubbleTips
//
//  Created by jams on 2019/4/8.
//  Copyright © 2019 jams. All rights reserved.
//

#import "JBubbleTips+Draw.h"
#import "JBubbleTips+Calculate.h"

@implementation JBubbleTips (Draw)

- (void)drawRect:(CGRect)rect {
    CGRect bubbleFrame = [self bubbleFrame];
    if (CGRectEqualToRect(bubbleFrame, CGRectZero)) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.bubbleColor.CGColor);
    UIBezierPath *bubblePath = [UIBezierPath bezierPathWithRoundedRect:bubbleFrame cornerRadius:self.cornerRadius];
    CGContextAddPath(context, bubblePath.CGPath);
    UIBezierPath *arrowPath = [self arrowPath];
    CGContextAddPath(context, arrowPath.CGPath);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
}


- (UIBezierPath *)arrowPath {
    CGPoint p1 = self.arrowPoint, p2, p3;
    switch (self.direction) {
        case JBubbleTipsDirectionUp:{
            p2 = CGPointMake(p1.x + self.pointerSize, p1.y + self.pointerSize);
            p3 = CGPointMake(p1.x - self.pointerSize, p1.y + self.pointerSize);
        }
            break;
        case JBubbleTipsDirectionDown:{
            p2 = CGPointMake(p1.x + self.pointerSize, p1.y - self.pointerSize);
            p3 = CGPointMake(p1.x - self.pointerSize, p1.y - self.pointerSize);
            
        }
            break;
        case JBubbleTipsDirectionLeft: {
            p2 = CGPointMake(p1.x + self.pointerSize, p1.y - self.pointerSize);
            p3 = CGPointMake(p1.x + self.pointerSize, p1.y + self.pointerSize);
        }
            break;
        case JBubbleTipsDirectionRight: {
            p2 = CGPointMake(p1.x - self.pointerSize, p1.y + self.pointerSize);
            p3 = CGPointMake(p1.x - self.pointerSize, p1.y - self.pointerSize);
        }
            break;
    }
    UIBezierPath *bezierpath = [UIBezierPath bezierPath];
    [bezierpath moveToPoint:p1];
    [bezierpath addLineToPoint:p2];
    [bezierpath addLineToPoint:p3];
    [bezierpath closePath];
    return bezierpath;
}

- (CGRect)bubbleFrame {
    CGRect frame;
    switch (self.direction) {
        case JBubbleTipsDirectionUp:
            frame = CGRectMake(0, self.arrowPoint.y + self.pointerSize, self.bubbleSize.width, self.bubbleSize.height);
            break;
        case JBubbleTipsDirectionDown:
            frame = CGRectMake(0, 0, self.bubbleSize.width, self.bubbleSize.height);
            break;
        case JBubbleTipsDirectionLeft:
            frame = CGRectMake(self.arrowPoint.x + self.pointerSize, 0, self.bubbleSize.width, self.bubbleSize.height);
            break;
        case JBubbleTipsDirectionRight:
            frame = CGRectMake(self.arrowPoint.x - self.pointerSize - self.bubbleSize.width, 0, self.bubbleSize.width, self.bubbleSize.height);
            break;
    }
    return frame;
}

@end
