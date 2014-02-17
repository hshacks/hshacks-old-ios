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

@synthesize username;

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



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LoginViewController *profileViewController = [segue destinationViewController];
  //  [profileViewController setUsername:usernameTextfield.text];

}
-(void)loginTwitter{
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"user_photos",
                            @"user_status",
                            nil];
    
    NSLog(@"called login twitter");
    
    
    if ([TWTweetComposeViewController canSendTweet])
    {
        [self getTInfo];
    }
    else{
        //show tweeet login prompt to user to login
        TWTweetComposeViewController *viewController = [[TWTweetComposeViewController alloc] init];
        
        //hide the tweet screen
        viewController.view.hidden = YES;
        
        //fire tweetComposeView to show "No Twitter Accounts" alert view on iOS5.1
        viewController.completionHandler = ^(TWTweetComposeViewControllerResult result) {
            if (result == TWTweetComposeViewControllerResultCancelled) {
                [self dismissModalViewControllerAnimated:NO];
            }
        };
        [self presentModalViewController:viewController animated:NO];
        
        //hide the keyboard
        [viewController.view endEditing:YES];
        
        [self getTInfo];

    }

}


- (void) getTInfo
{
    
    NSString *username;

    // Request access to the Twitter accounts
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            // Check if the users has setup at least one Twitter account
            
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                
                
                // Creating a request to get the info about a user on Twitter
                
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:username forKey:@"screen_name"]];
                [twitterInfoRequest setAccount:twitterAccount];
                
                // Making the request
                
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // Check if we reached the reate limit
                        
                        if ([urlResponse statusCode] == 429) {
                            NSLog(@"Rate limit reached");
                            return;
                        }
                        
                        // Check if there was an error
                        
                        if (error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        
                        // Check if there is some response data
                        
                        if (responseData) {
                            
                            NSError *error = nil;
                            NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            
                            
                            // Filter the preferred data
                            
                            NSString *screen_name = [(NSDictionary *)TWData objectForKey:@"screen_name"];
                            NSString *name = [(NSDictionary *)TWData objectForKey:@"name"];
                            
                            int followers = [[(NSDictionary *)TWData objectForKey:@"followers_count"] integerValue];
                            int following = [[(NSDictionary *)TWData objectForKey:@"friends_count"] integerValue];
                            int tweets = [[(NSDictionary *)TWData objectForKey:@"statuses_count"] integerValue];
                            
                            NSString *profileImageStringURL = [(NSDictionary *)TWData objectForKey:@"photo"];
                            NSString *bannerImageStringURL =[(NSDictionary *)TWData objectForKey:@"profile_banner_url"];
                            
                            UserData *userData = [UserData sharedManager];
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

                            [defaults setObject:userData.userName forKey:@"name"];
                            [defaults setObject:userData.userPhoto forKey:@"photo"];
                            
                            [defaults synchronize];
                            
                            //should show animations and user info
                            [self doneWithLogin];
                            // Update the interface with the loaded data
                            
//                            nameLabel.text = name;
//                            usernameLabel.text= [NSString stringWithFormat:@"@%@",screen_name];
//                            
//                            tweetsLabel.text = [NSString stringWithFormat:@"%i", tweets];
//                            followingLabel.text= [NSString stringWithFormat:@"%i", following];
//                            followersLabel.text = [NSString stringWithFormat:@"%i", followers];
                            
//                            NSString *lastTweet = [[(NSDictionary *)TWData objectForKey:@"status"] objectForKey:@"text"];
//                            lastTweetTextView.text= lastTweet;
                            
                            
                            
                            // Get the profile image in the original resolution
                            
                            profileImageStringURL = [profileImageStringURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
                            //[self getProfileImageForURLString:profileImageStringURL];
                            
                            
                            // Get the banner image, if the user has one
                            
                           // if (bannerImageStringURL) {
                             //   NSString *bannerURLString = [NSString stringWithFormat:@"%@mobile_retina", bannerImageStringURL];
                            //    [self getBannerImageForURLString:bannerURLString];
                           // } else {
                             //   bannerImageView.backgroundColor = [UIColor underPageBackgroundColor];
                            //}
                        }
                    });
                }];
            }
        } else {
            NSLog(@"No access granted");
        }
    }];
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
                   NSString *photo = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square", user.username];
                 NSLog(@"facebook pic: %@", photo);
                 userData.userPhoto = photo;
                 
                 //now store data in nsuserdefault
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      
                 
                 [defaults setObject:userData.userName forKey:@"name"];
                 [defaults setObject:userData.userPhoto forKey:@"photo"];
                 
                 [defaults synchronize];
                 
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
    [self loginTwitter];
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
