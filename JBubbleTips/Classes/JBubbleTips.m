//
//  JBubbleTips.m
//  JBubbleTips
//
//  Created by jams on 2019/4/8.
//  Copyright © 2019 jams. All rights reserved.
//

#import "JBubbleTips.h"
#import "JBubbleTips+Calculate.h"
#import "UIView+JUtils.h"
#import "JBubbleTips+Draw.h"

@interface JBubbleTips()<UITextViewDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign, readwrite) JBubbleTipsStyle style;
@end

@implementation JBubbleTips

#pragma mark - init
- (instancetype)initWithText:(NSString *)text direction:(JBubbleTipsDirection)direction {
    self = [self init];
    self.text = text;
    self.direction = direction;
    return self;
}

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString direction:(JBubbleTipsDirection)direction {
    self = [self init];
    self.attributedString = attributedString;
    self.direction = direction;
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView direction:(JBubbleTipsDirection)direction {
    self = [self init];
    self.customView = customView;
    self.direction = direction;
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self initDefaultProperties];
    [self initSubViews];
}

- (void)initDefaultProperties {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
   
    self.textAlignment = NSTextAlignmentLeft;
    self.textColor = [UIColor whiteColor];
    self.textFont = [UIFont systemFontOfSize:14];
    
    self.bubbleColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.cornerRadius = 5.f;
    self.pointerSize = 8.f;
    self.pointerOffset = CGPointZero;
    self.bubbleContentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.slidePadding = 5.f;
    self.direction = JBubbleTipsDirectionUp;
    self.maxTextWidth = CGFLOAT_MAX;
    self.lineSpacing = 5.f;
}

- (void)initSubViews {
    [self addSubview:self.contentView];
}

- (void)layoutSubviews {
    CGRect bubbleFrame = [self bubbleFrame];
    self.contentView.frame = bubbleFrame;
    UIEdgeInsets insets = self.bubbleContentInsets;
    self.textView.frame = CGRectMake(insets.left, insets.top, bubbleFrame.size.width - insets.left - insets.right, bubbleFrame.size.height - insets.top - insets.bottom);
    if (self.customView) {
        self.customView.frame = CGRectMake(insets.left, insets.top, self.customView.width, self.customView.height);
    }
}

#pragma mark - point to view/position
- (void)pointAtView:(UIView *)targetView inView:(UIView *)containerView {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint targetPoint = [self convertView:targetView containerView:containerView];
        if (!CGPointEqualToPoint(targetPoint, CGPointZero)) {
            [self pointAtPosition:targetPoint inView:containerView];
        }
    });
}

- (void)pointAtPosition:(CGPoint)targetPoint inView:(UIView *)containerView {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat containerWidth = containerView.width;
        CGFloat containerHeight = containerView.height;
        if (containerWidth <= 0 || containerHeight <= 0) {
            NSLog(@"JBubbleTips Error: container width or height must greater than zero");
            return;
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
        self.frame = bubbleFrame;
        [self setNeedsDisplay];
        [self layoutIfNeeded];
    });
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction  API_AVAILABLE(ios(10.0)){
    if (self.delegate && [self.delegate respondsToSelector:@selector(bubbleTips:didClickInRange:url:)]) {
        [self.delegate bubbleTips:self didClickInRange:characterRange url:URL];
        return NO;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bubbleTips:didClickInRange:url:)]) {
        [self.delegate bubbleTips:self didClickInRange:characterRange url:URL];
        return NO;
    }
    return YES;
}


#pragma mark - setter
- (void)setText:(NSString *)text {
    _text = text;
    self.style = JBubbleTipsStyleText;
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
    _attributedString = attributedString;
    self.style = JBubbleTipsStyleText;
}

- (void)setCustomView:(UIView *)customView {
    _customView = customView;
    self.style = JBubbleTipsStyleCustom;
}

- (void)setStyle:(JBubbleTipsStyle)style {
    _style = style;
    [self update];
}

- (void)update {
    switch (self.style) {
        case JBubbleTipsStyleText:{
            if (![self.textView superview]) {
                [self.contentView addSubview:self.textView];
            }
            NSAttributedString *content = [self generateAttributedString];
            self.textView.attributedText = content;
        }
            break;
            
        case JBubbleTipsStyleCustom: {
            [self.contentView addSubview:self.customView];
        }
            break;
    }
    [self layoutIfNeeded];
}

#pragma mark - getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.editable = NO;
        _textView.textContainerInset = UIEdgeInsetsZero;
        _textView.textContainer.lineFragmentPadding = 0.f;
        _textView.delegate = self;
    }
    return _textView;
}

@end
