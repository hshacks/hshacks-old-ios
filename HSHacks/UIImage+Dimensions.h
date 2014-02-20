//
//  UIImage+Dimensions.h
//  TutorMe
//
//  Created by Emerson Malca on 3/26/12.
//  Copyright (c) 2012 Luma Education Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Dimensions)

- (UIImage *)imageByResizingToMaximumSize:(CGFloat)maxSize;
- (UIImage *)imageByCroppingToCircle;
- (UIImage *)imageByCroppingToSquare;
- (UIImage *)imageByCroppingToSquareWithSide:(CGFloat)side;
- (UIImage *)imageCroppedToRect:(CGRect)rect;
- (UIImage *)fixOrientation;
- (UIImage *)resizableImage;
+ (UIImage *)flipImageLeftRight:(UIImage *)originalImage;

@end
