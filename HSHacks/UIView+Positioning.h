//
//  UIView+Positioning.h
//  TutorMe
//
//  Created by Emerson Malca on 3/22/12.
//  Copyright (c) 2012 Luma Education Inc. All rights reserved.
//



@interface UIView (Positioning)

- (CGRect)frameForTopCenterPositionInView:(UIView *)view;
- (CGRect)frameForTopRightPositionInView:(UIView *)view;
- (CGRect)frameForTopLeftPositionInView:(UIView *)view;
- (CGRect)frameForCenterRightPositionInView:(UIView *)view;
- (CGRect)frameForCenterPositionInView:(UIView *)view;
- (CGRect)frameForCenterLeftPositionInView:(UIView *)view;
- (CGRect)frameForBottomLeftPositionInView:(UIView *)view;
- (CGRect)frameForBottomCenterPositionInView:(UIView *)view;
- (CGRect)frameForBottomRightPositionInView:(UIView *)view;
- (void)setX:(CGFloat)x;
- (CGFloat)x;
- (void)setY:(CGFloat)y;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setTransformForCurrentOrientation:(BOOL)animated;
- (void)rotateByDegrees:(CGFloat)degrees;
- (void)sizeToFitNonBlurry;
- (CGSize)sizeThatFitsAllSubviews;
- (void)setScale:(CGSize)scale;
@end
