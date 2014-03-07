//
//  CountdownViewController.m
//  HSHacks
//
//  Created by Spencer Yen (noob) on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//  Alex Yeh too pro!!!!!!!!!
//

#import "CountdownViewController.h"
#import "UIImage+animatedGIF.h"
@interface CountdownViewController ()

@end

@implementation CountdownViewController
@synthesize countdown, interval, timerImage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    timerImage.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:@"http://i.imgur.com/bA6o3mj.gif"]];
    interval.text = [NSString stringWithFormat:@""];
   
    [self setStuff];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"MM/dd/yyyy HH:mm:ss"];
    
    today = [NSDate date];
    HShacksBegin = [formatter dateFromString:@"03/08/2014 1:00:00"];
    HShacksEnd = [formatter dateFromString:@"03/09/2014 13:00:00"];

   gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                        target:self
                                        selector:@selector(countdownDisplay:)
                                        userInfo:nil
                                        repeats:YES];
    
    
}

-(void)checkDate{
    if([today compare: HShacksBegin] == NSOrderedAscending && [today compare: HShacksEnd] == NSOrderedAscending){
        interval.text = @"Hacking begins in:";
        isStarting = TRUE;
        hasEnded = FALSE;
        hasEnded = FALSE;
    }
    else if ([today compare: HShacksBegin] == NSOrderedSame || ([today compare: HShacksEnd] == NSOrderedAscending && [today compare: HShacksBegin] == NSOrderedAscending)){
        interval.text = @"Hacking ends in:";
        isStarting = FALSE;
        hasEnded = TRUE;
        hasEnded = FALSE;
    }
    else if ([today compare: HShacksBegin] == NSOrderedDescending && [today compare: HShacksEnd] == NSOrderedDescending){
        interval.text = @"Hacking has ended!";
        isStarting = FALSE;
        hasEnded = FALSE;
        hasEnded = TRUE;
    }
}

-(void)countdownDisplay:(id)sender{
    today = [NSDate date];
    [self checkDate];
    NSUInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    if(isStarting){
     
        NSDateComponents *dateComponents = [gregorianCalendar components:unitFlags fromDate:today toDate:HShacksBegin options:0];
        
        NSNumber *days = [NSNumber numberWithInteger:[dateComponents day]];
        NSNumber *hours = [NSNumber numberWithInteger:[dateComponents hour]];
        NSNumber *mins = [NSNumber numberWithInteger:[dateComponents minute]];
        NSNumber *secs = [NSNumber numberWithInteger:[dateComponents second]];
        
        NSString *s = [days stringValue];
        s = [s stringByAppendingString:@" days  "];
        s = [s stringByAppendingString:[hours stringValue]];
        s = [s stringByAppendingString:@" hours  "];
        s = [s stringByAppendingString:[mins stringValue]];
        s = [s stringByAppendingString:@" minutes  "];
        s = [s stringByAppendingString:[secs stringValue]];
        s = [s stringByAppendingString:@" seconds  "];
        
        countdown.text = s;
      
        
    }
    else if (hasStarted){
        NSDateComponents *dateComponents = [gregorianCalendar components:unitFlags fromDate:HShacksBegin toDate:HShacksEnd options:0];
        
        NSNumber *days = [NSNumber numberWithInteger:[dateComponents day]];
        NSNumber *hours = [NSNumber numberWithInteger:[dateComponents hour]];
        NSNumber *mins = [NSNumber numberWithInteger:[dateComponents minute]];
        NSNumber *secs = [NSNumber numberWithInteger:[dateComponents second]];
        
        NSString *s = [days stringValue];
        s = [s stringByAppendingString:@" days "];
        s = [s stringByAppendingString:[hours stringValue]];
        s = [s stringByAppendingString:@" hours "];
        s = [s stringByAppendingString:[mins stringValue]];
        s = [s stringByAppendingString:@" minutes "];
        s = [s stringByAppendingString:[secs stringValue]];
        s = [s stringByAppendingString:@" seconds "];
        
        countdown.text = s;
       

    }
    else if (hasEnded){
        countdown.text = @"We hope you enjoyed HSHacks!";
    }
}

-(void)setStuff{
    today = [NSDate date];
    [self checkDate];
    NSUInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    if(isStarting){
        
        NSDateComponents *dateComponents = [gregorianCalendar components:unitFlags fromDate:today toDate:HShacksBegin options:0];
        
        NSNumber *days = [NSNumber numberWithInteger:[dateComponents day]];
        NSNumber *hours = [NSNumber numberWithInteger:[dateComponents hour]];
        NSNumber *mins = [NSNumber numberWithInteger:[dateComponents minute]];
        NSNumber *secs = [NSNumber numberWithInteger:[dateComponents second]];
        
        NSString *s = [days stringValue];
        s = [s stringByAppendingString:@" days  "];
        s = [s stringByAppendingString:[hours stringValue]];
        s = [s stringByAppendingString:@" hours  "];
        s = [s stringByAppendingString:[mins stringValue]];
        s = [s stringByAppendingString:@" minutes  "];
        s = [s stringByAppendingString:[secs stringValue]];
        s = [s stringByAppendingString:@" seconds  "];
        
        countdown.text = s;
        
        
    }
    else if (hasStarted){
        NSDateComponents *dateComponents = [gregorianCalendar components:unitFlags fromDate:HShacksBegin toDate:HShacksEnd options:0];
        
        NSNumber *days = [NSNumber numberWithInteger:[dateComponents day]];
        NSNumber *hours = [NSNumber numberWithInteger:[dateComponents hour]];
        NSNumber *mins = [NSNumber numberWithInteger:[dateComponents minute]];
        NSNumber *secs = [NSNumber numberWithInteger:[dateComponents second]];
        
        NSString *s = [days stringValue];
        s = [s stringByAppendingString:@" days "];
        s = [s stringByAppendingString:[hours stringValue]];
        s = [s stringByAppendingString:@" hours "];
        s = [s stringByAppendingString:[mins stringValue]];
        s = [s stringByAppendingString:@" minutes "];
        s = [s stringByAppendingString:[secs stringValue]];
        s = [s stringByAppendingString:@" seconds "];
        
        countdown.text = s;
        
        
    }
    else if (hasEnded){
        countdown.text = @"We hope you enjoyed HSHacks! Come back next year!";
    }


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end