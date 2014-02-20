//
//  UIView+ShowAnimations.m
//  TutorMe
//
//  Created by Emerson Malca on 3/18/12.
//  Copyright (c) 2012 Luma Education Inc. All rights reserved.
//

#import "UIView+ShowAnimations.h"
#import <QuartzCore/QuartzCore.h>

#define kTMPopAnimationDefaultDuration  0.3

@implementation UIView (ShowAnimations)

- (void)prepareForAnimatingIn {
}

- (void)animateIn {
}

- (void)animateOutWithCompletion:(void (^)(BOOL finished))completion {
}

- (void)popFromInitialScale:(CGFloat)scale {
    [self popFromInitialScale:scale fadeInFromInitialAlpha:1.0 duration:kTMPopAnimationDefaultDuration completion:NULL];
}

- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha {
    [self popFromInitialScale:scale fadeInFromInitialAlpha:alpha duration:kTMPopAnimationDefaultDuration completion:NULL];
}

- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha duration:(CGFloat)duration {
    [self popFromInitialScale:scale fadeInFromInitialAlpha:alpha duration:duration completion:NULL];
}

- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion {
    
    [self popFromInitialScale:scale fadeInFromInitialAlpha:alpha duration:duration delay:0.0 completion:completion];
}

- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha duration:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(BOOL finished))completion {
    [self popFromInitialScale:scale fadeInFromInitialAlpha:alpha duration:duration delay:delay viewCorner:UIViewCornerNone shouldKeepOriginalAnchorPointAndPosition:YES completion:completion];
}

- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha duration:(CGFloat)duration delay:(CGFloat)delay viewCorner:(UIViewCorner)viewCorner shouldKeepOriginalAnchorPointAndPosition:(BOOL)shouldKeepOriginals completion:(void (^)(BOOL finished))completion {
    //Min
    if (scale < 0.01) {
        scale = 0.01;
    }
    
    //Old anchor point and position
    CGPoint anchorPoint = self.layer.anchorPoint;
    CGPoint position = self.layer.position;
    
    switch (viewCorner) {
        case UIViewCornerTopLeft:
            self.layer.anchorPoint = CGPointMake(0.0, 0.0);
            self.layer.position = CGPointMake(position.x - CGRectGetWidth(self.layer.bounds)/2, position.y - CGRectGetHeight(self.layer.bounds)/2);
            break;
        case UIViewCornerTopRight:
            self.layer.anchorPoint = CGPointMake(1.0, 0.0);
            self.layer.position = CGPointMake(position.x + CGRectGetWidth(self.layer.bounds)/2, position.y - CGRectGetHeight(self.layer.bounds)/2);
            break;
        case UIViewCornerBottomLeft:
            self.layer.anchorPoint = CGPointMake(0.0, 1.0);
            self.layer.position = CGPointMake(position.x - CGRectGetWidth(self.layer.bounds)/2, position.y + CGRectGetHeight(self.layer.bounds)/2);
            break;
        case UIViewCornerBottomRight:
            self.layer.anchorPoint = CGPointMake(0.0, 0.0);
            self.layer.position = CGPointMake(position.x + CGRectGetWidth(self.layer.bounds)/2, position.y + CGRectGetHeight(self.layer.bounds)/2);
            break;
        default:
            break;
    }
    
    //Make the view super tiny
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    //Make the view transparent
    self.alpha = alpha;
    
    __weak UIView *weakSelf = self;
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options:(UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction)
                     animations:^ {
                         
                         UIView *strongSelf = weakSelf;
                         if (strongSelf) {
                             //Grow the view a little bit larger than original size
                             strongSelf.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                             strongSelf.alpha = 1.0;
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:duration/2
                                               delay:0.0
                                             options:(UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction)
                                          animations:^ {
                                              
                                              UIView *strongSelf = weakSelf;
                                              if (strongSelf) {
                                                  //Shrink the view a little bit smaller than original size
                                                  strongSelf.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                                              }
                                              
                                          }
                                          completion:^(BOOL finished) {
                                              
                                              [UIView animateWithDuration:duration/2
                                                               animations:^{
                                                                   
                                                                   UIView *strongSelf = weakSelf;
                                                                   if (strongSelf) {
                                                                       //Bring the view back to its original size
                                                                       strongSelf.transform = CGAffineTransformIdentity;
                                                                   }
                                                                   
                                                               }
                                                               completion:^(BOOL finished){
                                                                   
                                                                   //Reset the anchor point and position
                                                                   UIView *strongSelf = weakSelf;
                                                                   if (strongSelf && shouldKeepOriginals) {
                                                                       strongSelf.layer.anchorPoint = anchorPoint;
                                                                       strongSelf.layer.position = position;
                                                                   }
                                                                   
                                                                   if (completion != NULL) {
                                                                       completion(finished);
                                                                   }
                                                               }];
                                              
                                          }];
                         
                     }];
}

