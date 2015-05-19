//
//  QuestionCollectionViewCell.m
//  HAP
//
//  Created by Joaquin Pereira on 5/11/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "QuestionCollectionViewCell.h"

@implementation QuestionCollectionViewCell


- (void)awakeFromNib
{
    // Initialization
    self.btn_yesButton.layer.cornerRadius = 20;
    self.btn_noButton.layer.cornerRadius = 20;
    
    self.lbl_lastQuestion.hidden = YES;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.lbl_question.frame = CGRectMake(self.lbl_question.frame.origin.x, self.lbl_question.frame.origin.y, self.frame.size.width - 10, self.lbl_question.frame.size.height);
}

#pragma mark - Actions

- (void)yesButton:(id)sender
{
    [self.delegate QuestionCollectionViewCellDidTouchYesWithCell:self];
}

- (void)noButton:(id)sender
{
    [self.delegate QuestionCollectionViewCellDidTouchNoWithCell:self];
}

@end
