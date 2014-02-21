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
@synthesize bodyArray;

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
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    NSString *connected = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://twitter.com/getibox"] encoding:NSUTF8StringEncoding error:nil];
    if (connected == NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops." message: @"I don't think you are connected to the internet." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
    
    bodyArray = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"Announcements"];
    [query selectKeys:@[@"body"]];
    NSArray *objects = [query findObjects];
    for (int i = 0; i < objects.count;i++) {
        [bodyArray insertObject:[objects[i] objectForKey:@"body"] atIndex:0];
    }
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(![self isLoggedIn]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self presentViewController:loginVC animated:NO completion:nil];
        
    }
        [self loadObjects];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


-(BOOL)isLoggedIn{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if([defaults objectForKey:@"loggedIn"]){
        return YES;
    }
    else{
        return NO;
    }
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Announcements";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"createdAt";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
    
    
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query orderByDescending:@"createdAt"];
    
    
    for (PFObject *object in self.objects) {
        
        NSString *body = [object objectForKey:@"body"];
        if(![bodyArray containsObject:body]){
            [bodyArray insertObject:body atIndex:0];
        }
    }
    
   
    
    return query;
}


- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery

    for (PFObject *object in self.objects) {
        
        NSString *body = [object objectForKey:@"body"];
        if(![bodyArray containsObject:body]){
            NSLog(@"bodobydjkadsbodybodybody  trol %@", body);
            [bodyArray insertObject:body atIndex:0];
        }
    }
    NSLog(@"body array  before releading %@", bodyArray);
    [self.tableView reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get a reference to your string to base the cell size on.
    NSString *bodyString;
   
    if(indexPath.row == bodyArray.count){
     
        for (PFObject *object in self.objects) {
           NSString *body = [object objectForKey:@"body"];
            if(![bodyArray containsObject:body]){
                [bodyArray insertObject:body atIndex:0];
            }
        }
    }
    
    bodyString = [bodyArray objectAtIndex:indexPath.row];
    
    //set the desired size of your textbox
    CGSize constraint = CGSizeMake(298, MAXFLOAT);

    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
    CGRect textsize = [bodyString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    //calculate your size
    float textHeight = textsize.size.height + 10;
   
    return textHeight + 78;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
    static NSString *simpleTableIdentifier = @"UpdateCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    UILabel *titleLabel = (UILabel*) [cell viewWithTag:101];
    titleLabel.text = [object objectForKey:@"title"];
    
    //Set bodytext, adjust size of label
    UILabel *bodyText = (UILabel*) [cell viewWithTag:104];
    
    NSString *bodyString =[object objectForKey:@"body"];
    
    CGSize constraint = CGSizeMake(298, MAXFLOAT);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
    CGRect newFrame = [bodyString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    bodyText.frame = CGRectMake(10,79,newFrame.size.width, newFrame.size.height);
    bodyText.text = bodyString;
    [bodyText sizeToFit];
    
    //Set date label
    UILabel *timeLabel = (UILabel*) [cell viewWithTag:103];
    NSDate *time = object.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd hh:mm a"];
    timeLabel.text = [dateFormatter stringFromDate:time];
    
    
    return cell;
}



@end