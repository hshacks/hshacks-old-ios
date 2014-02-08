//
//  ChatTableCell.m
//  HSHacks
//
//  Created by Spencer Yen on 2/8/14.
//  Copyright (c) 2014 hshacks.com. All rights reserved.
//

#import "ChatTableCell.h"

@implementation ChatTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
