//
//  JBubbleTips+Action.m
//  JBubbleTips
//
//  Created by jams on 2019/4/15.
//  Copyright © 2019 jams. All rights reserved.
//

#import "JBubbleTips+Action.h"
#import "objc/runtime.h"
#import "JBubbleTips+Calculate.h"
#import "UIView+JUtils.h"
@interface JBubbleTips ()
@property (nonatomic, strong) UIButton *dismissTarget;
@property (nonatomic, strong) NSTimer *autoDismissTimer;
@end

@implementation JBubbleTips (Action)

#pragma mark - show
- (void)showPointAtView:(UIView *)targetView animated:(BOOL)animated {
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if (!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    UIApplication *app = [UIApplication performSelector:@selector(sharedApplication)];
    [self showPointAtView:targetView inView:[app keyWindow] animated:animated];
}

- (void)showPointAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint targetPoint = [self convertView:targetView containerView:containerView];
        if (!CGPointEqualToPoint(CGPointZero, targetPoint)) {
            [self showPointAtPosition:targetPoint inView:containerView animated:animated];
        }
    });
}

- (void)showPointAtPosition:(CGPoint)targetPoint animated:(BOOL)animated {
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if (!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    UIApplication *app = [UIApplication performSelector:@selector(sharedApplication)];
    [self showPointAtPosition:targetPoint inView:[app keyWindow] animated:animated];
}

- (void)showPointAtPosition:(CGPoint)targetPoint inView:(UIView *)containerView animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat containerWidth = containerView.width;
        CGFloat containerHeight = containerView.height;
        if (containerWidth <= 0 || containerHeight <= 0) {
            NSLog(@"JBubbleTips Error: container width or height can not below or equal to zero");
            return;
        }
        
        if (!self.dismissTarget && !self.disableDismissWhenTouchInContainer) {
            self.dismissTarget = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.dismissTarget addTarget:self action:@selector(dismissTargetDidClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.dismissTarget setTitle:@"" forState:UIControlStateNormal];
            self.dismissTarget.frame = containerView.bounds;
            [containerView addSubview:self.dismissTarget];
        }
        
        self.bubbleSize = [self bubbleSizeWithTargetPoint:targetPoint inContainerView:containerView];
        if (self.bubbleSize.width <= 0 || self.bubbleSize.height <= 0) {
            NSLog(@"JBubbleTips Error: caculated bubble's width or height is less than zero");
            return;
        }
        
        if (![self superview]) {
            [containerView addSubview:self];
        }
        CGRect bubbleFrame = [self bubbleFrameWithTargetPoint:targetPoint inContainerView:containerView];
        
        if (animated) {
            self.alpha = 0.f;
            self.frame = bubbleFrame;
            [self setNeedsDisplay];
            [self layoutIfNeeded];
            [UIView animateWithDuration:0.2 animations:^{
                self.alpha = 1.f;
            }];
        } else {
            self.frame = bubbleFrame;
            self.alpha = 1.f;
            [self setNeedsDisplay];
            [self layoutIfNeeded];
        }
        
        self.isShowing = YES;
        if (self.showCompletion) {
            self.showCompletion();
        }
    });
}

#pragma mark - dismiss
- (void)dismissAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2f animations:^{
            [self finalizeDismiss];
        }];
    } else {
        [self finalizeDismiss];
    }
}

- (void)autoDismissAnimated:(BOOL)animated timeInterval:(NSTimeInterval)timeInterval {
    if (timeInterval <= 0.f) {
        return;
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:animated] forKey:@"animated"];
    [self.autoDismissTimer invalidate];
    self.autoDismissTimer = nil;
    self.autoDismissTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(autoDismissAnimatedDidFire:) userInfo:userInfo repeats:NO];
}

- (void)autoDismissAnimatedDidFire:(NSTimer *)timer {
    NSNumber *animated = [[timer userInfo] objectForKey:@"animted"];
    [self dismissAnimated:[animated boolValue]];
}

- (void)finalizeDismiss {
    self.alpha = 0.f;
    self.isShowing = NO;
    if (self.autoDismissTimer) {
        [self.autoDismissTimer invalidate];
        self.autoDismissTimer = nil;
    }
    if (self.dismissTarget) {
        [self.dismissTarget removeFromSuperview];
        self.dismissTarget = nil;
    }
    if (self.dismissCompletion) {
        self.dismissCompletion();
    }
    [self removeFromSuperview];
}

#pragma mark - event
- (void)dismissTargetDidClick:(UIButton *)button {
    [self dismissAnimated:YES];
}

#pragma mark - getter & setter

- (void)setDismissTarget:(UIButton *)dismissTarget {
    objc_setAssociatedObject(self, @selector(dismissTarget), dismissTarget, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)dismissTarget {
    return objc_getAssociatedObject(self, @selector(dismissTarget));
}

- (void)setAutoDismissTimer:(NSTimer *)autoDismissTimer {
    objc_setAssociatedObject(self, @selector(autoDismissTimer), autoDismissTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)autoDismissTimer {
    return objc_getAssociatedObject(self, @selector(autoDismissTimer));
}

@end
