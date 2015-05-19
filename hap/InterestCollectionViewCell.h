//
//  InterestCollectionViewCell.h
//  HAP
//
//  Created by Joaquin Pereira on 5/12/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterestCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_image;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UIImageView *img_checkImage;

-(void)hideCheck;

@end
