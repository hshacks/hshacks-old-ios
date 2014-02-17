//
//  CountdownViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownViewController : UIViewController {
    int days;
    int min;
    int sec;
    
    BOOL isStarting;
    BOOL hasStarted;
    BOOL hasEnded;
    
    
}

@end
