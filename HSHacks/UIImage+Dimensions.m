//
//  UIImage+Dimensions.m
//  TutorMe
//
//  Created by Emerson Malca on 3/26/12.
//  Copyright (c) 2012 Luma Education Inc. All rights reserved.
//

#import "UIImage+Dimensions.h"

@implementation UIImage (Dimensions)

- (UIImage *)imageByResizingToMaximumSize:(CGFloat)maxSize {
    
    CGFloat wRatio = maxSize / self.size.width;
    CGFloat hRatio = maxSize / self.size.height;
    CGFloat minRatio = MIN(wRatio, hRatio);
    CGFloat newWidth = ceilf(self.size.width*minRatio);
    CGFloat newHeight = ceilf(self.size.height*minRatio);
    CGRect originalImageRect = CGRectMake(0.0, 0.0, newWidth, newHeight);
    
    UIGraphicsBeginImageContextWithOptions(originalImageRect.size, YES, 0.0);
    [self drawInRect:originalImageRect];
    // Retrieve the UIImage from the current context
    UIImage *thumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumb;
}

- (UIImage *)imageByCroppingToSquare {
    // Resize, crop the image to make sure it is square and renders
    // well on Retina display
    
    CGSize size = self.size;
    float px = (size.width < size.height)?size.width:size.height; //Get the size of the smallest size
    return [self imageByCroppingToSquareWithSide:px];
}

- (UIImage *)imageByCroppingToSquareWithSide:(CGFloat)side {
    // Resize, crop the image to make sure it is square and renders
    // well on Retina display
    float ratio;
    float delta;
    CGPoint offset;
    CGSize size = self.size;
    float px = side; //Get the size of the smallest size
    if (size.width > size.height) {
        ratio = px / size.width;
        delta = (ratio*size.width - ratio*size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = px / size.height;
        delta = (ratio*size.height - ratio*size.width);
        offset = CGPointMake(0, delta/2);
    }
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * size.width) + delta,
                                 (ratio * size.height) + delta);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(px, px), YES, 0.0);
    UIRectClip(clipRect);
    [self drawInRect:clipRect];
    UIImage *imgThumb =   UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imgThumb;
}

- (UIImage *)imageByCroppingToCircle {
    
    // Resize, crop the image to make sure it is square and renders
    // well on Retina display
    float ratio;
    float delta;
    CGPoint offset;
    CGSize size = self.size;
    float px = (size.width > size.height)?size.height:size.width; //Get the size of the smallest size
    if (size.width > size.height) {
        ratio = px / size.width;
        delta = (ratio*size.width - ratio*size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = px / size.height;
        delta = (ratio*size.height - ratio*size.width);
        offset = CGPointMake(0, delta/2);
    }
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * size.width) + delta,
                                 (ratio * size.height) + delta);
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(px, px), NO, 0.0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    //Start a path to use as a mask
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, clipRect);
    CGContextAddPath(c, path);
    CGContextClip(c); //Path is automatically closed here too
    [self drawInRect:clipRect];
    CGPathRelease(path);
    UIImage *imgThumb =   UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imgThumb;
}

- (UIImage *)imageCroppedToRect:(CGRect)rect{
    
	CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(rect.origin.x*self.scale, rect.origin.y*self.scale, rect.size.width*self.scale, rect.size.height*self.scale));
	UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
	CGImageRelease(imageRef);
	return cropped;
}

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)resizableImage {
    CGFloat leftCap = (self.size.width - 1)/2.0;
    CGFloat topCap = (self.size.height - 1)/2.0;
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(topCap, leftCap, topCap, leftCap)];
}

+ (UIImage *)flipImageLeftRight:(UIImage *)originalImage {
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:originalImage];
    
    UIGraphicsBeginImageContext(tempImageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //CGAffineTransformMake(<#CGFloat a#>, <#CGFloat b#>, <#CGFloat c#>, <#CGFloat d#>, <#CGFloat tx#>, <#CGFloat ty#>)
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0,  tempImageView.frame.size.height);
    CGContextConcatCTM(context, flipVertical);
    
    [tempImageView.layer renderInContext:context];
    
    UIImage *flipedImage = UIGraphicsGetImageFromCurrentImageContext();
    flipedImage = [UIImage imageWithCGImage:flipedImage.CGImage scale:1.0 orientation:UIImageOrientationDown];
    UIGraphicsEndImageContext();
    
    return flipedImage;
}

@end
