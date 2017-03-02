//
//  UIScrollView+ESFloatingView.m
//  ESFloatingView_Demo
//
//  Created by ELSS on 2017/3/1.
//  Copyright © 2017年 ELSS. All rights reserved.
//

#import "UIScrollView+ESFloatingView.h"
#import <objc/runtime.h>

#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define kKeyWindow      [UIApplication sharedApplication].keyWindow

static char KEY_ES_floatingView;
static char KEY_ES_isFloating;
static char KEY_displayLink;
static char KEY_targetOffsetY;

@interface UIScrollView ()

@property (nonatomic, assign) CGFloat targetOffsetY;
@property (strong, nonatomic) CADisplayLink *displayLink;

@end

@implementation UIScrollView (ESFloatingView)


+ (void)load
{
    Method m1 = class_getInstanceMethod(self, @selector(initWithFrame:));
    Method m2 = class_getInstanceMethod(self, @selector(ESFloatView_initWithFrame:));
    method_exchangeImplementations(m1, m2);
    
    Method m3 = class_getInstanceMethod(self, @selector(initWithCoder:));
    Method m4 = class_getInstanceMethod(self, @selector(ESFloatView_initWithCoder:));
    method_exchangeImplementations(m3, m4);
}

- (instancetype)ESFloatView_initWithFrame:(CGRect)frame
{
    UIScrollView *instance = [self ESFloatView_initWithFrame:frame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ESFloatView_ReceivedNotification_KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    return instance;
}

- (instancetype)ESFloatView_initWithCoder:(NSCoder *)coder
{
    UIScrollView *instance = [self ESFloatView_initWithCoder:coder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ESFloatView_ReceivedNotification_KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    return instance;
}


- (void)ESFloatView_ReceivedNotification_KeyboardWillShow:(NSNotification *)notification
{
    CGFloat keyboardH = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    if (self.ES_floatingView == NULL)
    {
        return;
    }
    
    CGRect absFrame = [self.ES_floatingView.superview convertRect:self.ES_floatingView.frame toView:kKeyWindow];
    
    CGFloat benchmarkY = kScreenHeight - keyboardH - absFrame.size.height;
    
    CGFloat tableVOffset = self.contentOffset.y - (benchmarkY - absFrame.origin.y);
    
    
    self.targetOffsetY = tableVOffset;
    
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    
}

- (void)ESFloatView_scrollToOffset
{
    if (self.contentOffset.y - self.targetOffsetY < 2 && self.contentOffset.y - self.targetOffsetY > -2)
    {
        CGPoint tmpOffset = self.contentOffset;
        tmpOffset.y = self.targetOffsetY;
        self.contentOffset = tmpOffset;
        
        [self.displayLink invalidate];
        self.displayLink = nil;
        
        self.ES_isFloating = NO;
        return;
    }
    
    self.ES_isFloating = YES;
    CGPoint tmpOffset = self.contentOffset;
    tmpOffset.y += (self.targetOffsetY - self.contentOffset.y) * 0.15;
    self.contentOffset = tmpOffset;
}

- (void)setTargetOffsetY:(CGFloat)targetOffsetY
{
    objc_setAssociatedObject(self, &KEY_targetOffsetY, @(targetOffsetY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGFloat)targetOffsetY
{
    return [objc_getAssociatedObject(self, &KEY_targetOffsetY) doubleValue];
}

- (void)setDisplayLink:(CADisplayLink *)displayLink
{
    objc_setAssociatedObject(self, &KEY_displayLink, displayLink, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CADisplayLink *)displayLink
{
    if (objc_getAssociatedObject(self, &KEY_displayLink) == NULL) {
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(ESFloatView_scrollToOffset)];
        objc_setAssociatedObject(self, &KEY_displayLink, displayLink, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return objc_getAssociatedObject(self, &KEY_displayLink);
}

- (void)setES_floatingView:(UIView *)floatView
{
    objc_setAssociatedObject(self, &KEY_ES_floatingView, floatView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)ES_floatingView
{
    return objc_getAssociatedObject(self, &KEY_ES_floatingView);
}

- (void)setES_isFloating:(BOOL)ES_isFloating
{
    objc_setAssociatedObject(self, &KEY_ES_isFloating, @(ES_isFloating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ES_isFloating
{
    return [objc_getAssociatedObject(self, &KEY_ES_isFloating) boolValue];
}



@end
