//
//  GuideViewController.m
//  HSHacks
//
//  Created by Aakash Thumaty on 2/16/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController
@synthesize awardsContainer = _awardsContainer;
@synthesize scheduleContainer = _scheduleContainer;
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
    
    //This is to set the Custom nav bar for search tab bar with segcontrol
//    UIView *segControlView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
//    
//    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
//                                            [NSArray arrayWithObjects:
//                                             [NSString stringWithString:NSLocalizedString(@"Schedule", @"")],
//                                             [NSString stringWithString:NSLocalizedString(@"Awards", @"")],
//                                             nil]];
//    
//    
//    
//    
//    [segmentedControl addTarget:self action:@selector(changeView:)
//               forControlEvents:UIControlEventValueChanged];
//    
//    
//    UIColor *newSelectedTintColor = [UIColor colorWithRed: 0/255.0 green:0/255.0 blue:200/255.0 alpha:1.0];
//    [[[segmentedControl subviews] objectAtIndex:0] setTintColor:newSelectedTintColor];
//    [[[segmentedControl subviews] objectAtIndex:1] setTintColor:newSelectedTintColor];
//    
//    [segmentedControl setFrame:CGRectMake(85,25,150,30)];
// segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
//
//     [segmentedControl addTarget:self action:@selector(changeView:)forControlEvents:UIControlEventValueChanged];
//    [segControlView addSubview:segmentedControl];
//
//    
//    [self.view addSubview:segControlView];
//    [[self navigationItem] setTitleView:segControlView];
//	// Do any additional setup after loading the view.
//}
//
//-(void)changeView: (id)sender{
//    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
//    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
//    
//    if (selectedSegment == 0) {
//     
//        NSLog(@"hi0");
//    }
//    if (selectedSegment == 1) {
//        NSLog(@"hi1");
//
//        //Show Schedule
//        
//        
//    }
    
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 435)];
    scroll.contentSize = CGSizeMake(320, 44);
    scroll.showsHorizontalScrollIndicator = NO;
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Schedule", @"Awards",  nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(85,25,150,30);
    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    [segmentedControl addTarget:self action:@selector(changeView:)
                  forControlEvents:UIControlEventValueChanged];

    segmentedControl.selectedSegmentIndex = 1;
    
    [scroll addSubview:segmentedControl];
    
    
    [self.view addSubview:scroll];
    //[[self navigationItem] setTitleView:segmentedControl];
    
    //TO TOGGLE BETWEEN VIEWS:
    //show awards
    //awardsContainer.hidden = NO;
    //scheduleContainer.hidden = YES;
    
    //vice versa!!
    
}

-(void)changeView: (id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;

    if (selectedSegment == 0) {
        //Show schedule
        _awardsContainer.hidden = YES;
        _scheduleContainer.hidden = NO;
    }
    if (selectedSegment == 1) {
        //Show Awards
        _awardsContainer.hidden = NO;
        _scheduleContainer.hidden = YES;

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
