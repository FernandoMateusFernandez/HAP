//
//  QRReaderViewController.h
//  HAP
//
//  Created by Joaquin Pereira on 5/17/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMQRCodeReader.h"
@import AVFoundation;

@interface QRReaderViewController : UIViewController <TTMQRCodeReaderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
- (IBAction)dismissController:(id)sender;
@end
