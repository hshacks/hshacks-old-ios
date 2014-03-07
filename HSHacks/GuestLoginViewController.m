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
#import "UserData.h"
#import <ImageIO/CGImageProperties.h>
#import "MLIMGURUploader.h"
#import "SVProgressHUD/SVProgressHUD.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@interface GuestLoginViewController ()  <AVCamCaptureManagerDelegate>

@property (nonatomic,retain) AVCamCaptureManager *captureManager;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;


@end

@implementation GuestLoginViewController
@synthesize stillImageOutput, imagePreview, captureImage, nameField, imageData, imgBtn, doneOutlet, statusLabel;
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
    
    self.doneOutlet.userInteractionEnabled = YES;
     self.doneOutlet.hidden = YES;
    self.doneOutlet.alpha = 0;
    self.nameField.delegate = self;
    AVCamCaptureManager *manager = [[AVCamCaptureManager alloc] init];
    self.captureManager = manager;
    manager.delegate = self;
    
    if ([self.captureManager setupSession]) {
        
        // Create video preview layer and add it to the UI
        AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[[self captureManager] session]];
        
        [newCaptureVideoPreviewLayer setFrame:imagePreview.frame];
        
        [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        
        newCaptureVideoPreviewLayer.cornerRadius = newCaptureVideoPreviewLayer.frame.size.width / 2;
        [self.view.layer addSublayer:newCaptureVideoPreviewLayer];
        
        [self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
        
        // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[self captureManager] session] startRunning];
            
        });
    }
   
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{

//    self.doneOutlet.userInteractionEnabled = YES;
//    self.nameField.delegate = self;
//    AVCamCaptureManager *manager = [[AVCamCaptureManager alloc] init];
//    self.captureManager = manager;
//    manager.delegate = self;
//    
//    if ([self.captureManager setupSession]) {
//        
//        // Create video preview layer and add it to the UI
//        AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[[self captureManager] session]];
//        
//        [newCaptureVideoPreviewLayer setFrame:imagePreview.frame];
//        
//        [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//        
//        
//        newCaptureVideoPreviewLayer.cornerRadius = newCaptureVideoPreviewLayer.frame.size.width / 2;
//        [self.view.layer addSublayer:newCaptureVideoPreviewLayer];
//        
//        [self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
//        
//        // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[[self captureManager] session] startRunning];
//            
//        });
//    }
    [super viewDidAppear:animated];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)snapImage:(id)sender {
    if(imgBtn.currentImage == [UIImage imageNamed:@"btnRetake.png"]){
        [imgBtn setImage:[UIImage imageNamed:@"btnCamera.png"] forState:UIControlStateNormal];
        captureImage.hidden = YES;

        
    }
    else if(imgBtn.currentImage == [UIImage imageNamed:@"btnCamera.png"]){
        
    [imgBtn setImage:[UIImage imageNamed:@"btnRetake.png"] forState:UIControlStateNormal];
       

    // Flash the screen white and fade it out to give UI feedback that a still image was taken
//    NSLog(@"image x : %f y %f ", captureImage.bounds.origin.x, captureImage.bounds.origin.y);
//    UIView *flashView = [[UIView alloc] initWithFrame:[captureImage bounds]];
//    [flashView setBackgroundColor:[UIColor whiteColor]];
//    [self.view addSubview:flashView];
//    
//    [UIView animateWithDuration:.4f
//                     animations:^{
//                         [flashView setAlpha:0.f];
//                     }
//                     completion:^(BOOL finished){
//                         [flashView removeFromSuperview];
//                     }];
    

    
    [self.captureManager captureStillImageWithCompletion:^(UIImage *image){
        if (image) {
            //Gotta flip the image cuz it comes out flipped
            image = [UIImage flipImageLeftRight:image];
            NSLog(@"image height: %f width %f ", captureImage.bounds.size.height, captureImage.bounds.size.width);
            captureImage.clipsToBounds = YES;
            captureImage.layer.cornerRadius = captureImage.frame.size.width / 2;
            self.captureImage.contentMode = UIViewContentModeScaleAspectFill;
            captureImage.hidden = NO;
            captureImage.image = image;
            [self.view bringSubviewToFront:captureImage];
            UIImage *croppedImage = [self imageCrop:image];
           imageData = UIImageJPEGRepresentation(croppedImage, 1.0f);
            NSLog(@"namefiled: %@", nameField.text);
            if(![[nameField.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]){
                doneOutlet.hidden = NO;
                [UIView animateWithDuration: 0.4f
                                      delay: 0.0f
                                    options: UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     
                                     doneOutlet.alpha = 1;
                                 }
                                 completion:^(BOOL finished){
                                     
                                     
                                 }
                 ];
            }
        
            } else {
                NSLog(@"error taking pic");
            }
    }];

    }
}

