//
//  QRReaderViewController.m
//  HAP
//
//  Created by Joaquin Pereira on 5/17/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import "QRReaderViewController.h"
#import "SVProgressHUD.h"
#import "HAPSpinnerViewController.h"
#import <Parse/Parse.h>
#import "ProgressIndicatorView.h"


@interface QRReaderViewController ()

@property (strong, nonatomic) PFUser *contact;
@property (strong, nonatomic) UIImage *userImage;
@property (strong, nonatomic) UIImage *contactImage;

@end

@implementation QRReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btn_cancel.layer.cornerRadius = 20;
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[TTMQRCodeReader sharedReader] setDelegate:self];
    [[TTMQRCodeReader sharedReader] startReaderOnView:self.view];
}

#pragma mark - TTMQRCodeReaderDelegate

- (void)didDetectQRCode:(AVMetadataMachineReadableCodeObject *)qrCode {
    
    //NSString *msg = [NSString stringWithFormat:@"Code detected! Looking for user. Wait.."];
    //[SVProgressHUD showSuccessWithStatus:msg];
    
    [self searchUserWithObjectId:qrCode.stringValue];
    
    [[TTMQRCodeReader sharedReader] stopReader];
    
}

-(void)searchUserWithObjectId:(NSString *)objectId
{
    // Message
    
    //Show indicator
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    ProgressIndicatorView *viewProgress = [[ProgressIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 50, self.view.bounds.size.height - 10)
                                                                             transform:CGAffineTransformMakeScale(1.4, 1.4)
                                                                        backgroundView:backView
                                                                   backgroundViewColor:[UIColor clearColor]
                                                                   backgroundViewAlpha:0.6
                                                                             superView:self.view textToShow:@"Looking for user.."];
    
    [viewProgress openPopUp];
    
    
    PFQuery *contactQuery = [PFUser query];
    
    [contactQuery whereKey:@"objectId" equalTo:objectId];
    
    [contactQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        // getting contact
        
        if (error == nil)
        {
            self.contact = [objects lastObject];
            
            PFFile *imageFile = self.contact[@"image"];
            
            
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                // Getting contact Image
                
                if (error == nil)
                {
                    self.contactImage = [UIImage imageWithData:data];
                }
                
                PFUser *user = [PFUser currentUser];
                
                PFFile *imageFile = user[@"image"];
                
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    
                    //getting user image
                    
                    if (error == nil)
                    {
                        self.userImage = [UIImage imageWithData:data];
                        
                        [viewProgress closePopUp];
                        
                        [viewProgress removeFromSuperview];
                        
                        [self performSegueWithIdentifier:@"calculate" sender:self];
                    }
                    
                }];
                
            }];
            
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    HAPSpinnerViewController *cSpinner = [segue destinationViewController];
    
    cSpinner.contact = self.contact;
    cSpinner.contactImage = self.contactImage;
    cSpinner.userImage = self.userImage;
}

- (IBAction)dismissController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
