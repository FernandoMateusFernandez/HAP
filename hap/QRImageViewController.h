//
//  QRImageViewController.h
//  HAP
//
//  Created by Joaquin Pereira on 5/16/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreImage;

@interface QRImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UIImageView *img_image;
@property (weak, nonatomic) IBOutlet UIImageView *img_QR;
@property (weak, nonatomic) IBOutlet UIButton *btn_done;

- (IBAction)dismissController:(id)sender;
@end
