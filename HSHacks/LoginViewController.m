//
//  LoginViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/7/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "LoginViewController.h"
#import "UpdatesViewController.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import <float.h>

@interface LoginViewController ()



@end

@implementation LoginViewController

@synthesize username, logo, statusLabel, twitterButton, facebookButton, guestButton;

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect logoF2;
    CGRect tbuttonF;
    CGRect fButtonF;
    CGRect gButtonF;
    
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
        if(screenSize.height >480.0f){
            logoF2 = CGRectMake(logo.frame.origin.x+30,logo.frame.origin.y-90+30,logo.frame.size.width-60,logo.frame.size.height-60);
            tbuttonF = CGRectMake(twitterButton.frame.origin.x,logo.frame.origin.y+160,twitterButton.frame.size.width,twitterButton.frame.size.height);
            fButtonF = CGRectMake(facebookButton.frame.origin.x,logo.frame.origin.y+240,facebookButton.frame.size.width,facebookButton.frame.size.height);
            gButtonF = CGRectMake(guestButton.frame.origin.x,logo.frame.origin.y+320,guestButton.frame.size.width,guestButton.frame.size.height);
        }
        else{
            logoF2 = CGRectMake(logo.frame.origin.x+30,logo.frame.origin.y-110+30,logo.frame.size.width-60,logo.frame.size.height-60);
            tbuttonF = CGRectMake(twitterButton.frame.origin.x,logo.frame.origin.y+115,twitterButton.frame.size.width,twitterButton.frame.size.height);
            fButtonF = CGRectMake(facebookButton.frame.origin.x,logo.frame.origin.y+195,facebookButton.frame.size.width,facebookButton.frame.size.height);
            gButtonF = CGRectMake(guestButton.frame.origin.x,logo.frame.origin.y+275,guestButton.frame.size.width,guestButton.frame.size.height);
        
        }
        
        
    }
  
    
    logo.alpha = 0.0;
    statusLabel.alpha = 0.0;
    
    [UIView animateWithDuration: 1.0f
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         statusLabel.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration: 0.5f
                                               delay: 0.4f
                                             options: UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              statusLabel.alpha = 0.0;
                                          }
                                          completion:^(BOOL finished){
                                              
                                            
                                              [UIView animateWithDuration: 0.5f
                                                                    delay: 0.0f
                                                                  options: UIViewAnimationOptionCurveEaseIn
                                                               animations:^{
                                                                   logo.alpha = 1.0;
                                                               }
                                                               completion:^(BOOL finished){
                                                                   [UIView animateWithDuration:1 animations:^{
                                                                       logo.frame = logoF2;
                                                                       guestButton.frame = gButtonF;
                                                                       facebookButton.frame = fButtonF;
                                                                       twitterButton.frame = tbuttonF;
                                                                   }];
                                                                   
                                                               }];

                                          }];
                         
                    }];
    
}

-(void)loginTwitter{

    
    if ([TWTweetComposeViewController canSendTweet])
    {
        //[SVProgressHUD showWithStatus:@"Logging into Twitter..." maskType:SVProgressHUDMaskTypeGradient];
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
        
        

    }

}
- (void) getTInfo
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        
        NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];

        ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
        
        
        NSDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:
                                  [twitterAccount dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"properties"]]];
        NSString *tempUserID = [[tempDict objectForKey:@"properties"] objectForKey:@"user_id"];

        NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:tempUserID forKey:@"user_id"];
        [params setObject:@"0" forKey:@"include_rts"]; // don't include retweets
        [params setObject:@"1" forKey:@"trim_user"]; // trim the user information
        [params setObject:@"1" forKey:@"count"]; // i don't even know what this does but it does something useful
        
        TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodGET];
       
        //  Attach an account to the request
        [request setAccount:twitterAccount]; // this can be any Twitter account obtained from the Account store
        
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if (responseData) {
                NSDictionary *twitterData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:NULL];
                
                // to do something useful with this data:
                NSString *name = [twitterData objectForKey:@"name"];
           
              
                NSString *profileImageUrl = [twitterData objectForKey:@"profile_image_url"];
                
                NSLog(@"got twitter image: %@", profileImageUrl);
                UserData *userData = [UserData sharedManager];
                userData.userName = name;
                userData.userPhoto = profileImageUrl;
 
                NSLog(@"setting singleton");
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setObject:userData.userName forKey:@"name"];
                [defaults setObject:userData.userPhoto forKey:@"photo"];
                
                [defaults synchronize];
                
                NSLog(@"setting defaults");
                  [SVProgressHUD dismiss];
                NSLog(@"dismiss progreeHUd");
                 [self doneWithLogin];

               
            }else{
                  [SVProgressHUD dismiss];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops." message: @"Something bad happened when trying to login to Twitter. Try again?" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
        
            
            
    }
     ];
    
  
   
}



-(void)loginFacebook{
    //Login to Facebook to get name, photo
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"user_photos",
                            @"user_status",
                            nil];
    
    
       [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState state,
                                                      NSError *error) {

                                      
                                      if(!error){
                                    
                                          [self getFacebookData];
                                      }
                                      if(error){
                                        
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
               
                 
                 UserData *userData = [UserData sharedManager];
                 userData.userName = user.name;
                   NSString *photo = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square", user.username];
                
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
    
    
}

-(void)doneWithLogin{
    
    UserData *userData = [UserData sharedManager];
   
       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    

    [defaults setObject:@"YES" forKey:@"loggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];


    dispatch_async(dispatch_get_main_queue(), ^{
        //make sure on main thread
    [UIView animateWithDuration: 1.0f
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         logo.alpha = 0.0;
                         facebookButton.alpha = 0.0;
                         twitterButton.alpha = 0.0;
                         guestButton.alpha = 0.0;
                         
                       
                     }
                     completion:^(BOOL finished){
                         statusLabel.numberOfLines = 2;
                         statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
                         statusLabel.text = [NSString stringWithFormat:@"Have a good time, %@", userData.userName];
                         [UIView animateWithDuration: 0.7f
                                                delay: 0.0f
                                              options: UIViewAnimationOptionCurveEaseIn
                                           animations:^{
                                    
                                               statusLabel.alpha = 1.0;
                                           }
                                           completion:^(BOOL finished){
                                               [self performSelector:@selector(dismissView:) withObject:self afterDelay:1];
                                             
                                           }
                                    ];
                     }];
    });
}




-(void)dismissView:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UpdatesViewController *updatesVC = (UpdatesViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
    updatesVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:updatesVC animated:YES completion:nil];
}

@end