-(void)uploadToImgur:(NSData *)imageDataImgur :(NSString *)name{
    NSString *clientID = @"5e91e7d486fa324";
    
    NSString *title = @"";
    NSString *description = @"";
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    NSString *connected = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://twitter.com/getibox"] encoding:NSUTF8StringEncoding error:nil];
    if (connected == NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops." message: @"I don't think you are connected to the internet." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [SVProgressHUD dismiss];
    }
    else{
    
        [MLIMGURUploader uploadPhoto:imageDataImgur
                               title:title
                         description:description
                       imgurClientID:clientID completionBlock:^(NSString *result) {
                         
                               //Upload to imgur
                               NSLog(@"result url for imgur : %@", result);
                               
                               UserData *userData = [UserData sharedManager];
                               userData.userPhoto = result;
                               
                               //now store data in nsuserdefault
                               NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                               [defaults setObject:userData.userPhoto forKey:@"photo"];
                               [defaults synchronize];
                               [SVProgressHUD dismiss];
                           if(!result){
                               
                               [[[UIAlertView alloc] initWithTitle:@"Upload Failed"
                                                           message:@"Something bad happened. Really bad. Try again."
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK", nil] show];
                                       self.doneOutlet.userInteractionEnabled = YES;

                           }
                           else{
                                [self animateOut];
                               
                           }
                         
                       } failureBlock:^(NSURLResponse *response, NSError *error, NSInteger status) {
                           
                               [[[UIAlertView alloc] initWithTitle:@"Upload Failed"
                                                           message:@"Something bad happened. Really bad. Try again."
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK", nil] show];
                                   self.doneOutlet.userInteractionEnabled = YES;
                       }];
        
    }
    
    



}

-(UIImage*)imageCrop:(UIImage*)original
{
    UIImage *ret = nil;
    
    // This calculates the crop area.
    
    float originalWidth  = original.size.width;
    float originalHeight = original.size.height;
    
    float edge = fminf(originalWidth, originalHeight);
    
    float posX = (originalWidth   - edge) / 2.0f;
    float posY = (originalHeight  - edge) / 2.0f;
    
    
    CGRect cropSquare;
    // If orientation indicates a change to portrait.
    if(original.imageOrientation == UIImageOrientationLeft ||
       original.imageOrientation == UIImageOrientationRight)
    {
        cropSquare = CGRectMake(posY, posX,
                                edge, edge);
        
    }
    else
    {
        cropSquare = CGRectMake(posX, posY,
                                edge, edge);
    }
    
    // This performs the image cropping.
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([original CGImage], cropSquare);
    
    ret = [UIImage imageWithCGImage:imageRef
                              scale:original.scale
                        orientation:original.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return ret;
}


- (IBAction)doneTapped:(id)sender {
    UserData *userData = [UserData sharedManager];
    

    if(userData.userName.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops." message: @"Put your name at the top!" delegate: nil cancelButtonTitle:@"Fine." otherButtonTitles:nil];
        [alert show];
        
    }
    else{
        if(!imageData){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops." message: @"Take a picture of yourself so we know who you are." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        
        }
        else{
             self.doneOutlet.userInteractionEnabled = NO;
        [self uploadToImgur:imageData:userData.userName];
           
        }

    }
}
-(void) animateOut{
    UserData *userData = [UserData sharedManager];
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    [defaults setObject:@"YES" forKey:@"loggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSArray* sublayers = [NSArray arrayWithArray:self.view.layer.sublayers];
    
    //remove the avcam view
    [[sublayers objectAtIndex:(sublayers.count-2)] removeFromSuperlayer];
    
    [UIView animateWithDuration: 1.0f
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         captureImage.alpha = 0.0;
                         imagePreview.alpha = 0.0;
                         doneOutlet.alpha = 0.0;
                         nameField.alpha = 0.0;
                         imgBtn.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         statusLabel.numberOfLines = 2;
                         statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
                         statusLabel.text = [NSString stringWithFormat:@"Have a good time, %@", userData.userName];
                         [UIView animateWithDuration: 0.7f
                                               delay: 0.0f
                                             options: UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              
                                              statusLabel.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished){
                                              [self performSelector:@selector(dismissView:) withObject:self afterDelay:1];
                                              
                                          }
                          ];
                     }];

}
-(void)dismissView:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UpdatesViewController *updatesVC = (UpdatesViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
    updatesVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:updatesVC animated:YES completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UserData *userData = [UserData sharedManager];
    userData.userName = textField.text;
   
    //now store data in nsuserdefault
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    [defaults setObject:userData.userName forKey:@"name"];

    
    [defaults synchronize];
    
    
    [textField resignFirstResponder];
    
    
    if(self.imageData){
            doneOutlet.hidden = NO;
        [UIView animateWithDuration: 0.4f
                              delay: 0.0f
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             doneOutlet.alpha = 1;
                         }
                         completion:^(BOOL finished){
                             
                             
                         }
         ];
    }
         
    return YES;
}



@end
