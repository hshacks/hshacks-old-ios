//
//  UserData.m
//  HSHacks
//
//  Created by Spencer Yen on 2/7/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "UserData.h"

@implementation UserData

@synthesize userName;
@synthesize userPhoto;



//To use singleton
// #import "UserData.h";
//UserData *userData = [UserData sharedManager];
// userData.string = blah blah

+ (id)sharedManager {
    static UserData *userData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userData = [[self alloc] init];
    });
    return userData;
}

- (id)init {
    if (self = [super init]) {
        //Initialize stuff in singleton
  
    }
    return self;
}

@end
