//
//  UIViewController+EMAdditions.m
//  StudyRoom
//
//  Created by Emerson Malca on 8/4/12.
//  Copyright (c) 2012 Luma Education Inc. All rights reserved.
//

#import "UIViewController+EMAdditions.h"
#import "UIView+Utilities.h"
#import "UIView+ShowAnimations.h"

@implementation UIViewController (EMAdditions)

+ (id)initWithNib {
    NSString *nibName = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
         nibName = [NSStringFromClass(self) stringByAppendingString:@"~iPhone"];
        NSString *path = [[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"];
        if (path == nil) {
            //iPhone xib doesn't exist, fall back to iPad one
            nibName = NSStringFromClass(self);
        }
    } else {
        nibName = NSStringFromClass(self);
    }
    return [[self alloc] initWithNibName:nibName bundle:nil];
}

- (void)prepareForAnimatingIn {
}

- (void)animateIn {
}

- (void)animateOutWithCompletion:(void (^)(BOOL finished))completion {
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent withTransitionStyle:(SRTransitionStyle)transitionStyle completion:(void (^)(void))completion {
    
    if (transitionStyle == SRTransitionStyleSlide) {
        
        //Presentation is sliding up
        CGRect originalFrame = self.view.frame;
        CGRect finalFrame = CGRectOffset(originalFrame, 0.0, -CGRectGetHeight(originalFrame));
        
        CGRect presentedStartingFrame = CGRectOffset(originalFrame, 0.0, CGRectGetHeight(originalFrame));
        viewControllerToPresent.view.frame = presentedStartingFrame;
        [self.view addSubview:viewControllerToPresent.view];
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.view.frame = finalFrame;
                         }
                         completion:^(BOOL finished){
                             [self presentViewController:viewControllerToPresent animated:NO completion:completion];
                         }];
    
    } else if (transitionStyle == SRTransitionStyleZoom) {
        
        //Put the view to present in the hierarchy
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        UIView *viewToPresent = viewControllerToPresent.view;
        viewToPresent.frame = rootViewController.view.bounds;
        [rootViewController.view addSubview:viewControllerToPresent.view];

        viewToPresent.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        viewToPresent.alpha = 0.0;

        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction)
                         animations:^ {
                             //Grow the view to original size
                            viewToPresent.transform = CGAffineTransformIdentity;
                            viewToPresent.alpha = 1.0;
                             
                         }
                         completion:^(BOOL finished) {
                             [viewControllerToPresent.view removeFromSuperview];
                             [self presentViewController:viewControllerToPresent animated:NO completion:completion];
                         }];
        
    }
}

- (void)dismissViewControllerWithTransitionStyle:(SRTransitionStyle)transitionStyle completion: (void (^)(void))completion {
    
    //Find whether we need to dimiss this view controller or a presented view controller of this view controller
    UIViewController *viewControllerToDismiss = nil;
    if ([self presentedViewController] != nil) {
        viewControllerToDismiss = [self presentedViewController];
    } else {
        viewControllerToDismiss = self;
    }
    
    //Once we found the right view controller to dismiss, we want to traverse all the way up in its vc hierachy
    while (viewControllerToDismiss.parentViewController != nil) {
        viewControllerToDismiss = viewControllerToDismiss.parentViewController;
    }
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UIViewController *viewController = viewControllerToDismiss.presentingViewController;
    UIView *dismissedView = viewControllerToDismiss.view;
    
    //Sanity check
    if (viewController != nil) {
        
        if (transitionStyle == SRTransitionStyleSlide) {

            //Since we don't really know what the view hierarchy looks like at the moment, it is safer to do the transition
            //with a screenshot (we still don't care about the view to be dismissed)
            [self dismissViewControllerAnimated:NO completion:NULL];
            UIImage *screenshot = [viewController.view screenshot];
            
            //Add the screenshot
            UIImageView *imageView = [[UIImageView alloc] initWithImage:screenshot];
            imageView.frame = CGRectOffset(viewController.view.bounds, 0.0, -CGRectGetHeight(viewController.view.bounds));
            [viewController.view addSubview:imageView];
            
            //Add the dismissed view
            dismissedView.frame = viewController.view.bounds;
            [viewController.view addSubview:dismissedView];
            
            //Calculate final frames
            CGRect finalFrame = viewController.view.bounds;
            CGRect dismissedFinalFrame = CGRectOffset(viewController.view.bounds, 0.0, CGRectGetHeight(viewController.view.bounds));
            
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 imageView.frame = finalFrame;
                                 dismissedView.frame = dismissedFinalFrame;
                             }
                             completion:^(BOOL finished){
                                 [imageView removeFromSuperview];
                                 [dismissedView removeFromSuperview];
                                 
                                 if (completion != NULL) {
                                     completion();
                                 }
                             }];
            
        } else if (transitionStyle == SRTransitionStyleZoom) {
            
            [self dismissViewControllerAnimated:NO completion:NULL];
            
            //Add the dismissed view
            dismissedView.frame = rootViewController.view.bounds;
            //Just in case that view controller had a parent view controller
            if (viewControllerToDismiss.parentViewController != nil) {
                [viewControllerToDismiss willMoveToParentViewController:nil];
                [viewControllerToDismiss removeFromParentViewController];
            }
            [rootViewController.view addSubview:dismissedView];
            
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options:(UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction)
                             animations:^ {
                                 //Grow the view to original size
                                 dismissedView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);;
                                 dismissedView.alpha = 0.0;
                                 
                             }
                             completion:^(BOOL finished) {
                                 [dismissedView removeFromSuperview];
                                 
                                 if (completion != NULL) {
                                     completion();
                                 }
                                 
                             }];
            
        }
    }
}

@end
