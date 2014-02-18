//
//  ChatViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "ChatViewController.h"
#import "LoginViewController.h"
#import "UserData.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWebImage/UIImageView+WebCache.h"

//Firebase chat server
#define kFirechatNS @"https://hshacks.firebaseio.com/"

@interface ChatViewController ()

@end

@implementation ChatViewController

@synthesize chatTableView;
@synthesize chatTextField;


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
     self.chatTextField.userInteractionEnabled = NO;
 
    
    chatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    //Remove separator
    self.chatTableView.separatorColor = [UIColor clearColor];
    
    self.chatTextField.enablesReturnKeyAutomatically = YES;
    
    UserData *userData = [UserData sharedManager];

    // Initialize array that will store chat messages.
    self.chat = [[NSMutableArray alloc] init];
    
    // Initialize the root of our Firebase namespace.
    self.firebase = [[Firebase alloc] initWithUrl:kFirechatNS];

    //Store name and photoURL in UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    userData.userName = [defaults objectForKey:@"name"];
    userData.userPhoto = [defaults objectForKey:@"photo"];

    self.name = userData.userName;
    self.photoURL = userData.userPhoto;
    
    NSLog(@"photo url%@", self.photoURL);
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        [self.chat addObject:snapshot.value];
        // Reload the table view so the new message will show up.
        
        [self.chatTableView reloadData];
        self.chatTextField.userInteractionEnabled = TRUE;
         [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chat.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text field handling

// This method is called when the user enters text in the text field.
// We add the chat message to our Firebase.
- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    
    // This will also add the message to our local array self.chat because
    // the FEventTypeChildAdded event will be immediately fired.

    [[self.firebase childByAutoId] setValue:@{@"user" : self.name, @"message": aTextField.text, @"image" : self.photoURL}];
 
    [aTextField setText:@""];
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // We only have one section in our table view.
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    // This is the number of chat messages.
    return [self.chat count];
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ChatCell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:0.02];
    else
        cell.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:0.08];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* chatMessage = [self.chat objectAtIndex:indexPath.row];
    
    UIImageView *imageView = (UIImageView*) [cell viewWithTag:100];
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    [imageView setImageWithURL:[NSURL URLWithString:chatMessage[@"image"]] placeholderImage:[UIImage imageNamed:@"placeholderIcon.png"]];
    
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = chatMessage[@"user"];

    
    UILabel *messageLabel = (UILabel*) [cell viewWithTag:102];
    messageLabel.text = chatMessage[@"message"];

    
    return cell;
}

#pragma mark - Keyboard handling

// Subscribe to keyboard show/hide notifications.
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification object:nil];
}

// Unsubscribe from keyboard show/hide notifications.
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


// Setup keyboard handlers to slide the view containing the table view and
// text field upwards when the keyboard shows, and downwards when it hides.
- (void)keyboardWillShow:(NSNotification*)notification
{
   

    
    CGRect chatTextFieldFrame = CGRectMake(chatTextField.frame.origin.x,chatTextField.frame.origin.y-170,chatTextField.frame.size.width,chatTextField.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{ chatTextField.frame = chatTextFieldFrame;}];
    
    CGRect chatTableViewFrame = CGRectMake(0,65,320,chatTableView.frame.size.height-170);
    [UIView animateWithDuration:0.0 animations:^{ chatTableView.frame = chatTableViewFrame;}];
    
    if([NSIndexPath indexPathForRow:self.chat.count-1 inSection:0]){
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chat.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
 

}

- (void)keyboardWillHide:(NSNotification*)notification
{
   
    
    CGRect chatTextFieldFrame = CGRectMake(chatTextField.frame.origin.x,chatTextField.frame.origin.y+170,chatTextField.frame.size.width,chatTextField.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{ chatTextField.frame = chatTextFieldFrame;}];
    
    CGRect chatTableViewFrame = CGRectMake(0,65,320,chatTableView.frame.size.height+170);
    [UIView animateWithDuration:0.0 animations:^{ chatTableView.frame = chatTableViewFrame;}];
  
//    [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chat.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    
}




- (IBAction)logoutPressed:(id)sender {
	
    
    UserData *userData = [UserData sharedManager];
    userData.userName = nil;
    userData.userPhoto = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:nil forKey:@"name"];
    [defaults setObject:nil forKey:@"photo"];
    
    [defaults synchronize];
    
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    
    loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:loginVC animated:YES completion:nil];


    
}
@end
