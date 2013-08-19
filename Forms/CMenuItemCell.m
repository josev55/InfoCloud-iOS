//
//  CMenuItemCell.m
//  Forms
//
//  Created by Jose Vildosola on 12-08-13.
//  Copyright (c) 2013 Jose Vildosola. All rights reserved.
//

#import "CMenuItemCell.h"

@implementation CMenuItemCell

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
