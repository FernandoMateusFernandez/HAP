//
//  ResultTableViewCell.m
//  HAP
//
//  Created by Joaquin Pereira on 5/17/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "ResultTableViewCell.h"

@implementation ResultTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.img_user.layer.cornerRadius = 45;
    self.img_contact.layer.cornerRadius = 45;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
