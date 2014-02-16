//
//  ConciergeViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "ConciergeViewController.h"

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

-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.parseClassName = @"Mentors";
        self.textKey = @"name";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 150;
        self.sections = [NSMutableDictionary dictionary];
        self.sectionToCompanyMap = [NSMutableDictionary dictionary];
    }
    return self;
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
        
        self.pullToRefreshEnabled = YES;
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
    [query orderByAscending:@"company"];
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    

    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1000)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *company = [self companyForSection:section];
    /* Section header is in 0th index... */
    [label setText:company];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:0.5]]; //your background color...
    return view;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    PFObject *selectedObject = [self objectAtIndexPath:indexPath];
    if([[selectedObject objectForKey:@"contactType"]isEqualToString: @"email"]){
    //show email stuff
    
    }
    
    if([[selectedObject objectForKey:@"contactType"]isEqualToString: @"twitter"]){
        //show tweet @
    }
    
    if([[selectedObject objectForKey:@"contactType"]isEqualToString: @"phone"]){
        //show text message
    
    }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"ConciergeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell


    
        UILabel *nameLabel = (UILabel*) [cell viewWithTag:100];
        nameLabel.text = [object objectForKey:@"name"];
    
    NSLog(@"name %@", [object objectForKey:@"name"]);
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



//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2 ;
//}
//
//
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"mhacks";
//}
//- (CGFloat)tableView:(UITableView *)aTableView heightForHeaderInSection:(NSInteger)section{
//    return 20;
//
//}
// - (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
// 
//     return 0;
//     
// }
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 3;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *simpleTableIdentifier = @"ConciergeCell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
//    
////    Recipe *recipe = [recipes objectAtIndex:indexPath.row];
////    
//
////    UILabel *nameLabel = (UILabel*) [cell viewWithTag:100];
////    nameLabel.text = recipe.name;
////    UILabel *skillsLabel = (UILabel*) [cell viewWithTag:101];
////    skillsLabel.text = recipe.prepTime;
////    UIImageView *comImage = (UIImageView*) [cell viewWithTag:102];
////    comImage.image = [UIImage imageNamed:recipe.imageFile];
//    
//    return cell;
//}



@end
