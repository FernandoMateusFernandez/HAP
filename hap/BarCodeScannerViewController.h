//
//  BarCodeScannerViewController.h
//  HAP
//
//  Created by Joaquin Pereira on 5/12/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BarCodeScannerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;


- (IBAction)startScanning:(id)sender;

@end
