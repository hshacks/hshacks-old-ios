//
//  GuestLoginViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 2/17/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface GuestLoginViewController : UIViewController <UITextFieldDelegate> {
    BOOL FrontCamera;
    BOOL haveImage;
}


@property (weak, nonatomic) IBOutlet UIImageView *captureImage;

@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (weak, nonatomic) IBOutlet UIView *imagePreview;


@property (weak, nonatomic) IBOutlet UIButton *doneOutlet;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (nonatomic, retain) NSData *imageData;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)snapImage:(id)sender;
- (IBAction)doneTapped:(id)sender;


@end
