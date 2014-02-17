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

@interface LoginViewController : UIViewController
- (IBAction)loginTwitter:(id)sender;
- (IBAction)loginFacebook:(id)sender;
- (IBAction)loginGuest:(id)sender;

{

IBOutlet UIImageView *profileImageView;
IBOutlet UIImageView *bannerImageView;

IBOutlet UILabel *nameLabel;
IBOutlet UILabel *usernameLabel;

IBOutlet UILabel *tweetsLabel;
IBOutlet UILabel *followingLabel;
IBOutlet UILabel *followersLabel;

IBOutlet UITextView *lastTweetTextView;

NSString *username;
}

@property (nonatomic, retain) NSString *username;
@end
