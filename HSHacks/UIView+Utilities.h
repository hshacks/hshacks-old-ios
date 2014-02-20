//
//  UIView+Utilities.h
//  TutorMe
//
//  Created by Emerson Malca on 6/10/12.
//  Copyright (c) 2012 Luma Education Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utilities)

+ (id)initWithNib;
- (UIImage *)screenshot;
- (void)copyShadowPropertiesFromView:(UIView *)view;
- (UIView *)findFirstResponder;
- (void)drawDashedBorderWithRadius:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(UIColor *)lineColor;
- (void)setShadowWithRadius:(CGFloat)radius offset:(CGSize)offset;
- (void)removeAllSubviews;
- (void)addGradientWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;
- (void)addBottomBorderWithColor:(UIColor*)color borderWidth:(CGFloat)borderWidth;

@end
