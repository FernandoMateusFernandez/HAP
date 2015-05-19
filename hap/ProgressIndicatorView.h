//
//  ProgressIndicatorView.h
//  HAP
//
//  Created by Joaquin Pereira on 17/05/15.
//  Copyright (c) 2015 Joaquin Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressIndicatorView : UIView

@property (weak, nonatomic) IBOutlet UIView *viewCenterView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_text;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) UIView *backgroundView;

- (id)initWithFrame:(CGRect)frame
          transform:(CGAffineTransform)transform
     backgroundView:(UIView *)bView
backgroundViewColor:(UIColor *)bColor
backgroundViewAlpha:(CGFloat)bAlpha
          superView:(UIView *)superView
         textToShow:(NSString *)text;


-(void)openPopUp;
-(void)closePopUp;

@end
