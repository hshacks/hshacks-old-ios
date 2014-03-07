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
#import "SVProgressHUD/SVProgressHUD.h"
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
    
    NSString *connected = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://twitter.com/getibox"] encoding:NSUTF8StringEncoding error:nil];
    if (connected != NULL) {
    
          [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
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
    
      
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        [self.chat addObject:snapshot.value];
        // Reload the table view so the new message will show up.
         [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
    
        [self.chatTableView reloadData];
           
        self.chatTextField.userInteractionEnabled = TRUE;
         [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chat.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
              });
    }];

}
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
    if(self.chat.count > 0){
        if(self.name && self.photoURL){
    [[self.firebase childByAutoId] setValue:@{@"user" : self.name, @"message": aTextField.text, @"image" : self.photoURL}];
        }
        if([aTextField.text isEqualToString:@"hellyeah"]){
            NSLog(@"hellllyeahhhh");
            
            UILabel *hellYeahLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 300, 50)];
            hellYeahLabel.center = self.view.center;
            hellYeahLabel.text = @"#HELLYEAHHH";
            hellYeahLabel.font = [UIFont boldSystemFontOfSize:40.0];
            
            hellYeahLabel.textColor = [UIColor blueColor];
            hellYeahLabel.textAlignment = UITextAlignmentCenter;
            hellYeahLabel.alpha = 0;
            [self.view addSubview:hellYeahLabel];
            
                 hellYeahLabel.transform = CGAffineTransformMakeScale(0.01, 0.01);
            hellYeahLabel.alpha = 1;
                                     [UIView animateWithDuration:0.7 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                                             hellYeahLabel.transform = CGAffineTransformIdentity;
                                         } completion:^(BOOL finished){
                                             [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                                 
                                                 hellYeahLabel.transform = CGAffineTransformMakeScale(0.0, 0.0);
                                             } completion:^(BOOL finished){
                                                 hellYeahLabel.alpha = 0;
                                                 
                                             }];
                                         
                                         }];
                                 }
        
    [aTextField setText:@""];
    }
    
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    // This is the number of chat messages.
    return [self.chat count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get a reference to your string to base the cell size on.
    NSString *bodyString;
    
    bodyString = [self.chat objectAtIndex:indexPath.row][@"message"];
    
    //set the desired size of your textbox
    CGSize constraint = CGSizeMake(252, MAXFLOAT);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14.0] forKey:NSFontAttributeName];
    CGRect textsize = [bodyString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    //calculate your size
    float textHeight = textsize.size.height + 5;
    
    return textHeight + 25;
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
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
  
   
    
    [imageView setImageWithURL:[NSURL URLWithString:chatMessage[@"image"]] placeholderImage:[UIImage imageNamed:@"placeholderIcon.png"]];
  
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = chatMessage[@"user"];

    
    UILabel *messageLabel = (UILabel*) [cell viewWithTag:102];
    
    NSString *message = chatMessage[@"message"];
    
    CGSize constraint = CGSizeMake(252, MAXFLOAT);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14.0] forKey:NSFontAttributeName];
    CGRect newFrame = [message boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    messageLabel.frame = CGRectMake(57,22,newFrame.size.width, newFrame.size.height);
    messageLabel.text = message;
    [messageLabel sizeToFit];
    
    return cell;
}

#pragma mark - Keyboard handling

// Subscribe to keyboard show/hide notifications.
- (void)viewWillAppear:(BOOL)animated
{
    
    NSString *connected = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://twitter.com/getibox"] encoding:NSUTF8StringEncoding error:nil];
    if (connected == NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops." message: @"I don't think you are connected to the internet." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        self.chatTextField.userInteractionEnabled = NO;
    }
    else{
        self.chatTextField.userInteractionEnabled = YES;
    }
    
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
