//
//  UserTableViewCell.m
//  Hi
//
//  Created by Joaquin Pereira on 23/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.img_user.layer.cornerRadius = 25;
    self.img_user.layer.borderColor = [UIColor colorWithRed:0.992 green:0.722 blue:0.004 alpha:1].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
