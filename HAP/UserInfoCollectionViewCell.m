//
//  UserInfoCollectionViewCell.m
//  Hi
//
//  Created by Joaquin Pereira on 26/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "UserInfoCollectionViewCell.h"

@implementation UserInfoCollectionViewCell


- (void)awakeFromNib
{
    
    self.img_image.layer.cornerRadius = 60;
    self.img_image.layer.borderColor = [UIColor colorWithRed:0.992 green:0.722 blue:0.004 alpha:1].CGColor;
    self.img_image.layer.borderWidth = 2;
    
    self.btn_done.layer.cornerRadius = 20;
}

- (IBAction)addContact:(id)sender {
    
    [self.delegate UserInfoCollectionViewCellAddUser];
}
@end
