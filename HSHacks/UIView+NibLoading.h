//
//  UIView+NibLoading.h
//  XibReferencing
//
//  Created by Krzysztof Zablocki on 12/26/12.
//  Copyright (c) 2012 Pixle. All rights reserved.
//

#import <UIKit/UIKit.h>

const int kNibReferencingTag = 616;

@interface UIView (NibLoading)
+(id)loadInstanceFromNib;
- (void)setColorPattern:(NSString*)patternImageName;
+ (UIView *)loadViewFromNibWithName:(NSString *)nibName;

@end
