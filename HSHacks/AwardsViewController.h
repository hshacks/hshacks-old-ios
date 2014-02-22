//
//  AwardsViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AwardsViewController : PFQueryTableViewController{


}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) CGSize trueContentSize;
@property (nonatomic, retain) NSMutableArray *detailsArray;

@end
