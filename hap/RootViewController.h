//
//  RootViewController.h
//  HAP
//
//  Created by Joaquin Pereira on 5/11/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>


@property (strong, nonatomic) UIPageViewController *pageViewController;

- (IBAction)skipIntro:(id)sender;
@end
