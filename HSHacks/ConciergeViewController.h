//
//  ConciergeViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ConciergeViewController : PFQueryTableViewController

@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, retain) NSMutableDictionary *sectionToCompanyMap;

@property (nonatomic, retain) NSMutableDictionary *companies;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

