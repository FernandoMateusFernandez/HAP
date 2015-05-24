//
//  UserTableViewCell.h
//  Hi
//
//  Created by Joaquin Pereira on 23/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_user;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@end
