//
//  QuestionnaireCollectionViewController.h
//  HAP
//
//  Created by Joaquin Pereira on 5/11/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "QuestionCollectionViewCell.h"
#import "QuestionnairePopUpView.h"

@interface QuestionnaireCollectionViewController : UICollectionViewController <QuestionCollectionViewCellDelegate, QuestionnairePopUpViewDelegate>



@end