- (void)popChangeToView:(UIView *)view completion:(void (^)(BOOL finished))completion {
    
    view.alpha = 0.0;
    view.center = self.center;
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    
    if (view.superview != self.superview) {
        [self.superview addSubview:view];
    }
    
    __weak UIView *weakView = view;
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^ {
                         
                         UIView *strongSelf = weakSelf;
                         if (strongSelf) {
                             //Grow the view a little bit larger than original size
                             strongSelf.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.2
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^ {
                                              
                                              UIView *strongSelf = weakSelf;
                                              UIView *strongView = weakView;
                                              if (strongSelf && strongView) {
                                                  //Shrink the view to its original size and fade out
                                                  strongSelf.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                                                  strongSelf.alpha = 0.0;
                                                  strongView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                                                  strongView.alpha = 1.0;
                                              }
                                              
                                          }
                                          completion:^(BOOL finished) {
                                              
                                              if (completion != NULL) {
                                                  completion(finished);
                                              }
                                              
                                          }];
                         
                     }];
}

- (void)popDismissWithDuration:(CGFloat)duration completion:(void (^)(BOOL finished))completion {
    [self popDismissWithDuration:duration delay:0.0 completion:completion];
}

- (void)popDismissWithDuration:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(BOOL finished))completion {
    [self popDismissWithDuration:duration delay:delay viewCorner:UIViewCornerNone completion:completion];
}

- (void)popDismissWithDuration:(CGFloat)duration delay:(CGFloat)delay viewCorner:(UIViewCorner)viewCorner completion:(void (^)(BOOL finished))completion {
    
    //Old anchor point and position
    CGPoint position = self.layer.position;
    
    switch (viewCorner) {
        case UIViewCornerTopLeft:
            self.layer.anchorPoint = CGPointMake(0.0, 0.0);
            self.layer.position = CGPointMake(position.x - CGRectGetWidth(self.layer.bounds)/2, position.y - CGRectGetHeight(self.layer.bounds)/2);
            break;
        case UIViewCornerTopRight:
            self.layer.anchorPoint = CGPointMake(1.0, 0.0);
            self.layer.position = CGPointMake(position.x + CGRectGetWidth(self.layer.bounds)/2, position.y - CGRectGetHeight(self.layer.bounds)/2);
            break;
        case UIViewCornerBottomLeft:
            self.layer.anchorPoint = CGPointMake(0.0, 1.0);
            self.layer.position = CGPointMake(position.x - CGRectGetWidth(self.layer.bounds)/2, position.y + CGRectGetHeight(self.layer.bounds)/2);
            break;
        case UIViewCornerBottomRight:
            self.layer.anchorPoint = CGPointMake(0.0, 0.0);
            self.layer.position = CGPointMake(position.x + CGRectGetWidth(self.layer.bounds)/2, position.y + CGRectGetHeight(self.layer.bounds)/2);
            break;
        default:
            break;
    }
    
    __weak UIView *weakSelf = self;
    
    [UIView animateWithDuration:duration/2
                          delay:delay
                        options:(UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction)
                     animations:^ {
                         
                         UIView *strongSelf = weakSelf;
                         if (strongSelf) {
                             //Grow the view a little bit larger than original size
                             strongSelf.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:duration/2
                                               delay:0.0
                                             options:(UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction)
                                          animations:^ {
                                              
                                              UIView *strongSelf = weakSelf;
                                              if (strongSelf) {
                                                  //Shrink the view completely
                                                  strongSelf.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);
                                                  strongSelf.alpha = 0.0;
                                              }
                                              
                                          }
                                          completion:^(BOOL finished) {
                                              UIView *strongSelf = weakSelf;
                                              if (strongSelf) {
                                                  //Bring the view back to its original size
                                                  strongSelf.transform = CGAffineTransformIdentity;
                                              }
                                              
                                              if (completion != NULL) {
                                                  completion(finished);
                                              }
                                              
                                          }];
                         
                     }];
    

}

- (void)slideToFinalFrame:(CGRect)finalFrame maxBounceOffset:(CGPoint)offset duration:(CGFloat)duration {
    //First we want to go as further as we can
    CGRect firstBounceFrame = CGRectOffset(finalFrame, offset.x, offset.y);
    //Second we want to bounce back and go half way more the other way
    CGRect secondBounceFrame = CGRectOffset(finalFrame, -offset.x/2, -offset.y/2);
    
    __weak UIView *weakSelf = self;
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionOverrideInheritedDuration)
                     animations:^ {
                         
                         UIView *strongSelf = weakSelf;
                         if (strongSelf) {
                            self.frame = firstBounceFrame; 
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:duration/2
                                               delay:0.0
                                             options:(UIViewAnimationOptionCurveLinear|UIViewAnimationOptionOverrideInheritedDuration)
                                          animations:^ {
                                              
                                              UIView *strongSelf = weakSelf;
                                              if (strongSelf) {
                                                  self.frame = secondBounceFrame;
                                              }
                                          }
                                          completion:^(BOOL finished) {
                                              
                                              [UIView animateWithDuration:duration/2
                                                                    delay:0.0
                                                                  options:(UIViewAnimationOptionCurveLinear|UIViewAnimationOptionOverrideInheritedDuration)
                                                               animations:^{
                                                                   
                                                                   UIView *strongSelf = weakSelf;
                                                                   if (strongSelf) {
                                                                       self.frame = finalFrame;
                                                                   }
                                                                   
                                                               } 
                                                               completion:NULL];
                                              
                                          }];
                         
                     }];
}

