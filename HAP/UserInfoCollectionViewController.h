//
//  UserInfoCollectionViewController.h
//  Hi
//
//  Created by Joaquin Pereira on 26/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UserInfoCollectionViewCell.h"
#import "InterestUserInfoCollectionViewCell.h"

@interface UserInfoCollectionViewController : UICollectionViewController <UserInfoCollectionViewCellDelegate>

@property (strong, nonatomic) PFUser *userToShow;

@end
