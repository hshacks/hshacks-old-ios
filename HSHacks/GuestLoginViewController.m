//
//  GuestLoginViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "GuestLoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UpdatesViewController.h"
#import "AVCamCaptureManager.h"
#import "AVCamRecorder.h"
#import "UIView+Utilities.h"
#import "UIView+ShowAnimations.h"
#import "UIImage+Dimensions.h"
#import <QuartzCore/QuartzCore.h>

@interface GuestLoginViewController ()  <AVCamCaptureManagerDelegate>

@property (nonatomic,retain) AVCamCaptureManager *captureManager;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@end

@implementation GuestLoginViewController
@synthesize stillImageOutput, imagePreview, captureImage;
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
    
    AVCamCaptureManager *manager = [[AVCamCaptureManager alloc] init];
    self.captureManager = manager;
    manager.delegate = self;
    
    if ([self.captureManager setupSession]) {
        
        // Create video preview layer and add it to the UI
        AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[[self captureManager] session]];
        
        CALayer *viewLayer = [imagePreview layer];
        [viewLayer setFrame:CGRectMake(60, 48, 200, 200)];
    
        
        CGRect bounds = CGRectMake(60, 48, 200, 200);
        [newCaptureVideoPreviewLayer setFrame:bounds];
        
        [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        [viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
       
        viewLayer.cornerRadius = viewLayer.frame.size.width / 2;
        
        [self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
        
        // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[[self captureManager] session] startRunning];
        });
    }

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)snapImage:(id)sender {
    // Flash the screen white and fade it out to give UI feedback that a still image was taken
    UIView *flashView = [[UIView alloc] initWithFrame:[self.view bounds]];
    [flashView setBackgroundColor:[UIColor whiteColor]];
    [[imagePreview window] addSubview:flashView];
    
    [UIView animateWithDuration:.4f
                     animations:^{
                         [flashView setAlpha:0.f];
                     }
                     completion:^(BOOL finished){
                         [flashView removeFromSuperview];
                     }];
    
    [self.captureManager captureStillImageWithCompletion:^(UIImage *image){
        if (image) {
            //Gotta flip the image cuz it comes out flipped
            image = [UIImage flipImageLeftRight:image];
            captureImage.clipsToBounds = YES;
            captureImage.layer.cornerRadius = captureImage.frame.size.width / 2;
            captureImage.image = image;
            } else {
                //error taking picture
            }
    }];

}

- (IBAction)doneTapped:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UpdatesViewController *updatesVC = (UpdatesViewController*)[storyboard instantiateViewControllerWithIdentifier:@"updatesVC"];
    [self presentViewController:updatesVC animated:YES completion:nil];

    
}






@end
