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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([self isFirstRun]){
        //check if first run, if so show login controller
        NSLog(@"isfirst run");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self presentViewController:loginVC animated:NO completion:nil];

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
}

- (BOOL)isFirstRun
{
 //Check if it is the first run
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"isFirstRun"])
    {
        return NO;
    }
    
    [defaults setObject:@"ALREADY_FIRST_RUN" forKey:@"isFirstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Announcements";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"createdAt";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        
        
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115.0;
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
        NSLog(@"title: %@", [object objectForKey:@"title"]);
        
    
    UITextView *bodyLabel = (UITextView*) [cell viewWithTag:102];
   // bodyLabel.automaticallyAdjustsScrollViewInsets = NO;
    bodyLabel.text = [object objectForKey:@"body"];
    
    UILabel *timeLabel = (UILabel*) [cell viewWithTag:103];
    NSString *time = [object objectForKey:@"createdAt"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/DD HH:mm a"];
    NSLog(@"date:  %@",time);
 //   timeLabel.text = [dateFormatter stringFromDate:time];
    
    
    return cell;
    }



@end
