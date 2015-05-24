//
//  FindUserTableViewCell.m
//  Hi
//
//  Created by Joaquin Pereira on 23/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "FindUserTableViewCell.h"

@implementation FindUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.txt_findUser addTarget:self
                        action:@selector(textUserDidChange)
              forControlEvents:UIControlEventEditingChanged];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - textField Delegate

- (void)textUserDidChange
{
    [self.delegate FindUserTableViewCellDelegateDidWriteText:self.txt_findUser.text];
}


@end
