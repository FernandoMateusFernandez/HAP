//
//  InterestProfileCollectionViewCell.h
//  HAP
//
//  Created by Joaquin Pereira on 5/13/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterestProfileCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_interest;
@property (weak, nonatomic) IBOutlet UILabel *lbl_negative;
@property (weak, nonatomic) IBOutlet UILabel *lbl_positive;

@property (weak, nonatomic) IBOutlet UIImageView *img_image;
@property (weak, nonatomic) IBOutlet UILabel *lbl_percentage;

@end
