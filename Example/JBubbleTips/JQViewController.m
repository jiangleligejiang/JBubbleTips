//
//  JQViewController.m
//  JBubbleTips
//
//  Created by jams on 04/15/2019.
//  Copyright (c) 2019 jams. All rights reserved.
//

#import "JQViewController.h"
#import "Masonry.h"
#import "JBubbleTips+Action.h"

@interface JQViewController ()
@property (nonatomic, strong) UIButton *targetView;
@property (nonatomic, strong) JBubbleTips *leftTips;
@property (nonatomic, strong) JBubbleTips *rightTips;
@property (nonatomic, strong) JBubbleTips *upTips;
@property (nonatomic, strong) JBubbleTips *downTips;
@property (nonatomic, strong) JBubbleTips *customTips;
@property (nonatomic, strong) UIView *testTextView;
@property (nonatomic, strong) UIButton *customTargetView;
@property (nonatomic, strong) UIView *containerView;
@end

@implementation JQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self testTextBubbleTips];
    [self testCustomView];
}

- (void)testTextBubbleTips {
    _testTextView = [UIView new];
    _testTextView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_testTextView];
    __weak typeof(self) weakSelf = self;
    [_testTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.view.mas_width);
        make.height.mas_equalTo(500);
    }];
    
    _targetView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_targetView addTarget:self action:@selector(didTargetViewPressed:) forControlEvents:UIControlEventTouchUpInside];
    _targetView.backgroundColor = [UIColor greenColor];
    [_testTextView addSubview:_targetView];
    
    [_targetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.top.mas_equalTo(weakSelf.testTextView).offset(200);
        make.centerX.mas_equalTo(weakSelf.testTextView.mas_centerX);
    }];
    
    _leftTips = [[JBubbleTips alloc] initWithText:@"这是箭头指向左边的气泡提示视图这是箭头指向左边的气泡提示视图" direction:JBubbleTipsDirectionLeft];
    
    _rightTips = [[JBubbleTips alloc] init];
    _rightTips.text = @"这是箭头指向右边的气泡提示视图这是箭头指向右边的气泡提示视图";
    _rightTips.direction = JBubbleTipsDirectionRight;
    
    _upTips = [[JBubbleTips alloc] initWithAttributedString:[self generateSimpleAttributedString] direction:JBubbleTipsDirectionUp];
    
    _downTips = [[JBubbleTips alloc] init];
    _downTips.direction = JBubbleTipsDirectionDown;
    _downTips.attributedString = [self generateSimpleAttributedString];
}

- (void)didTargetViewPressed:(UIButton *)button {
//    [_leftTips showPointAtView:_targetView inView:self.testTextView animated:YES];
//    [_rightTips showPointAtView:_targetView animated:YES];
//    [_upTips showPointAtPosition:CGPointMake(self.testTextView.bounds.size.width / 2, 300) inView:self.testTextView animated:YES];
//    [_downTips showPointAtPosition:CGPointMake(self.testTextView.bounds.size.width / 2, 200) animated:NO];
    
        [_leftTips pointAtView:_targetView inView:self.view];
        [_rightTips pointAtView:_targetView inView:self.view];
        [_upTips pointAtPosition:CGPointMake(self.view.bounds.size.width / 2, 300) inView:self.view];
        [_downTips pointAtView:_targetView inView:self.view];
}

- (void)testCustomView {
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_containerView];
    __weak typeof(self) weakSelf = self;
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(550);
        make.size.mas_equalTo(CGSizeMake(300, 150));
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    
    _customTargetView = [UIButton buttonWithType:UIButtonTypeCustom];
    _customTargetView.backgroundColor = [UIColor redColor];
    [_customTargetView addTarget:self action:@selector(didCustomTargetViewPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_customTargetView];
    [_customTargetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.containerView.mas_left).offset(20);
        make.centerY.mas_equalTo(weakSelf.containerView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"This is a label...";
    [customView addSubview:label];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"test"]];
    [customView addSubview:imageView];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(customView.mas_centerX);
        make.top.mas_equalTo(customView).offset(10);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(customView.mas_centerX);
        make.top.mas_equalTo(label.mas_bottom).offset(10);
        make.width.height.mas_equalTo(32);
    }];
    
    _customTips = [[JBubbleTips alloc] initWithCustomView:customView direction:JBubbleTipsDirectionLeft];
    _customTips.bubbleColor = [UIColor lightGrayColor];
}

- (void)didCustomTargetViewPressed:(UIButton *)button {
    [_customTips showPointAtView:button inView:self.containerView animated:YES];
}

- (NSAttributedString *)generateSimpleAttributedString {
    NSString *text = @"正文正文正文正文";
    NSString *linkText = @"百度一下";
    NSString *url = @"https://www.baidu.com";
    NSString *content =[NSString stringWithFormat:@"%@%@", text, linkText];
    NSDictionary *textAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor whiteColor]};
    NSDictionary *linkAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: [UIColor blueColor]};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttributes:textAttribute range:NSMakeRange(0, text.length)];
    [attributedString addAttributes:linkAttribute range:NSMakeRange(text.length, linkText.length)];
    [attributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:url] range:NSMakeRange(text.length, linkText.length)];
    return [attributedString copy];
}

@end
