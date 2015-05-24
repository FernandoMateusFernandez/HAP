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

@interface FindUserTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txt_findUser;

@property (strong, nonatomic) id<FindUserTableViewCellDelegate>delegate;
@end
