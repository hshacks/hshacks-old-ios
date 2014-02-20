//
//  UIViewController+EMAdditions.h
//  StudyRoom
//
//  Created by Emerson Malca on 8/4/12.
//  Copyright (c) 2012 Luma Education Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SRTransitionStyle) {
    SRTransitionStyleSlide = 0,
    SRTransitionStyleZoom,
    SRTransitionStyleFade
};

@class SREmptyView;

@interface UIViewController (EMAdditions)

+ (id)initWithNib;
- (void)prepareForAnimatingIn;
- (void)animateIn;
- (void)animateOutWithCompletion:(void (^)(BOOL finished))completion;

- (void)presentViewController:(UIViewController *)viewControllerToPresent withTransitionStyle:(SRTransitionStyle)transitionStyle completion:(void (^)(void))completion;
- (void)dismissViewControllerWithTransitionStyle:(SRTransitionStyle)transitionStyle completion: (void (^)(void))completion;

@end