- (void)fall {
    
    //Make the view larger
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.0, 2.0);
    //Make the view transparent
    self.alpha = 0.0;
    
    __weak UIView *weakSelf = self;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionOverrideInheritedDuration)
                     animations:^ {
                         
                         UIView *strongSelf = weakSelf;
                         if (strongSelf) {
                             //Bring the view back to its original size
                             strongSelf.transform = CGAffineTransformIdentity;
                             strongSelf.alpha = 1.0;
                         }
                         
                     }
                     completion:NULL];
}

- (void)spinClockwise:(BOOL)clockwise duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CGFloat direction = (clockwise)?-1.0:1.0;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * direction];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)fadeInFromLeftWithCompletion:(void (^)(BOOL finished))completion {
    [self fadeInFromLeftWithDelay:0.0 completion:completion];
}

- (void)fadeInFromLeftWithDelay:(CGFloat)delay completion:(void (^)(BOOL finished))completion {
    CGRect finalFrame = self.frame;
    CGRect initialFrame = finalFrame;
    initialFrame.origin.x -= CGRectGetWidth(initialFrame)/2;
    self.frame = initialFrame;
    self.alpha = 0.0;
    
    [UIView animateWithDuration:0.3
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = finalFrame;
                         self.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         if (completion != NULL) {
                             completion(finished);
                         }
                     }];
}

- (void)fadeInFromRightWithCompletion:(void (^)(BOOL finished))completion {
    [self fadeInFromRightWithDelay:0.0 completion:completion];
}

- (void)fadeInFromRightWithDelay:(CGFloat)delay completion:(void (^)(BOOL finished))completion {
    CGRect finalFrame = self.frame;
    CGRect initialFrame = finalFrame;
    initialFrame.origin.x += CGRectGetWidth(initialFrame)/2;
    self.frame = initialFrame;
    self.alpha = 0.0;
    
    [UIView animateWithDuration:0.3
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = finalFrame;
                         self.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         if (completion != NULL) {
                             completion(finished);
                         }
                     }];
}

- (void)moveInFromRightWithCompletion:(void (^)(BOOL finished))completion {
    [self moveInFromRightWithDelay:0.0 completion:completion];
}

- (void)moveInFromRightWithDelay:(CGFloat)delay completion:(void (^)(BOOL finished))completion {
    CGRect finalFrame = self.frame;
    CGRect initialFrame = finalFrame;
    initialFrame.origin.x += CGRectGetWidth(initialFrame)/2;
    self.frame = initialFrame;
    
    [UIView animateWithDuration:0.3
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = finalFrame;
                     }
                     completion:^(BOOL finished){
                         if (completion != NULL) {
                             completion(finished);
                         }
                     }];
}

- (void)accelerateOutToSide:(UIViewSide)side {
    [self accelerateOutToSide:side duration:0.3 completion:NULL];
}

- (void)accelerateOutToSide:(UIViewSide)side duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion {
    //Get out of the super view but accelerating in the beginning
    CGRect bounceFrame = self.frame;
    CGRect finalFrame = self.frame;
    CGFloat bounceOffset = 10.0;
    
    switch (side) {
        case UIViewSideTop:
            bounceFrame.origin.y += bounceOffset;
            finalFrame.origin.y = -self.frame.size.height;
            break;
        case UIViewSideLeft:
            bounceFrame.origin.x += bounceOffset;
            finalFrame.origin.x = -self.frame.size.width;
            break;
        case UIViewSideBottom:
            bounceFrame.origin.y -= bounceOffset;
            finalFrame.origin.y = self.superview.frame.size.height;
            break;
        case UIViewSideRight:
            bounceFrame.origin.x -= bounceOffset;
            finalFrame.origin.x = self.superview.frame.size.width;
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = bounceFrame;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:duration-0.1
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              self.frame = finalFrame;
                                          }
                                          completion:completion];
                     }];
}

- (void)fadeInFromBottomWithDelay:(CGFloat)delay completion:(void (^)(BOOL finished))completion {
    CGRect finalFrame = self.frame;
    CGRect initialFrame = finalFrame;
    initialFrame.origin.y += CGRectGetHeight(initialFrame)/2;
    self.frame = initialFrame;
    self.alpha = 0.0;
    
    [UIView animateWithDuration:0.3
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = finalFrame;
                         self.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         if (completion != NULL) {
                             completion(finished);
                         }
                     }];
}

- (void)fadeIn {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 1.0;
                     }
                     completion:NULL];
}

- (void)fadeOut {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:NULL];
}

- (void)fadeToAlpha:(CGFloat)alpha duration:(CGFloat)duration {
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = alpha;
                     }
                     completion:NULL];
}

- (void)fadeOutToLeftWithCompletion:(void (^)(BOOL finished))completion {
    CGRect finalFrame = self.frame;
    finalFrame.origin.x -= CGRectGetWidth(finalFrame)/2;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = finalFrame;
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         if (completion != NULL) {
                             completion(finished);
                         }
                     }];
}

@end
