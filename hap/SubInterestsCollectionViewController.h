//
//  SubInterestsCollectionViewController.h
//  HAP
//
//  Created by Joaquin Pereira on 5/12/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "NextCollectionViewCell.h"

@interface SubInterestsCollectionViewController : UICollectionViewController <NextCollectionViewCellDelegate>

@property (strong, nonatomic) NSArray *aInterest;





@end
