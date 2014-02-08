//
//  UserData.h
//  HSHacks
//
//  Created by Spencer Yen on 2/7/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject{
    NSString *userName;
    NSURL *userPhotoURL;
    
    
}


+ (id)sharedManager;

@property (nonatomic,retain)NSString *userName;
@property (nonatomic,retain)NSURL *userPhotoURL;

@end
