//
//  UIView+Positioning.m
//  TutorMe
//
//  Created by Emerson Malca on 3/22/12.
//  Copyright (c) 2012 Luma Education Inc. All rights reserved.
//

#import "UIView+Positioning.h"

#define DegreesToRadians(degrees) ((degrees * M_PI) / 180.0)

@implementation UIView (Positioning)

- (CGRect)frameForTopCenterPositionInView:(UIView *)view {
    
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake((CGRectGetWidth(view.bounds)-size.width)/2,
                              0.0,
                              size.width,
                              size.height);
    return CGRectIntegral(frame);
}

- (CGRect)frameForTopRightPositionInView:(UIView *)view {
    
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake(CGRectGetWidth(view.bounds)-size.width,
                              0.0,
                              size.width,
                              size.height);
    return CGRectIntegral(frame);
}

- (CGRect)frameForTopLeftPositionInView:(UIView *)view {
    
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake(0.0,
                              0.0,
                              size.width,
                              size.height);
    return CGRectIntegral(frame);
}

- (CGRect)frameForCenterRightPositionInView:(UIView *)view {
    
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake(CGRectGetWidth(view.bounds)-size.width,
                              CGRectGetHeight(view.bounds)/2 - size.height/2,
                              size.width,
                              size.height);
    return CGRectIntegral(frame);
}

- (CGRect)frameForCenterPositionInView:(UIView *)view {
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake(CGRectGetWidth(view.bounds)/2 - size.width/2,
                              CGRectGetHeight(view.bounds)/2 - size.height/2,
                              size.width,
                              size.height);
    return CGRectIntegral(frame);
}

- (CGRect)frameForCenterLeftPositionInView:(UIView *)view {
    
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake(0.0,
                              CGRectGetHeight(view.bounds)/2 - size.height/2,
                              size.width,
                              size.height);
    return CGRectIntegral(frame);
}

- (CGRect)frameForBottomLeftPositionInView:(UIView *)view {
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake(0.0,
                              CGRectGetHeight(view.bounds) - size.height,
                              size.width,
                              size.height);
    return CGRectIntegral(frame);
}

- (CGRect)frameForBottomCenterPositionInView:(UIView *)view {
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake((CGRectGetWidth(view.bounds) - size.width)/2,
                              CGRectGetHeight(view.bounds) - size.height,
                              size.width,
                              size.height);
    return CGRectIntegral(frame);
}

- (CGRect)frameForBottomRightPositionInView:(UIView *)view {
    CGSize size = self.frame.size;
    CGRect frame = CGRectMake(CGRectGetWidth(view.bounds) - size.width,
                              CGRectGetHeight(view.bounds) - size.height,
                              size.width,
                              size.height);
    return CGRectIntegral(frame);
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = CGRectIntegral(frame);
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = CGRectIntegral(frame);
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = CGRectIntegral(frame);
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = CGRectIntegral(frame);
}

- (void)setTransformForCurrentOrientation:(BOOL)animated {
	// Stay in sync with the superview
	if (self.superview) {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	float radians = 0;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		if (orientation == UIInterfaceOrientationLandscapeLeft) { radians = -M_PI_2; }
		else { radians = M_PI_2; }
		// Window coordinates differ!
		self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
	} else {
		if (orientation == UIInterfaceOrientationPortraitUpsideDown) { radians = M_PI; }
		else { radians = 0; }
	}
	CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(radians);
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	[self setTransform:rotationTransform];
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)rotateByDegrees:(CGFloat)degrees {
    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
    rotationTransform = CGAffineTransformRotate(rotationTransform, DegreesToRadians(degrees));
    self.transform = rotationTransform;
}

- (void)sizeToFitNonBlurry {
    [self sizeToFit];
    [self setFrame:CGRectIntegral(self.frame)];
}

- (CGSize)sizeThatFitsAllSubviews {
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    for (UIView *sv in self.subviews) {
        if (CGRectGetMaxX(sv.frame) > width) {
            width = CGRectGetMaxX(sv.frame);
        }
        if (CGRectGetMaxY(sv.frame) > height) {
            height = CGRectGetMaxY(sv.frame);
        }
    }
    return CGSizeMake(width, height);
}

- (void)setScale:(CGSize)scale {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, scale.width, scale.height);
    self.transform = transform;

}

@end
