//
//  TopViewController.h
//  HAP
//
//  Created by Joaquin Pereira on 5/14/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopViewController : UIView

@property (weak, nonatomic) IBOutlet UIView *viewBar;
@property (weak, nonatomic) IBOutlet UILabel *lbl_percentage;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *viewBackBar;
@property (weak, nonatomic) IBOutlet UIImageView *img_tootlTip;




-(void)startPosition;
-(void)moveToQuestiong:(int)question;

@end
