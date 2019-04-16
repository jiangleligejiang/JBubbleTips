# JBubbleTips

[![CI Status](https://img.shields.io/travis/jams/JBubbleTips.svg?style=flat)](https://travis-ci.org/jams/JBubbleTips)
[![Version](https://img.shields.io/cocoapods/v/JBubbleTips.svg?style=flat)](https://cocoapods.org/pods/JBubbleTips)
[![License](https://img.shields.io/cocoapods/l/JBubbleTips.svg?style=flat)](https://cocoapods.org/pods/JBubbleTips)
[![Platform](https://img.shields.io/cocoapods/p/JBubbleTips.svg?style=flat)](https://cocoapods.org/pods/JBubbleTips)

## 介绍
---
JBubbleTips:通用的气泡提示控件。

![](https://user-gold-cdn.xitu.io/2019/4/16/16a23fc825e414ad?w=308&h=522&f=gif&s=34930)

## 特性
---
- 支持箭头指向四个方向。
- 支持自适应指向对应的targetView或targetPoint。
- 支持文本或富文本的显示。
- 支持自定义view的显示。
- 支持静态和动态显示气泡效果。
- 支持点击消失或定时消失效果。

## 用法
---
### 指向view且静态显示文本
```objc
JBubbleTips *leftTips = [[JBubbleTips alloc] initWithText:@"这是箭头指向左边的气泡提示视图这是箭头指向左边的气泡提示视图" direction:JBubbleTipsDirectionLeft];
[leftTips pointAtView:self.targetView inView:self.view];
```
### 指向point且静态显示富文本
```objc
JBubbleTips *upTips = [[JBubbleTips alloc] initWithAttributedString:[self generateSimpleAttributedString] direction:JBubbleTipsDirectionUp];
[upTips pointAtPosition:CGPointMake(self.view.bounds.size.width / 2, 300) inView:self.view];
```
### 指向view且动态显示文本
```objc
JBubbleTips *rightTips = [[JBubbleTips alloc] init];
rightTips.text = @"这是箭头指向右边的气泡提示视图这是箭头指向右边的气泡提示视图";
rightTips.direction = JBubbleTipsDirectionRight;
[self.rightTips showPointAtView:self.targetView animated:YES];
```
### 指向view且动态显示customView
```objc
JBubbleTips *customTips = [[JBubbleTips alloc] initWithCustomView:customView direction:JBubbleTipsDirectionLeft];
customTips.bubbleColor = [UIColor lightGrayColor];
[customTips showPointAtView:button inView:self.containerView animated:YES];
```
### 定时消失
```objc
[customTips autoDismissAnimated:YES timeInterval:5.0];
```

## 相关接口
---
JBubbleTips.h
```objc
- (instancetype)initWithText:(NSString *)text direction:(JBubbleTipsDirection)direction;
- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString direction:(JBubbleTipsDirection)direction;
- (instancetype)initWithCustomView:(UIView *)customView direction:(JBubbleTipsDirection)direction;
//静态指向targetView(不含点击事件)
- (void)pointAtView:(UIView *)targetView inView:(UIView *)containerView;
//静态指向targetPoint
- (void)pointAtPosition:(CGPoint)targetPoint inView:(UIView *)containerView;
```
JBubbleTips+Action.h
```objc
/**
调用该方法使得气泡提示动态指向某个view
@param targetView 箭头所指向的view
@param containerView 气泡提示所在的super view
*/
- (void)showPointAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated;
- (void)showPointAtView:(UIView *)targetView animated:(BOOL)animated; //默认container view为key window
/**
调用该方法使气泡动态指向某个位置
@param targetPoint 箭头所指向的位置
@param containerView 气泡提示所在的view
@param animated 是否显示动画
*/
- (void)showPointAtPosition:(CGPoint)targetPoint inView:(UIView *)containerView animated:(BOOL)animated;
- (void)showPointAtPosition:(CGPoint)targetPoint animated:(BOOL)animated; //默认container view为key window
- (void)dismissAnimated:(BOOL)animated;
//支持定时关闭气泡提示
- (void)autoDismissAnimated:(BOOL)animated timeInterval:(NSTimeInterval)timeInterval;
```
## 安装
---
### CocoaPod
1. 在PodFile文件中添加```pod "JBubbleTips"```。
2. 执行```pod install```或```pod update```。
3. 导入```JBubbleTips.h```或```JBubbleTips+Action.h```文件，前者用于静态显示气泡，后者用于动态显示气泡。

## License

JBubbleTips is available under the MIT license. See the LICENSE file for more info.
