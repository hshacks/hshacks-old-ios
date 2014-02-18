//
//  ConciergeViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "ConciergeViewController.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
@interface ConciergeViewController ()

@end

@implementation ConciergeViewController
@synthesize sections = _sections;
@synthesize sectionToCompanyMap = _sectionToCompanyMap;
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"mentors"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(int i = 0; i < objects.count; i++){
                [objects[i] objectForKey:@"name"];
            
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
	// Do any additional setup after loading the view.
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:{
            NSLog(@"Mail sent");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Horray!" message: @"Your email was sent!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        case MFMailComposeResultFailed:{
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Hm..." message: @"Something went wrong. Try sending the email again." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Hm..." message: @"Something wnet wrong. Try sending the text again." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        }
            
        case MessageComposeResultSent:{
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Horray!" message: @"Your text was sent!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        //Parse class name
        self.parseClassName = @"Mentors";
        
        //Default display
        self.textKey = @"name";
        
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled = NO;
        self.objectsPerPage = 150;
        self.sections = [NSMutableDictionary dictionary];
        self.sectionToCompanyMap = [NSMutableDictionary dictionary];

    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    // Order by company
    [query orderByAscending:@"companyID"];
    
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;

    return query;
    
}

- (NSString *)companyForSection:(NSInteger)section {
    return [self.sectionToCompanyMap objectForKey:[NSNumber numberWithInt:section]];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    
    [self.sections removeAllObjects];
    [self.sectionToCompanyMap removeAllObjects];
    
    NSInteger section = 0;
    NSInteger rowIndex = 0;
    for (PFObject *object in self.objects) {
        NSString *company = [object objectForKey:@"company"];
        NSLog(@"company: %@", company);
        NSMutableArray *objectsInSection = [self.sections objectForKey:company];
        if (!objectsInSection) {
            objectsInSection = [NSMutableArray array];
            
            // this is the first time we see this company - increment the section index
            [self.sectionToCompanyMap setObject:company forKey:[NSNumber numberWithInt:section++]];
        }
        
        [objectsInSection addObject:[NSNumber numberWithInt:rowIndex++]];
        [self.sections setObject:objectsInSection forKey:company];
    }
    [self.tableView reloadData];
}


- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSString *company = [self companyForSection:indexPath.section];
    
    NSArray *rowIndecesInSection = [self.sections objectForKey:company];
    NSNumber *rowIndex = [rowIndecesInSection objectAtIndex:indexPath.row];
    return [self.objects objectAtIndex:[rowIndex intValue]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *company = [self companyForSection:section];
    NSArray *rowIndecesInSection = [self.sections objectForKey:company];
    return rowIndecesInSection.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *company = [self companyForSection:section];
    return company;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    //Make custom header
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, tableView.frame.size.width, 18)];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextColor:[UIColor colorWithRed:123/255.0 green:123/255.0 blue:127/255.0 alpha:1.0]];
    NSString *company = [[self companyForSection:section] uppercaseString];


    
    [label setText:company];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:232/255.0 green:232/255.0 blue:239/255.0 alpha:0.9]];
    
    //add header separator
    CGRect sepFrame = CGRectMake(0, view.frame.size.height-1, 320, 1);
    UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
    seperatorView.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
    [view addSubview:seperatorView];
    
    return view;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    PFObject *selectedObject = [self objectAtIndexPath:indexPath];
    if([[selectedObject objectForKey:@"contactType"]isEqualToString: @"email"]){
        
        // Email Subject
        NSString *emailTitle = @"Test Email";
        // Email Content
        NSString *messageBody = [NSString stringWithFormat:@"Hey %@,", [selectedObject objectForKey:@"name"]];
        NSArray *sendArray = [NSArray arrayWithObject:[selectedObject objectForKey:@"contactInfo"]];
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setSubject:@"HSHacks Help"];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:sendArray];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];

    
    }
    
    if([[selectedObject objectForKey:@"contactType"]isEqualToString: @"twitter"]){
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            NSString *message = [NSString stringWithFormat:@"Hey %@ ", [selectedObject objectForKey:@"contactInfo"]];
            [tweetSheet setInitialText:message];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
    }
    
    if([[selectedObject objectForKey:@"contactType"]isEqualToString: @"phone"]){
        
        NSArray *sendArray = [NSArray arrayWithObject:[selectedObject objectForKey:@"contactInfo"]];

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
            
        [messageController setRecipients:sendArray];
        [messageController setBody:[NSString stringWithFormat:@"Hey %@, ", [selectedObject objectForKey:@"name"]]];
        [self presentViewController:messageController animated:YES completion:nil];
                       });
    }
    

     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"ConciergeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell

    //If no skills, then move name downto center of cell
    
    if([[object objectForKey:@"skills"]isEqualToString:@""]){
        UILabel *nameLabel = (UILabel*) [cell viewWithTag:100];
        nameLabel.frame =  CGRectMake(16, 11, 232, 21);
        //Doesn't work right now :(
        nameLabel.text = [object objectForKey:@"name"];
    }
    else{
        UILabel *nameLabel = (UILabel*) [cell viewWithTag:100];
        nameLabel.text = [object objectForKey:@"name"];
    }
        UILabel *skillsLabel = (UILabel*) [cell viewWithTag:101];
        skillsLabel.text = [object objectForKey:@"skills"];
    
    //Set the photo
    if([[object objectForKey:@"contactType"]isEqualToString: @"email"]){
        UIImageView *comImage = (UIImageView*) [cell viewWithTag:102];
         comImage.image = [UIImage imageNamed:@"email.png"];
    }
    
    if([[object objectForKey:@"contactType"]isEqualToString: @"twitter"]){
        UIImageView *comImage = (UIImageView*) [cell viewWithTag:102];
         comImage.image = [UIImage imageNamed:@"twitter.png"];
    }
    
    if([[object objectForKey:@"contactType"]isEqualToString: @"phone"]){
        UIImageView *comImage = (UIImageView*) [cell viewWithTag:102];
         comImage.image = [UIImage imageNamed:@"phone.png"];
    }

    
    
    return cell;
}




@end
