//
//  InterestUserInfoCollectionViewCell.h
//  Hi
//
//  Created by Joaquin Pereira on 26/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterestUserInfoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_percentage;
@property (weak, nonatomic) IBOutlet UILabel *lbl_interest;
@property (weak, nonatomic) IBOutlet UIImageView *img_image;
@property (weak, nonatomic) IBOutlet UILabel *lbl_negative;
@property (weak, nonatomic) IBOutlet UILabel *lbl_positive;

@end
