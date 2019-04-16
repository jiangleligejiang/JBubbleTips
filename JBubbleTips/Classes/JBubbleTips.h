//
//  JBubbleTips.h
//  JBubbleTips
//
//  Created by jams on 2019/4/8.
//  Copyright © 2019 jams. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JBubbleTipsDirection) {
    JBubbleTipsDirectionUp,
    JBubbleTipsDirectionDown,
    JBubbleTipsDirectionLeft,
    JBubbleTipsDirectionRight
};

typedef NS_ENUM(NSInteger, JBubbleTipsStyle) {
    JBubbleTipsStyleText,
    JBubbleTipsStyleCustom
};

@class JBubbleTips;
@protocol JBubbleTipsDelegate <NSObject>
@optional
- (void)bubbleTips:(JBubbleTips *)bubbleTips didClickInRange:(NSRange)range url:(NSURL *)url;
@end

@interface JBubbleTips : UIView
//气泡相关属性
@property (nonatomic, strong) UIColor *bubbleColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat pointerSize;
@property (nonatomic, assign) UIEdgeInsets bubbleContentInsets;
@property (nonatomic, assign) CGPoint pointerOffset;
@property (nonatomic, assign) CGFloat slidePadding;
@property (nonatomic, assign) CGFloat pointerMargin;

//文本属性
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) CGFloat maxTextWidth;
@property (nonatomic, assign) CGFloat lineSpacing;

//Tips中显示的内容
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSAttributedString *attributedString;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, assign) JBubbleTipsDirection direction;
@property (nonatomic, assign, readonly) JBubbleTipsStyle style;
@property (nonatomic, weak) id<JBubbleTipsDelegate> delegate;

- (instancetype)initWithText:(NSString *)text direction:(JBubbleTipsDirection)direction;
- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString direction:(JBubbleTipsDirection)direction;
- (instancetype)initWithCustomView:(UIView *)customView direction:(JBubbleTipsDirection)direction;

- (void)pointAtView:(UIView *)targetView inView:(UIView *)containerView;
- (void)pointAtPosition:(CGPoint)targetPoint inView:(UIView *)containerView;

@end


@interface JBubbleTips() //Action:show&hide
@property (nonatomic, assign) BOOL disableDismissWhenTouchInContainer;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, copy) void(^showCompletion)(void);
@property (nonatomic, copy) void(^dismissCompletion)(void);
@end
NS_ASSUME_NONNULL_END
