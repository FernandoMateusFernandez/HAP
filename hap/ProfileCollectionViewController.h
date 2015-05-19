//
//  ProfileCollectionViewController.h
//  HAP
//
//  Created by Joaquin Pereira on 5/13/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ProfileCollectionViewCell.h"
#import "InterestCollectionViewCell.h"
#import "InterestsHeaderCollectionViewCell.h"
#import "InterestProfileCollectionViewCell.h"

@interface ProfileCollectionViewController : UICollectionViewController <ProfileCollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@end
