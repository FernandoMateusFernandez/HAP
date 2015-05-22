//
//  MainViewController.m
//  HAP
//
//  Created by Joaquin Pereira on 07/03/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "MainViewController.h"
#import <Parse/Parse.h>
#import "ProgressIndicatorView.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txt_email.delegate = self;
    self.txt_password.delegate = self;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
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

#pragma mark - TextField

- (void)setReturnKey {
    //use condition here(not empty field)
    
    //self.searchField.returnKeyType = UIReturnKeyGo;
    
    NSLog(@"Next");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0)
    {
        [textField resignFirstResponder];
        
        [self.txt_password becomeFirstResponder];
        
    }
    else if (textField.tag == 1) {
        
        // login
        
        [self.txt_password resignFirstResponder];
        
        //Show indicator
        UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        ProgressIndicatorView *viewProgress = [[ProgressIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 50, self.view.bounds.size.height - 10)
    transform:CGAffineTransformMakeScale(1.4, 1.4)
    backgroundView:backView
    backgroundViewColor:[UIColor clearColor]
    backgroundViewAlpha:0.6
    superView:self.view textToShow:@"Logging in"];
        
        [viewProgress openPopUp];
        
        
        [PFUser logInWithUsernameInBackground:self.txt_email.text password:self.txt_password.text
                                        block:^(PFUser *user, NSError *error){
                                            
                                            
                                            if (error == nil)
                                            {
                                                
                                                [viewProgress closePopUp];
                                                
                                                [viewProgress removeFromSuperview];
                                                
                                                NSString *neurotype = user[@"neurotype"];
                                                
                                                if (neurotype == nil || [neurotype isEqualToString:@""])
                                                {
                                                    [self performSegueWithIdentifier:@"questionnaire" sender:self];
                                                }
                                                else
                                                {
                                                    [self performSegueWithIdentifier:@"profile" sender:self];
                                                }
                                                
                                                
                                            }
                                            
        }];
        
    }
         
    return YES;
}
@end
