//
//  UIScrollView+ESFloatingView.h
//  ESFloatingView_Demo
//
//  Created by ELSS on 2017/3/1.
//  Copyright © 2017年 ELSS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ESFloatingView)

@property (nonatomic, weak) UIView *ES_floatingView;
@property (nonatomic, assign) BOOL ES_isFloating;

@end
