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
@synthesize countdownContainer = _countdownContainer;
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
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    scroll.contentSize = CGSizeMake(320, 44);
    scroll.showsHorizontalScrollIndicator = NO;
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Schedule", @"Awards",  nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(85,25,150,30);
    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    [segmentedControl addTarget:self action:@selector(changeView:)
                  forControlEvents:UIControlEventValueChanged];

    segmentedControl.selectedSegmentIndex = 0;


    [scroll addSubview:segmentedControl];
    
    
    [self.view addSubview:scroll];
    
    _awardsContainer.hidden = YES;
    _scheduleContainer.hidden = NO;
    _countdownContainer.hidden = NO;
    [self.view bringSubviewToFront:_scheduleContainer];
    [self.view bringSubviewToFront:_countdownContainer];
 
    
}

-(void)changeView: (id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;

    if (selectedSegment == 0) {
        //Show schedule
        _awardsContainer.hidden = YES;
        _scheduleContainer.hidden = NO;
        _countdownContainer.hidden = NO;
        [self.view bringSubviewToFront:_scheduleContainer];
          [self.view bringSubviewToFront:_countdownContainer];
        
    }
    if (selectedSegment == 1) {
        //Show Awards
        _awardsContainer.hidden = NO;
        _scheduleContainer.hidden = YES;
        _countdownContainer.hidden = YES;
         [self.view bringSubviewToFront:_awardsContainer];

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
