//
//  ProfileCollectionViewCell.h
//  HAP
//
//  Created by Joaquin Pereira on 5/13/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileCollectionViewCellDelegate <NSObject>

-(void) ProfileCollectionViewCellDidTouchPicture;

@end

@interface ProfileCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UIImageView *img_image;
@property (weak, nonatomic) IBOutlet UILabel *lbl_contacts;
@property (weak, nonatomic) IBOutlet UIImageView *img_imageContacts;
@property (weak, nonatomic) IBOutlet UILabel *lbl_percentage;

@property (weak, nonatomic) IBOutlet UILabel *lbl_a;
@property (weak, nonatomic) IBOutlet UILabel *lbl_b;
@property (weak, nonatomic) IBOutlet UILabel *lbl_c;
@property (weak, nonatomic) IBOutlet UILabel *lbl_d;
@property (weak, nonatomic) IBOutlet UILabel *lbl_e;

@property (weak, nonatomic) IBOutlet UILabel *lbl_personality;
@property (weak, nonatomic) IBOutlet UIView *viewAverageView;
@property (weak, nonatomic) IBOutlet UIView *viewChartView;
@property (weak, nonatomic) IBOutlet UIButton *btn_addUser;

@property (strong, nonatomic) id<ProfileCollectionViewCellDelegate>delegate;
@end
