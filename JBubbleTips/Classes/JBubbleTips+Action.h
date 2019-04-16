//
//  JBubbleTips+Action.h
//  JBubbleTips
//
//  Created by jams on 2019/4/15.
//  Copyright © 2019 jams. All rights reserved.
//

#import "JBubbleTips.h"

NS_ASSUME_NONNULL_BEGIN

@interface JBubbleTips (Action)

/**
 调用该方法使得气泡提示指向某个view
 @param targetView 箭头所指向的view
 @param containerView 气泡提示所在的super view
 */
- (void)showPointAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated;

- (void)showPointAtView:(UIView *)targetView animated:(BOOL)animated; //默认container view为key window

/**
 调用该方法使气泡指向某个位置
 @param targetPoint 箭头所指向的位置
 @param containerView 气泡提示所在的view
 @param animated 是否显示动画
 */
- (void)showPointAtPosition:(CGPoint)targetPoint inView:(UIView *)containerView animated:(BOOL)animated;

- (void)showPointAtPosition:(CGPoint)targetPoint animated:(BOOL)animated; //默认container view为key window


- (void)dismissAnimated:(BOOL)animated;
//支持定时关闭气泡提示
- (void)autoDismissAnimated:(BOOL)animated timeInterval:(NSTimeInterval)timeInterval;


@end

NS_ASSUME_NONNULL_END
