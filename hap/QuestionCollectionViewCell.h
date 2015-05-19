//
//  QuestionCollectionViewCell.h
//  HAP
//
//  Created by Joaquin Pereira on 5/11/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@class QuestionCollectionViewCell;
@protocol QuestionCollectionViewCellDelegate <NSObject>

-(void) QuestionCollectionViewCellDidTouchYesWithCell:(QuestionCollectionViewCell *)cell;
-(void) QuestionCollectionViewCellDidTouchNoWithCell:(QuestionCollectionViewCell *)cell;

@end

@interface QuestionCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_question;
@property (weak, nonatomic) IBOutlet UIImageView *img_image;

@property (weak, nonatomic) IBOutlet UIButton *btn_yesButton;
@property (weak, nonatomic) IBOutlet UIButton *btn_noButton;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_lastQuestion;


// Eysenck

@property (strong, nonatomic) NSString *letter;
@property (strong, nonatomic) NSNumber *value;

@property (strong, nonatomic) id<QuestionCollectionViewCellDelegate>delegate;

- (IBAction)yesButton:(id)sender;
- (IBAction)noButton:(id)sender;

@end
