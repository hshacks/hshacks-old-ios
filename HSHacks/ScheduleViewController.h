//
//  ScheduleViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ScheduleViewController : PFQueryTableViewController

@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, retain) NSMutableDictionary *sectionToDayMap;

@property (nonatomic, retain) NSMutableArray *bodyArray;

@property (nonatomic, retain) NSMutableDictionary *days;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
