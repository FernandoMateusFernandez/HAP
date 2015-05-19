//
//  ProfileCollectionViewCell.m
//  HAP
//
//  Created by Joaquin Pereira on 5/13/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "ProfileCollectionViewCell.h"

@implementation ProfileCollectionViewCell

-(void)awakeFromNib
{
    self.viewAverageView.layer.cornerRadius = 31;
    self.viewChartView.layer.cornerRadius = 35;
    
    //self.viewChartView.layer.borderWidth = 1;
    //self.viewChartView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.img_image.layer.cornerRadius = 60;
    self.img_image.layer.borderColor = [UIColor colorWithRed:0.992 green:0.722 blue:0.004 alpha:1].CGColor;
    self.img_image.layer.borderWidth = 2;
    
    // Touch gestures
    
    UITapGestureRecognizer *tapPicture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture)];
}


-(void)tapPicture
{
    [self.delegate ProfileCollectionViewCellDidTouchPicture];
}

@end
