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
    NSDate *HShacksBegin;
    NSDate *HShacksEnd;
    NSDateFormatter *formatter;
    NSCalendar *gregorianCalendar;
    
    BOOL isStarting;
    BOOL hasStarted;
    BOOL hasEnded;
    
    IBOutlet UILabel *interval;
    IBOutlet UILabel *countdown;
    NSDateComponents *daysComponent;
    NSDateComponents *hoursComponent;
    NSDateComponents *minsComponent;
    NSDateComponents *secsComponent;
    
}

@property (nonatomic, retain) IBOutlet UILabel *interval;
@property (nonatomic, retain) IBOutlet UILabel *countdown;
@property (weak, nonatomic) IBOutlet UIImageView *timerImage;

@end
