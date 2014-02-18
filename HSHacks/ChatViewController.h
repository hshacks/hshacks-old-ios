//
//  ChatViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
@interface ChatViewController : UIViewController


@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* photoURL;
@property (nonatomic, strong) NSMutableArray* chat;
@property (nonatomic, strong) Firebase* firebase;

- (IBAction)logoutPressed:(id)sender;



@property (strong, nonatomic) IBOutlet UITableView *chatTableView;
@property (strong, nonatomic) IBOutlet UITextField *chatTextField;

@end
