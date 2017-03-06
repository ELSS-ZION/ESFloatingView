//
//  UIScrollView+ESFloatingView.m
//  ESFloatingView_Demo
//
//  Created by ELSS on 2017/3/1.
//  Copyright © 2017年 ELSS. All rights reserved.
//

#import "UIScrollView+ESFloatingView.h"
#import <objc/runtime.h>

#define ScreenHeight   [UIScreen mainScreen].bounds.size.height
#define KeyWindow      [UIApplication sharedApplication].keyWindow

static char KEY_ES_floatingView;

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
    [instance ESFloatView_setup];
    return instance;
}

- (instancetype)ESFloatView_initWithCoder:(NSCoder *)coder
{
    UIScrollView *instance = [self ESFloatView_initWithCoder:coder];
    [instance ESFloatView_setup];
    return instance;
}

- (void)ESFloatView_setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ESFloatView_ReceivedNotification_KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}


- (void)ESFloatView_ReceivedNotification_KeyboardWillShow:(NSNotification *)notification
{
    self.autoresizesSubviews = NO;
    CGFloat keyboardH = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    if (self.ES_floatingView == NULL)
    {
        return;
    }
    
    CGRect absFrame = [self.ES_floatingView.superview convertRect:self.ES_floatingView.frame toView:KeyWindow];
    
    CGFloat benchmarkY = ScreenHeight - keyboardH - absFrame.size.height;
    
    CGFloat tableVOffset = self.contentOffset.y - (benchmarkY - absFrame.origin.y);
    
    if (tableVOffset < -self.contentInset.top) {
        return;
    }
    
    CGPoint tmpOffset = self.contentOffset;
    tmpOffset.y = tableVOffset;
    self.contentOffset = tmpOffset;
}


- (void)setES_floatingView:(UIView *)floatView
{
    objc_setAssociatedObject(self, &KEY_ES_floatingView, floatView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)ES_floatingView
{
    return objc_getAssociatedObject(self, &KEY_ES_floatingView);
}


@end
