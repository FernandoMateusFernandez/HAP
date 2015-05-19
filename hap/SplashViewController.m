//
//  Splash1ViewController.m
//  HAP
//
//  Created by Joaquin Pereira on 5/11/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.img_image.image = [UIImage imageNamed:self.imageNamed];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if(self.pageIndex != 4)
    {
        self.continueButton.hidden = YES;
    }
    else
    {
        self.continueButton.hidden = NO;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)continue:(id)sender {
    
    [self performSegueWithIdentifier:@"login" sender:self];
    
    
    // Save nsuserdefaults
    NSUserDefaults *userDefautls = [NSUserDefaults standardUserDefaults];
    
    [userDefautls setObject:[NSNumber numberWithBool:YES] forKey:@"introSeen"];
    
    [userDefautls synchronize];
}
@end
