//
//  FindUserTableViewCell.h
//  Hi
//
//  Created by Joaquin Pereira on 23/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FindUserTableViewCellDelegate <NSObject>

-(void)FindUserTableViewCellDelegateDidWriteText:(NSString *)text;

@end

@interface FindUserTableViewCell : UITableViewCell <UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) id<FindUserTableViewCellDelegate>delegate;
@end
