//
//  ResultTableViewCell.h
//  HAP
//
//  Created by Joaquin Pereira on 5/17/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_user;
@property (weak, nonatomic) IBOutlet UILabel *lbl_user;
@property (weak, nonatomic) IBOutlet UIImageView *img_contact;
@property (weak, nonatomic) IBOutlet UILabel *lbl_contactName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_pertentage;
@end
