//
//  NextCollectionViewCell.m
//  HAP
//
//  Created by Joaquin Pereira on 5/12/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "NextCollectionViewCell.h"

@implementation NextCollectionViewCell


- (void)awakeFromNib
{
    self.btn_next.layer.cornerRadius = self.btn_next.frame.size.height/2;
}

- (void)nextController:(id)sender
{
    [self.delegate NextCollectionViewCellDidTouchNext];
}

@end
