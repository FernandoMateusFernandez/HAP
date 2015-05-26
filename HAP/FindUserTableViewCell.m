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

    self.searchBar.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - textField Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.delegate FindUserTableViewCellDelegateDidWriteText:searchText];
}


@end
