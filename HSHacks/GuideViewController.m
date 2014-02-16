//
//  GuideViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/6/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

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
    UIView *segControlView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             [NSString stringWithString:NSLocalizedString(@"Schedule", @"")],
                                             [NSString stringWithString:NSLocalizedString(@"Awards", @"")],
                                             nil]];
    
    
    [segmentedControl setSelectedSegmentIndex:0];
    
    
    [segmentedControl addTarget:self action:@selector(changeView:)
               forControlEvents:UIControlEventValueChanged];
    
    
    UIColor *newSelectedTintColor = [UIColor colorWithRed: 0/255.0 green:0/255.0 blue:200/255.0 alpha:1.0];
    [[[segmentedControl subviews] objectAtIndex:0] setTintColor:newSelectedTintColor];
    [[[segmentedControl subviews] objectAtIndex:1] setTintColor:newSelectedTintColor];
    
    [segmentedControl setFrame:CGRectMake(85,25,150,30)];
 segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;

    
    [segControlView addSubview:segmentedControl];

    
    [self.view addSubview:segControlView];
    [[self navigationItem] setTitleView:segControlView];
	// Do any additional setup after loading the view.
}

-(void)changeView: (id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
     
        //Show Awards
        
    }
    if (selectedSegment == 1) {
       
        //Show Schedule
        
        
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
