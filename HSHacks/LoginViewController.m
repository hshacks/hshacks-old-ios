//
//  LoginViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/7/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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


-(void)loginFacebook{
    //Login to Facebook to get name, photo
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"user_photos",
                            @"user_status",
                            nil];
    
    NSLog(@"called login facebook");
    
       [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState state,
                                                      NSError *error) {
                                      
                                      if(!error){
                                          NSLog(@"Facebook connected");
                                          [self getFacebookData];
                                      }
                                      if(error){
                                          
                                          NSLog(@"Error in fb auth request: %@", error.localizedDescription);
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops." message: @"Something went wrong with Facebook." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                          [alert show];
                                          
                                      }
                                      
                                  }];
    
}

-(void)getFacebookData{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 NSLog(@"facebook username %@", user.name);
                 
                 UserData *userData = [UserData sharedManager];
                 userData.userName = user.name;
                    NSURL *photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", user.username]];
                 NSLog(@"facebook pic: %@", photoURL);
                 userData.userPhotoURL = photoURL;
                 
                 //now store data in nsuserdefault
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 
                 userData.userName = [defaults objectForKey:@"name"];
                 userData.userPhotoURL = [defaults objectForKey:@"photoURL"];
                 
                 //should show animations and user info
                 [self doneWithLogin];
                 
             }
             if(error){
                 NSLog(@"Error in FB API request: %@", error.localizedDescription);
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops." message: @"Something went wrong with Facebook." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 
             }
         }];
        
        
    }
    
    
}



- (IBAction)loginTwitter:(id)sender {
}

- (IBAction)loginFacebook:(id)sender {
        [self loginFacebook];
}

- (IBAction)loginGuest:(id)sender {
    [self doneWithLogin];
    
}

-(void)doneWithLogin{
    //Method to push controller to updates
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
