//
//  UpdatesNavViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/19/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "UpdatesNavViewController.h"

@interface UpdatesNavViewController ()

@end

@implementation UpdatesNavViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)share:(id)sender {
    NSArray *activityItems = @[@"@highschoolhacks is #stacked."];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    
    [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed)
     {
         NSLog(@"Activity = %@",activityType);
         NSLog(@"Completed Status = %d",completed);
         
         if (completed)
         {
             UIAlertView *objalert = [[UIAlertView alloc]initWithTitle:@"Horray!" message:@"Successfully Shared! Enjoy HSHacks!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [objalert show];
             objalert = nil;
         } else
         {
             UIAlertView *objalert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Unable To Share. Try again?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [objalert show];
             objalert = nil;
         }
     }];
}
@end
