//
//  UIView+Utilities.m
//  TutorMe
//
//  Created by Emerson Malca on 6/10/12.
//  Copyright (c) 2012 Luma Education Inc. All rights reserved.
//

#import "UIView+Utilities.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Utilities)

+ (id)initWithNib {
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil];
    return [nibViews objectAtIndex:0];
}

- (UIImage *)screenshot {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)copyShadowPropertiesFromView:(UIView *)view {
    [self.layer setShadowColor:view.layer.shadowColor];
    [self.layer setShadowOffset:view.layer.shadowOffset];
    [self.layer setShadowRadius:view.layer.shadowRadius];
    [self.layer setShadowOpacity:view.layer.shadowOpacity];
    [self.layer setShadowPath:view.layer.shadowPath];
}

- (UIView *)findFirstResponder {
    if (self.isFirstResponder) {        
        return self;     
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}

- (void)addBottomBorderWithColor:(UIColor*)color borderWidth:(CGFloat)borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-borderWidth, CGRectGetWidth(self.bounds), borderWidth);
    [self.layer addSublayer:border];
}

- (void)drawDashedBorderWithRadius:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(UIColor *)lineColor
{
    //border definitions
	NSInteger dashPattern1 = 8;
	NSInteger dashPattern2 = 8;
    
    //drawing
	CGRect frame = self.bounds;
    
	CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
    
    //creating a path
	CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
	CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
	CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
	CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
	CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
	CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
	CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
	CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
	CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
	CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
	_shapeLayer.path = path;
	CGPathRelease(path);
    
	_shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
	_shapeLayer.frame = frame;
	_shapeLayer.masksToBounds = NO;
	[_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
	_shapeLayer.fillColor = [[UIColor clearColor] CGColor];
	_shapeLayer.strokeColor = [lineColor CGColor];
	_shapeLayer.lineWidth = borderWidth;
	_shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:dashPattern1], [NSNumber numberWithInt:dashPattern2], nil];
	_shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view, the border is visible
	[self.layer addSublayer:_shapeLayer];
	self.layer.cornerRadius = cornerRadius;
}

- (void)setShadowWithRadius:(CGFloat)radius offset:(CGSize)offset {
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
}

- (void)addGradientWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor {
    CAGradientLayer *layer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)topColor.CGColor,
                       (id)bottomColor.CGColor,
                       nil];
    [layer setColors:colors];
    [layer setFrame:self.bounds];
    [self.layer insertSublayer:layer atIndex:0];
}

- (void)removeAllSubviews {
    for (UIView *sv in self.subviews) {
        [sv removeFromSuperview];
    }
}

@end
