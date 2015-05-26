//
//  UserInfoCollectionViewCell.h
//  Hi
//
//  Created by Joaquin Pereira on 26/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserInfoCollectionViewCellDelegate <NSObject>

-(void)UserInfoCollectionViewCellDidDismissController;

@end

@interface UserInfoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_nameSurname;
@property (weak, nonatomic) IBOutlet UILabel *lbl_personality;
@property (weak, nonatomic) IBOutlet UIImageView *img_image;
@property (weak, nonatomic) IBOutlet UILabel *lbl_contactsCounter;
@property (weak, nonatomic) IBOutlet UIButton *btn_done;

@property (strong, nonatomic) id<UserInfoCollectionViewCellDelegate>delegate;

- (IBAction)dismissButton:(id)sender;

@end
