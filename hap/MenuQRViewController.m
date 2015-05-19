//
//  MenuQRViewController.m
//  HAP
//
//  Created by Joaquin Pereira on 5/17/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "MenuQRViewController.h"

@interface MenuQRViewController ()

@end

@implementation MenuQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Navigation Bar
    self.navigationItem.rightBarButtonItem = nil;
    
    // Image a the top
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    image.image = [UIImage imageNamed:@"logoHi_2.png"];
    image.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UIView *sview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    sview.center = self.navigationController.navigationBar.center;
    
    [sview addSubview:image];
    
    self.navigationItem.titleView = sview;
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

@end
