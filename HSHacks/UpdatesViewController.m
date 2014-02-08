//
//  UpdatesViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "UpdatesViewController.h"
#import "LoginViewController.h"

@interface UpdatesViewController ()

@end

@implementation UpdatesViewController

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
    
     }

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([self isFirstRun]){
        //check if first run, if so show login controller
        NSLog(@"isfirst run");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self presentViewController:loginVC animated:YES completion:nil];

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
}

- (BOOL)isFirstRun
{
 //Check if it is the first run
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"isFirstRun"])
    {
        return NO;
    }
    
    [defaults setObject:@"ALREADY_FIRST_RUN" forKey:@"isFirstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}



@end
