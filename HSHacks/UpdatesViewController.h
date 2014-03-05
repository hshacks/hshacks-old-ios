//
//  UpdatesViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface UpdatesViewController : PFQueryTableViewController


@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
