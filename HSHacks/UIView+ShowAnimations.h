//
//  UIView+ShowAnimations.h
//  TutorMe
//
//  Created by Emerson Malca on 3/18/12.
//  Copyright (c) 2012 Luma Education Inc. All rights reserved.
//

typedef enum {
    UIViewCornerNone = 0,
    UIViewCornerTopLeft = 1,
    UIViewCornerTopRight = 2,
    UIViewCornerBottomLeft = 3,
    UIViewCornerBottomRight = 4
} UIViewCorner;

typedef enum {
    UIViewSideTop = 0,
    UIViewSideLeft = 1,
    UIViewSideBottom = 2,
    UIViewSideRight = 3
} UIViewSide;

@interface UIView (ShowAnimations)

- (void)prepareForAnimatingIn;
- (void)animateIn;
- (void)animateOutWithCompletion:(void (^)(BOOL finished))completion;

- (void)accelerateOutToSide:(UIViewSide)side;
- (void)accelerateOutToSide:(UIViewSide)side duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion;
- (void)popChangeToView:(UIView *)view completion:(void (^)(BOOL finished))completion;
- (void)popFromInitialScale:(CGFloat)scale;
- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha;
- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha duration:(CGFloat)duration;
- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion;
- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha duration:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(BOOL finished))completion;
- (void)popFromInitialScale:(CGFloat)scale fadeInFromInitialAlpha:(CGFloat)alpha duration:(CGFloat)duration delay:(CGFloat)delay viewCorner:(UIViewCorner)viewCorner shouldKeepOriginalAnchorPointAndPosition:(BOOL)shouldKeepOriginals completion:(void (^)(BOOL finished))completion;
- (void)popDismissWithDuration:(CGFloat)duration completion:(void (^)(BOOL finished))completion;
- (void)popDismissWithDuration:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(BOOL finished))completion;
- (void)popDismissWithDuration:(CGFloat)duration delay:(CGFloat)delay viewCorner:(UIViewCorner)viewCorner completion:(void (^)(BOOL finished))completion;
- (void)slideToFinalFrame:(CGRect)finalFrame maxBounceOffset:(CGPoint)offset duration:(CGFloat)duration;
- (void)fall;
- (void)spinClockwise:(BOOL)clockwise duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
- (void)fadeInFromLeftWithCompletion:(void (^)(BOOL finished))completion;
- (void)fadeInFromLeftWithDelay:(CGFloat)delay completion:(void (^)(BOOL finished))completion;
- (void)fadeInFromRightWithCompletion:(void (^)(BOOL finished))completion;
- (void)fadeInFromRightWithDelay:(CGFloat)delay completion:(void (^)(BOOL finished))completion;
- (void)fadeInFromBottomWithDelay:(CGFloat)delay completion:(void (^)(BOOL finished))completion;
- (void)fadeOutToLeftWithCompletion:(void (^)(BOOL finished))completion;
- (void)moveInFromRightWithCompletion:(void (^)(BOOL finished))completion;
- (void)moveInFromRightWithDelay:(CGFloat)delay completion:(void (^)(BOOL finished))completion;
- (void)fadeIn;
- (void)fadeOut;
- (void)fadeToAlpha:(CGFloat)alpha duration:(CGFloat)duration;


@end
