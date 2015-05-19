//
//  MainViewController.h
//  HAP
//
//  Created by Joaquin Pereira on 07/03/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;

@property (weak, nonatomic) IBOutlet UIView *view_FacebookView;

@end
