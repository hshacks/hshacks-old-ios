//
//  UIView+NibLoading.m
//  XibReferencing
//
//  Created by Krzysztof Zablocki on 12/26/12.
//  Copyright (c) 2012 Pixle. All rights reserved.
//

#import "UIView+NibLoading.h"

@implementation UIView (NibLoading)

+ (id)loadInstanceFromNib {
  return [self loadViewFromNibWithName:NSStringFromClass([self class])];
}

+ (UIView *)loadViewFromNibWithName:(NSString *)nibName {
    
    NSString *finalNibName = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        finalNibName = [nibName stringByAppendingString:@"~iPhone"];
        NSString *path = [[NSBundle mainBundle] pathForResource:finalNibName ofType:@"nib"];
        if (path == nil) {
            //iPhone xib doesn't exist, fall back to iPad one
            finalNibName = nibName;
        }
    } else {
        finalNibName = nibName;
    }
    
    UIView *result = nil;
    NSArray *elements = [[NSBundle mainBundle] loadNibNamed:finalNibName owner:nil options:nil];
    if ([elements count] > 0) {
        result = elements[0];
    }
    return result;
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
  if (self.tag == kNibReferencingTag) {
    //! placeholder
    UIView *realView = [[self class] loadInstanceFromNib];
    realView.frame = self.frame;
    realView.alpha = self.alpha;
    realView.backgroundColor = self.backgroundColor;
    realView.autoresizingMask = self.autoresizingMask;
    realView.autoresizesSubviews = self.autoresizesSubviews;
    
    for (UIView *view in self.subviews) {
      [realView addSubview:view];
    }
    return realView;
  }
  return [super awakeAfterUsingCoder:aDecoder];
}

- (void)setColorPattern:(NSString*)patternImageName {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:patternImageName]];
}

@end
