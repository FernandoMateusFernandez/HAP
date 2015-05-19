//
//  InterestCollectionViewCell.m
//  HAP
//
//  Created by Joaquin Pereira on 5/12/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "InterestCollectionViewCell.h"

@implementation InterestCollectionViewCell


- (void)awakeFromNib
{
    self.img_image.layer.cornerRadius = 35;
    self.img_checkImage.hidden = YES;
}


- (void)hideCheck
{
    self.img_checkImage.hidden = YES;
}



@end
