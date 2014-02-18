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
    bodyArray = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"Announcements"];
    [query selectKeys:@[@"body"]];
   NSArray *objects = [query findObjects];
    for (int i = 0; i < objects.count;i++) {
            [bodyArray addObject:[objects[i] objectForKey:@"body"]];
          }

   
//    NSArray *objects = [[NSArray alloc]init];
//    [PFObject fetchAll:(NSArray *)objects];
//    for (int i = 0; i < objects.count;i++) {
//        [bodyArray addObject:[objects[i] objectForKey:@"body"]];
//    }

    
    NSLog(@"body array from 1%@", bodyArray);
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([self isFirstRun]){
        //check if first run, if so show login controller
        NSLog(@"is first run");
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
    
    
    for (PFObject *object in self.objects) {
      
        NSString *body = [object objectForKey:@"title"];
        if(![bodyArray containsObject:body]){
            [bodyArray addObject:body];
        }
    }
    
    NSLog(@"body array %@", bodyArray);
    
        
    return query;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get a reference to your string to base the cell size on.
    NSString *bodyString = [bodyArray objectAtIndex:indexPath.row];
    NSLog(@"bodystring : %@", bodyString);
    //set the desired size of your textbox
    CGSize constraint = CGSizeMake(298, MAXFLOAT);
    //set your text attribute dictionary
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
    //get the size of the text box
    CGRect textsize = [bodyString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    //calculate your size
    float textHeight = textsize.size.height + 10;
    NSLog(@"%f", textHeight + 79);
    return textHeight + 79;
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
   // NSLog(@"the new frame: %@", newFrame);
    NSLog(@"width = %f, height = %f", newFrame.size.width, newFrame.size.height);
    bodyText.frame = CGRectMake(10,78,newFrame.size.width, newFrame.size.height);
    
    bodyText.text = bodyString;
    
    UILabel *timeLabel = (UILabel*) [cell viewWithTag:103];
    //  NSDate *time = [NSDate date];
    NSDate *time = object.createdAt;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"MM/dd hh:mm a"];

    NSLog(@"date:  %@",time);
    timeLabel.text = [dateFormatter stringFromDate:time];
    
    
    return cell;
    }



@end
