//
//  CountdownViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownViewController : UIViewController {
    
    NSDate *today;
    NSDate *HShacksDate;
    NSDateFormatter *formatter;
    
    BOOL isStarting;
    BOOL hasStarted;
    BOOL hasEnded;
    
    IBOutlet UILabel *interval;
    IBOutlet UILabel *countdown;
    
    
}

@property (nonatomic, retain) IBOutlet UILabel *interval;
@property (nonatomic, retain) IBOutlet UILabel *countdown;

@end
