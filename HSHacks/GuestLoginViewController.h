//
//  GuestLoginViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface GuestLoginViewController : UIViewController{
    BOOL FrontCamera;
    BOOL haveImage;
}

@property (weak, nonatomic) IBOutlet UIImageView *captureImage;

@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (weak, nonatomic) IBOutlet UIView *imagePreview;

- (IBAction)snapImage:(id)sender;

@end
