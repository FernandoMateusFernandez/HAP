//
//  Splash1ViewController.h
//  HAP
//
//  Created by Joaquin Pereira on 5/11/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashViewController : UIViewController


@property (nonatomic) NSUInteger pageIndex;

@property (weak, nonatomic) NSString *imageNamed;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIImageView *img_image;

- (IBAction)continue:(id)sender;

@end
