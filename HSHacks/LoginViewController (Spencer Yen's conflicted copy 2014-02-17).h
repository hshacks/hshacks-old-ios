//
//  LoginViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/7/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import "UserData.h"
#import <Twitter/Twitter.h> 

@interface LoginViewController : UIViewController{

NSString *username;
}
- (IBAction)loginTwitter:(id)sender;
- (IBAction)loginFacebook:(id)sender;
- (IBAction)loginGuest:(id)sender;

@property (nonatomic, retain) NSString *username;
@end
